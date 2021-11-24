//
//  SearchFilterData.swift
//  Activity Tracker
//
//  Created by luu van on 11/22/21.
//

import Combine

class SearchFilterData: ObservableObject {
    enum SortDirection {
        case ascending
        case descending
    }
    
    @Published var tags: Set<Tag> = []
    @Published var folder: Folder? = nil
    @Published var shouldFilterPhotos = false
    @Published var sortDirection: SortDirection = .descending
    
    var activityFilter: Activity.Filter {
        Activity.Filter.init(selectedDate: nil, tags: tags, selectedFolder: folder, photosFilter: shouldFilterPhotos, sortFromOldest: sortDirection == .descending)
    }
    
    var isBeingFilted: Bool {
        !tags.isEmpty || folder != nil || shouldFilterPhotos
    }
}
