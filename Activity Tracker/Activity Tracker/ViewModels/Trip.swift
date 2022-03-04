//
//  Trip.swift
//  Activity Tracker
//
//  Created by luu van on 2/28/22.
//

import CoreData
import SwiftUI

extension Trip: Entity {
    static var entityName = "Trip"
}

extension Trip {
    var note: String? {
        get {
            if let note = note_, note != "" { return note }
            return nil
        }
        set { note_ = newValue }
    }
    
    var name: String {
        get {
            if let name = name_, name != "" { return name }
            return "this group supposed to have a name"
        }
        set { name_ = newValue }
    }
    
    var time: Date {
        get { timeStamp_ ?? Date() }
        set { timeStamp_ = newValue }
    }
    
    var activities: Set<Activity> {
        get { (activities_ as? Set<Activity>) ?? [] }
        set { activities_ = newValue as NSSet }
    }
}

extension Trip {
    static func fetchRequest(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor] = []) -> NSFetchRequest<Trip> {
        let request = NSFetchRequest<Trip>(entityName: Trip.entityName)
        if sortDescriptors.isEmpty {
            request.sortDescriptors = [ NSSortDescriptor(key: "timeStamp_", ascending: true)]
        } else {
            request.sortDescriptors = sortDescriptors
        }
        request.predicate = predicate
        return request
    }
}

extension Trip {
    struct Filter: Searchable {
        
        var selectedDate: Date?
        
        var sortFromOldest = true
        
        var predicate: NSPredicate {
            guard let selectedDate = selectedDate else { return NSCompoundPredicate(andPredicateWithSubpredicates: []) }
            
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "timeStamp_ >= %@", selectedDate.startOfDay as NSDate),
                NSPredicate(format: "timeStamp_ <= %@", selectedDate.endOfDay as NSDate)
            ])
        }
        
        var sort: [NSSortDescriptor] {
            [
                NSSortDescriptor(key: "timeStamp_", ascending: sortFromOldest)
            ]
        }
        
        
    }
}

extension Trip {
    static func save(trip: Trip, with data: (time: Date, name: String, note: String), in context: NSManagedObjectContext) throws {
        if data.name == "" {
            throw DataError.dataValidationFailed("a trip must have a name")
        }
        
        trip.time = data.time
        trip.name = data.name
        trip.note = data.note
        
        if context.hasChanges {
            try? context.save()
        }
    }
}
