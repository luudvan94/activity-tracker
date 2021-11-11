//
//  Folder.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import Foundation

extension Folder {
    var name: String {
        get { name_ ?? "" }
        set { name_ = newValue }
    }
    
    var tags: Set<Tag> {
        get { (tags_ as? Set<Tag>) ?? []}
        set {
            tags_ = newValue as NSSet
        }
    }

}
