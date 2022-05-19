//
//  PhotoVideoListView.swift
//  Activity Tracker
//
//  Created by luu van on 5/3/22.
//

import SwiftUI
import CoreData
import ImageViewer
import AVKit

struct PhotoVideoListView: View {
	@EnvironmentObject var appSetting: AppSetting
    var photos: Set<Photo>
    var videos: Set<Video>
    var colorSet: DayTime.ColorSet
    
    var body: some View {
        ZStack {
            let columns: [GridItem] =
            Array(repeating: .init(.flexible()), count: 2)
            
            
            VStack(alignment: .leading) {
                LazyVGrid(columns: columns) {
                    photoList
                    videoList
                }
            }
        }
        
    }
    
    @ViewBuilder
    var photoList: some View {
        if photos.count > 0 {
            let sortedPhotos = photos.sorted { ($0.time ?? Date()) < ($1.time ?? Date()) }
            ForEach(sortedPhotos) { photo in
                VStack {
                    ThumbnailView(photo: photo)
                        .onTapGesture {
                            appSetting.displayingPhoto = photo
                            appSetting.shouldShowPhoto = true
                        }
                    }
            }
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    var videoList: some View {
        if videos.count > 0 {
            let sortedVideos = videos.sorted { ($0.time ?? Date()) < ($1.time ?? Date()) }
            ForEach(sortedVideos) { video in
                VStack {
                    ThumbnailView(video: video)
                        .onTapGesture {
                            appSetting.displayingVideo = video
                            appSetting.shouldShowVideo = true
                        }
                    }
            }
        } else {
            EmptyView()
        }
    }
}
