//
//  Activity.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import CoreData

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
        get { (tags_ as? Set<Tag>) ?? [] }
        set { tags_ = newValue as NSSet }
    }
}
