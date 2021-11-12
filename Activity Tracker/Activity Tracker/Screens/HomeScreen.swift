//
//  HomeScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/8/21.
//

import SwiftUI
import CoreData
import SwiftUIFlowLayout

typealias ActivityDetailHandler = (Activity) -> Void

struct HomeScreen: View {
    @State private var selectedDate = Date()
    @State private var showActivityDetail = false
    @State private var selectedActivity: Activity?
    var colorSet: TimeColor.ColorSet
    
    var body: some View {
        ZStack {
            background
            
            VStack(alignment: .leading) {
                selectedDateTime.padding()
                calendarAndDateSelector.frame(height: 50).padding(.horizontal)
                activitiesList.padding()
            }
        }
        .sheet(item: $selectedActivity) { activity in
            DetailScreen(activity: activity)
        }
    }
    
    var background: some View {
        colorSet.main.ignoresSafeArea()
    }
    
    var selectedDateTime: some View {
        Text.header(selectedDate.weekDayMonthYearFormattedString).foregroundColor(colorSet.textColor)
    }
    
    var calendarAndDateSelector: some View {
        CalendarAndDateSelectorView(selectedDate: $selectedDate, colorSet: colorSet)
    }
    
    var activitiesList: some View {
        ActivitiesListView(filter: Activity.Filter.init(selectedDate: selectedDate)) { activity in
            selectedActivity = activity
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(colorSet: Helpers.colorByTime()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
