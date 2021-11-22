//
//  SearchScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/10/21.
//

import SwiftUI

struct SearchScreen: View {
    @Environment(\.managedObjectContext) var context
    var colorSet: TimeColor.ColorSet
    @State private var selectedActivity: Activity?
    
    var body: some View {
        ZStack {
            background
            
            VStack(alignment: .leading) {
                searchAndFilter.padding()
                activitiesList.padding()
            }
        }
    }
    
    var background: some View {
        colorSet.main.ignoresSafeArea()
    }
    
    var searchAndFilter: some View {
        SearchBarAndFilterButtonView(colorSet: colorSet)
    }
    
    var activitiesList: some View {
        ActivitiesFilteredListView(filter: Activity.Filter.init()) { activity in
            selectedActivity = activity
        }
    }
    
    struct DrawingConstanst {
        static let selectedDateAnimationDuration: CGFloat = 0.1
        static let calendarAndDateSelectorHeight: CGFloat = 50
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen(colorSet: TimeColor.noon.color)
    }
}
