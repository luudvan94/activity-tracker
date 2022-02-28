//
//  ActivitiesFilteredListView.swift
//  Activity Tracker
//
//  Created by luu van on 11/22/21.
//

import SwiftUI

struct ActivitiesFilteredListView: View {
    @EnvironmentObject var searchFilterData: SearchFilterData
    
    @FetchRequest var activities: FetchedResults<Activity>
    var activityDetailHandler: ActivityDetailHandler
    @State private var dayMonthYearText = ""
    
    init(filter: Searchable, activityDetailHandler: @escaping ActivityDetailHandler) {
        let request = Activity.fetchRequest(with: filter.predicate, sortDescriptors: filter.sort)
        _activities = FetchRequest(fetchRequest: request)
        self.activityDetailHandler = activityDetailHandler
    }
    
    var colorSet: DayTime.ColorSet {
        Helpers.colorByTime()
    }
    
    var body: some View {
        ZStack {
            activitiyList
        }
    }

    @ViewBuilder
    func generateDateMonthYear(with date: Date) -> some View {
        Text.header(date.dayMonthYearFormattedString).foregroundColor(.black)
    }
    
    var activitiesByDate: [Date: [Activity]] {
        var result: [Date: [Activity]] = [:]

        for activity in activities {
            let startOfDate = activity.time.startOfDay
            if result[startOfDate] == nil {
                result[startOfDate] = []
            }
            
            result[startOfDate]!.append(activity)
        }
        
        return result
    }
    
    var sortedActivityDates: [Date] {
        Array(activitiesByDate.keys).sorted { searchFilterData.sortDirection == .descending ? $0 < $1 : $0 > $1 }
    }

    var activitiyList: some View {
        EventsListContainer {
            ForEach(sortedActivityDates, id: \.self) { date in
                generateDateMonthYear(with: date)
                ForEach(activitiesByDate[date] ?? []) { activity in
                    ActivityCardView(activity: activity, onActivityTapHandler: activityDetailHandler)
                        .transition(.asymmetric(insertion: .scale(scale: DrawingConstants.activityCardScaleFactor).animation(.easeInOut(duration: DrawingConstants.activityCardAnimationDuation)), removal: .identity))
                }
            }
            Color.clear.padding(.bottom, 20)
        }
    }
    
    struct DrawingConstants {
        static let activityCardScaleFactor: CGFloat = 0.92
        static let activityCardAnimationDuation: CGFloat = 0.1
        static let notFoundIconFontSize: CGFloat = 80
    }
}

struct ActivitiesFilteredListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesFilteredListView(filter: Activity.Filter.init()) { activity in
            
        }
    }
}
