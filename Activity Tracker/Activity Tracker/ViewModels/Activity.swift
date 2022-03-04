//
//  Activity.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import CoreData
import SwiftUI
import CoreLocation

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
    
    private var latitude: Double {
        get { latitude_ }
        set { latitude_ = newValue}
    }
    
    private var longtitude: Double {
        get { longtitude_ }
        set { longtitude_ = newValue}
    }
    
    var coordinate: CLLocationCoordinate2D? {
        get {
            if latitude == 0 && longtitude == 0 { return nil }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longtitude) }
        set {
            latitude = newValue?.latitude ?? 0
            longtitude = newValue?.longitude ?? 0
        }
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
        
        var folders: Set<Folder> = []
        
        var trips: Set<Trip> = []
        
        var note: String?
        
        var photosFilter = false
        
        var locationFilter = false
        
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
            var filterTags: [Tag] = []
            
            if tags.count > 0 {
                filterTags.append(contentsOf: tags)
            }
            
            if folders.count > 0 {
                filterTags.append(contentsOf: folders.flatMap { $0.tags })
            }
            
            guard filterTags.count > 0  else { return [] }
            
            return [
                NSPredicate(format: "ANY tags_ in %@ ", filterTags)
            ]
        }
        
        private var tripsPredicate: [NSPredicate] {
            guard trips.count > 0 else { return [] }
            
            return [
                NSPredicate(format: "ANY trip_ in %@", trips)
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
        
        private var locationPredicate: [NSPredicate] {
            if locationFilter {
                return [
                    NSPredicate(format: "latitude_ != 0"),
                    NSPredicate(format: "longtitude_ != 0")
                ]
            }
            
            return []
        }
        
        var predicate: NSPredicate {
            NSCompoundPredicate(andPredicateWithSubpredicates: notePredicate +  selectedDatePredicate + tagsAndFolderPredicate + tripsPredicate + photosPredicate + locationPredicate)
        }
        
        var sort: [NSSortDescriptor] {
            [
                NSSortDescriptor(key: "timeStamp_", ascending: sortFromOldest)
            ]
        }
        
    }
}

extension Activity {
    static func save(activity: Activity, with data: (time: Date, tags: Set<Tag>, photos: Set<Photo>, note: String, trip: Trip?, location: CLLocationCoordinate2D? ), in context: NSManagedObjectContext) throws {
        if data.tags.count == 0 {
            throw DataError.dataValidationFailed("an activity requires at least one tag")
        }
        
        activity.time = data.time
        activity.tags = data.tags
        activity.note = data.note
        activity.photos = data.photos
        activity.trip_ = data.trip
        activity.coordinate = data.location
        
        if context.hasChanges {
            try? context.save()
        }
    }
    
    static func remove(_ activity: Activity, in context: NSManagedObjectContext) {
        context.delete(activity)
        
        if context.hasChanges {
            try? context.save()
        }
    }
}

extension Activity {
    var featureIcons: [String] {
        var icons = [String]()
        
        if photos.count > 0 {
            icons.append("photo.fill")
        }
        
        if coordinate != nil {
            icons.append("map.fill")
        }
        
        return icons
    }
}
