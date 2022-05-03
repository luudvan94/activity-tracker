//
//  ActivityPhotosView.swift
//  Activity Tracker
//
//  Created by luu van on 3/4/22.
//

import SwiftUI
import ImageViewer
import AVKit

struct ActivitiesPhotoVideoScreen: View {
    @EnvironmentObject var searchFilterData: SearchFilterData
    
    @FetchRequest var activities: FetchedResults<Activity>
    @State private var selectedImage: Image?
    @State private var selectedVideo: Video?
    @State private var showImageViewer = false
    
    init(filter: Searchable) {
        let request = Activity.fetchRequest(with: filter.predicate, sortDescriptors: filter.sort)
        _activities = FetchRequest(fetchRequest: request)
    }
    
    var colorSet: DayTime.ColorSet {
        Helpers.colorByTime()
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            colorSet.main.ignoresSafeArea()
            
            ScrollView {
                ForEach(sortedActivityDates, id: \.self) { date in
                    Section(header: generateDateMonthYear(with: date)) {
                        ForEach(activitiesByDate[date] ?? []) { activity in
                            PhotoVideoListView(photos: activity.photos, videos: activity.videos, colorSet: colorSet)
                        }
                    }
                    .padding(.top)
                }
            }
            .padding()
        }
        .sheet(item: $selectedVideo) { video in
            VideoPlayer(player: AVPlayer(url: video.url!))
        }
        .overlay(
            ImageViewer(image: $selectedImage, viewerShown: $showImageViewer)
        )
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
    ]
    
    struct DrawingConstants {
        static let photoAspectRatio: CGFloat = 1
        static let photoCornerRadius: CGFloat = 10
    }
}
