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
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @State private var selectedDate = Date()
    @State private var showActivityDetail = false
    @State private var selectedActivity: Activity?
    var colorSet: TimeColor.ColorSet
    
    var body: some View {
        ZStack {
            background
            
            VStack(alignment: .leading) {
                selectedDateTime.padding()
                calendarAndDateSelector.frame(height: DrawingConstanst.calendarAndDateSelectorHeight).padding(.horizontal)
                activitiesList.padding()
            }
        }
        .sheet(item: $selectedActivity) { activity in
            DetailScreen(activity: activity)
                .environment(\.managedObjectContext, context)
        }
    }
    
    var background: some View {
        colorSet.main.ignoresSafeArea()
    }
    
    var selectedDateTime: some View {
        Text.header(selectedDate.weekDayMonthYearFormattedString)
            .foregroundColor(colorSet.textColor)
            .animation(.easeInOut(duration: DrawingConstanst.selectedDateAnimationDuration), value: selectedDate)
    }
    
    var calendarAndDateSelector: some View {
        CalendarAndDateSelectorView(selectedDate: $selectedDate, colorSet: colorSet)
    }
    
    var activitiesList: some View {
        ActivitiesListView(filter: Activity.Filter.init(selectedDate: selectedDate)) { activity in
            selectedActivity = activity
        }
    }
    
    struct DrawingConstanst {
        static let selectedDateAnimationDuration: CGFloat = 0.1
        static let calendarAndDateSelectorHeight: CGFloat = 50
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(colorSet: Helpers.colorByTime()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
