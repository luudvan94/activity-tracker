//
//  HomeScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/8/21.
//

import SwiftUI
import CoreData
import SwiftUIFlowLayout

struct HomeScreen: View {
    @State private var selectedDate = Date()
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
    }
    
    var background: some View {
        colorSet.main.ignoresSafeArea()
    }
    
    var selectedDateTime: some View {
        Text.header(selectedDate.weekDayMonthYearFormattedString)
    }
    
    var calendarAndDateSelector: some View {
        CalendarAndDateSelectorView(selectedDate: $selectedDate, hightlightColor: colorSet.main)
    }
    
    var activitiesList: some View {
        ActivitiesListView(filter: Activity.Filter.init(selectedDate: selectedDate))
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(colorSet: Helpers.colorByTime()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
