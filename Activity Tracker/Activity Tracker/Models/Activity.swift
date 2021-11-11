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
}

extension Activity {
    var note: String {
        get { note_ ?? "" }
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
}

extension Activity {
    static func fetchRequest(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor] = []) -> NSFetchRequest<Activity> {
        let request = NSFetchRequest<Activity>(entityName: Activity.entityName)
        request.sortDescriptors = [
            NSSortDescriptor(key: "timeStamp_", ascending: true)
        ]
        request.predicate = predicate
        return request
    }
}

extension Activity {
    struct Filter: Searchable {
        
        var selectedDate: Date
        
        var predicate: NSPredicate {
            NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "timeStamp_ >= %@", selectedDate.startOfDay as NSDate),
                NSPredicate(format: "timeStamp_ <= %@", selectedDate.endOfDay as NSDate)
            ])
        }
        
    }
}
