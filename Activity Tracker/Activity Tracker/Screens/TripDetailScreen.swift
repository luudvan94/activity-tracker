//
//  TripDetailScreen.swift
//  Activity Tracker
//
//  Created by luu van on 2/28/22.
//

import SwiftUI
import CoreData

struct TripDetailScreen: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @EnvironmentObject var searchFilterData: SearchFilterData
    @EnvironmentObject var appSetting: AppSetting
    @State private var selectedActivity: Activity?
        
    @ObservedObject var trip: Trip
    var colorSet: DayTime.ColorSet {
        Helpers.colorByTime(trip.time)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            colorSet.main
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    dayAndTime
                    tripName
                    
                    content()
                }
                .padding()
            }
        }
        .ignoresSafeArea(.all, edges: Edge.Set.bottom)
        .sheet(item: $selectedActivity) { activity in
            ActivityDetailScreen(activity: activity)
                .environment(\.managedObjectContext, context)
                .environmentObject(searchFilterData)
                .environmentObject(appSetting)
        }
    }
    
    var dayAndTime: some View {
        VStack(alignment: .leading) {
            Text.header(trip.time.weekDayMonthYearFormattedString)
            Text.header(trip.time.hourAndMinuteFormattedString)
        }
        .foregroundColor(colorSet.textColor)
    }
    
    var tripName: some View {
        HStack {
            Image(systemName: "airplane").font(.largeTitle)
            Text.header(trip.name)
        }
        .foregroundColor(colorSet.textColor)
    }
    
    @ViewBuilder
    func content() -> some View {
        if trip.activities.count > 0 {
            let sortedActivities = trip.activities.sorted { $0.time < $1.time }
            EventsListContainer {
                ForEach(sortedActivities) { activity in
                    ActivityCardView(activity: activity) { activity in
                        selectedActivity = activity
                    }
                }
            }
        } else {
            Text.regular(Labels.noActivitiesAssociated).foregroundColor(colorSet.textColor)
        }
    }
}

struct TripDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailScreen(trip: Trip())
    }
}
