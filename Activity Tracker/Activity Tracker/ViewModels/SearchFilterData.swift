//
//  SearchFilterData.swift
//  Activity Tracker
//
//  Created by luu van on 11/22/21.
//

import Combine

class SearchFilterData: ObservableObject {
    @Published var tags: Set<Tag> = []
    @Published var folder: Folder? = nil
    @Published var shouldFilterPhotos = false
    
    var activityFilter: Activity.Filter {
        Activity.Filter.init(selectedDate: nil, tags: tags, selectedFolder: folder, photosFilter: shouldFilterPhotos)
    }
    
    var isBeingFilted: Bool {
        !tags.isEmpty || folder != nil || shouldFilterPhotos
    }
}
