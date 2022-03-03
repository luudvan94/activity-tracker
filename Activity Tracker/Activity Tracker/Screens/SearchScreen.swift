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
                filterTools
                activitiesList
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
        FilterToolsView(sortDirection: $searchFilterData.sortDirection) {
            searchFilterData.sortDirection = searchFilterData.sortDirection == .ascending ? .descending : .ascending
        }
    }
    
    var activitiesList: some View {
        ActivitiesFilteredListView(filter: searchFilterData.activityFilter) { activity in
            selectedActivity = activity
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
