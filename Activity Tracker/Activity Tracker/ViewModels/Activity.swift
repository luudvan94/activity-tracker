//
//  Activity.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import CoreData
import SwiftUI

extension Activity: Entity {
    static var entityName = "Activity"
    static var eventType = "Activity"
}

extension Activity {
    var note: String {
        get {
            if let note = note_, note != "" { return note }
            return "there isn't any note for this activity 🥲"
        }
        set { note_ = newValue }
    }
    
    var time: Date {
        get { timeStamp_ ?? Date() }
        set { timeStamp_ = newValue }
    }
    
    var tags: Set<Tag> {
        get { ((tags_ as? Set<Tag>) ?? []) }
        set { tags_ = newValue as NSSet }
    }
    
    var photos: Set<Photo> {
        get { ((photos_ as? Set<Photo>) ?? []) }
        set { photos_ = newValue as NSSet }
    }
}

extension Activity {
    static func fetchRequest(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor] = []) -> NSFetchRequest<Activity> {
        let request = NSFetchRequest<Activity>(entityName: Activity.entityName)
        if sortDescriptors.isEmpty {
            request.sortDescriptors = [ NSSortDescriptor(key: "timeStamp_", ascending: true) ]
        } else {
            request.sortDescriptors = sortDescriptors
        }
        request.predicate = predicate
        return request
    }
}

extension Activity {
    struct Filter: Searchable {
        
        var selectedDate: Date?
        
        var tags: Set<Tag> = []
        
        var selectedFolder: Folder?
        
        var note: String?
        
        var photosFilter = false
        
        var sortFromOldest = true
        
        private var notePredicate: [NSPredicate] {
            guard let note = note, note != "" else { return []}
            
            return [
                NSPredicate(format: "note_ CONTAINS[cd] %@", note)
            ]
        }
        
        private var selectedDatePredicate: [NSPredicate] {
            guard let selectedDate = selectedDate else { return [NSPredicate(format: "timeStamp_ != nil")] }
            
            return [
                NSPredicate(format: "timeStamp_ >= %@", selectedDate.startOfDay as NSDate),
                NSPredicate(format: "timeStamp_ <= %@", selectedDate.endOfDay as NSDate)
            ]
        }
        
        private var tagsAndFolderPredicate: [NSPredicate] {
            var filterdTags: [Tag] = []
            
            if tags.count > 0 {
                filterdTags.append(contentsOf: tags)
            }
            
            if let selectedFolder = selectedFolder {
                filterdTags.append(contentsOf: selectedFolder.tags)
            }
            
            guard filterdTags.count > 0  else { return [] }
            
            return [
                NSPredicate(format: "ANY tags_ in %@ ", filterdTags)
            ]
        }
        
        private var photosPredicate: [NSPredicate] {
            if photosFilter {
                return [
                    NSPredicate(format: "photos_.@count > 0")
                ]
            }
            
            return []
        }
        
        var predicate: NSPredicate {
            NSCompoundPredicate(andPredicateWithSubpredicates: notePredicate +  selectedDatePredicate + tagsAndFolderPredicate + photosPredicate)
        }
        
        var sort: [NSSortDescriptor] {
            [
                NSSortDescriptor(key: "timeStamp_", ascending: sortFromOldest)
            ]
        }
        
    }
}

extension Activity {
    static func save(activity: Activity, with data: (time: Date, tags: Set<Tag>, photos: Set<Photo>, note: String, trip: Trip?), in context: NSManagedObjectContext) throws {
        if data.tags.count == 0 {
            throw DataError.dataValidationFailed("an activity requires at least one tag")
        }
        
        activity.time = data.time
        activity.tags = data.tags
        activity.note = data.note
        activity.photos = data.photos
        activity.trip_ = data.trip
        
        if context.hasChanges {
            try? context.save()
        }
    }
    
    static func remove(_ activity: Activity, in context: NSManagedObjectContext) {
        context.delete(activity)
    }
}
