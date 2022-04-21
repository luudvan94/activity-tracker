//
//  ActivityPhotosView.swift
//  Activity Tracker
//
//  Created by luu van on 3/4/22.
//

import SwiftUI

struct ActivityPhotosView: View {
    @EnvironmentObject var searchFilterData: SearchFilterData
    
    @FetchRequest var activities: FetchedResults<Activity>
    
    init(filter: Searchable) {
        let request = Activity.fetchRequest(with: filter.predicate, sortDescriptors: filter.sort)
        _activities = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        ZStack {
            RoundedBorderContainerView {
                LazyVStack {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(sortedActivityDates, id: \.self) { date in
                            Section(header: generateDateMonthYear(with: date)) {
                                ForEach(activitiesByDate[date] ?? []) { activity in
                                    let sortedPhotos = activity.photos.sorted { ($0.time ?? Date()) < ($1.time ?? Date()) }
                                    ForEach(sortedPhotos) { photo in
                                        PhotoThumbnailView(photo: photo)
                                    }
                                }
                            }
                        }
                    }
                    Spacer(minLength: 100)
                }
            }
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
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    struct DrawingConstants {
        static let photoAspectRatio: CGFloat = 1
        static let photoCornerRadius: CGFloat = 10
    }
}

struct ActivityPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityPhotosView(filter: Activity.Filter.init())
    }
}
