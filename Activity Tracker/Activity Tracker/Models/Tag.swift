//
//  Tag.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import CoreData

extension Tag {
    var name: String {
        get { name_ ?? "" }
        set { name_ = newValue }
    }
    
    var folder: Folder? {
        get { folder_ }
        set { folder_ = newValue }
    }
    
    var activities: Set<Activity> {
        get { (activities_ as? Set<Activity>) ?? [] }
        set { activities_ = newValue as NSSet }
    }
}

