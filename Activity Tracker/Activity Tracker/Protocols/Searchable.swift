//
//  Filter.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import CoreData

enum Sorting {
    case ascending
    case descending
    case none
}

protocol Searchable {
    var predicate: NSPredicate { get }
}

extension Searchable {
}

