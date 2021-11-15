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

extension Tag {
    static func save(tag: Tag, with data: (tagName: String, folder: Folder), in context: NSManagedObjectContext) throws {
        tag.name = data.tagName
        tag.folder = data.folder
        
        if context.hasChanges {
            try? context.save()
        }
    }
    
    static func save(tag: Tag, with data: (tagName: String, folderName: String), in context: NSManagedObjectContext) throws {
        let folder = Folder(context: context)
        folder.name = data.folderName
        
        tag.name = data.tagName
        tag.folder = folder
        
        if context.hasChanges {
            try? context.save()
        }
    }
}

