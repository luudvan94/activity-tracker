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
    @Published var folders: Set<Folder> = []
    @Published var trips: Set<Trip> = []
    @Published var shouldFilterPhotos = false
    @Published var shouldFilterLocation = false
    @Published var sortDirection: SortDirection = .descending
    @Published var searchText = ""
    @Published var showListDisplay = true
    @Published var showMapDisplay = false
    @Published var showPhotoDisplay = false
    
    var activityFilter: Activity.Filter {
        Activity.Filter.init(selectedDate: nil, tags: tags, folders: folders, trips: trips, note: searchText, photosFilter: shouldFilterPhotos, locationFilter: shouldFilterLocation, sortFromOldest: sortDirection == .descending)
    }
    
    var isBeingFilted: Bool {
        !tags.isEmpty || !folders.isEmpty || shouldFilterPhotos || shouldFilterLocation
    }
    
    func display(map: Bool = false, list: Bool = false, photo: Bool = false) {
        showListDisplay = list
        showMapDisplay = map
        showPhotoDisplay = photo
    }
}
