//
//  SearchScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/10/21.
//

import SwiftUI

struct SearchScreen: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var searchFilterData: SearchFilterData
    @EnvironmentObject var appSetting: AppSetting
    
    @State private var selectedActivity: Activity?
    @State private var showFilterScreen = false
    
    var body: some View {
        ZStack {
            background
            
            VStack(alignment: .leading, spacing: 10) {
                searchAndFilter
                filterTools.frame(height: 50)
                
                displayingContent
            }
            .padding(.horizontal)
        }
        .sheet(item: $selectedActivity) { activity in
            ActivityDetailScreen(activity: activity)
                .environment(\.managedObjectContext, context)
                .environmentObject(searchFilterData)
                .environmentObject(appSetting)
        }
        .sheet(isPresented: $showFilterScreen) {
            FilterScreen()
                .environmentObject(searchFilterData)
                .environmentObject(appSetting)
        }
    }
    
    var colorSet: DayTime.ColorSet {
        appSetting.colorSet
    }
    
    var background: some View {
        colorSet.main.ignoresSafeArea()
    }
    
    var searchAndFilter: some View {
        SearchBarAndFilterButtonView(onFilterTap: {
            showFilterScreen = true
        }, onSearchText: onSearch)
    }
    
    var filterTools: some View {
        HStack {
            sort
            Spacer()
            
            HStack {
                list
                map
                photo
            }
        }
    }
    
    @ViewBuilder
    var displayingContent: some View {
        if appSetting.showListDisplay {
            activitiesList
        } else if appSetting.showMapDisplay {
            activitiesMap
        } else {
            activityPhotos
        }
    }
    
    var sort: some View {
        SortingToolView(sortDirection: $searchFilterData.sortDirection) {
            searchFilterData.sortDirection = searchFilterData.sortDirection == .ascending ? .descending : .ascending
        }
    }
    
    var list: some View {
        displayToolView(iconName: "list.bullet.rectangle.portrait.fill", isSelected: appSetting.showListDisplay) {
            appSetting.display(list: true)
        }
    }
    
    var map: some View {
        displayToolView(iconName: "map.fill", isSelected: appSetting.showMapDisplay) {
            appSetting.display(map: true)
        }
    }
    
    var photo: some View {
        displayToolView(iconName: "photo.fill", isSelected: appSetting.showPhotoDisplay) {
            appSetting.display(photo: true)
        }
    }
    
    var activitiesList: some View {
        ActivitiesFilteredListView(filter: searchFilterData.activityFilter) { activity in
            selectedActivity = activity
        }
    }
    
    var activitiesMap: some View {
        ActivitiesMapView(filter: searchFilterData.activityFilter, centerActivity: appSetting.mapCenteredActivity) { activity in
            selectedActivity = activity
        }
    }
    
    var activityPhotos: some View {
        ActivityPhotosView(filter: searchFilterData.activityFilter)
    }
    
    @ViewBuilder
    private func displayToolView(iconName: String, isSelected: Bool, onSelected: @escaping () -> Void) -> some View {
        HStack(alignment: .center) {
            Image(systemName: iconName).font(.title3).foregroundColor(colorSet.shadow)
            
            Image(systemName: "circle.fill")
                .font(.footnote)
                .foregroundColor(isSelected ? colorSet.main : .white)
            
        }
        .padding(10)
        .buttonfity {
            onSelected()
        }
    }
    
    private func onSearch(_ text: String) {
        searchFilterData.searchText = text
    }
    
    struct DrawingConstanst {
        static let selectedDateAnimationDuration: CGFloat = 0.1
        static let calendarAndDateSelectorHeight: CGFloat = 50
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
    }
}
