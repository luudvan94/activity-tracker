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
    
    @State private var selectedImage: Image?
    @State private var selectedVideo: Video?
    @State private var showImageViewer = false
    
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
        .sheet(item: $selectedVideo) { video in
            VideoPlayer(player: AVPlayer(url: video.url!))
        }
        .fullScreenCover(isPresented: $showImageViewer) {
            ImageViewer(image: $selectedImage, viewerShown: $showImageViewer)
        }
        
    }
    
    @ViewBuilder
    var photoList: some View {
        let sortedPhotos = photos.sorted { ($0.time ?? Date()) < ($1.time ?? Date()) }
        ForEach(sortedPhotos) { photo in
            VStack {
                ThumbnailView(photo: photo)
                    .onTapGesture {
						appSetting.displayingPhoto = photo
						appSetting.shouldShowPhoto = true
                    }
                
                Text.regular(photo.time?.hourAndMinuteFormattedString ?? " ").foregroundColor(colorSet.textColor)
            }
        }
    }
    
    @ViewBuilder
    var videoList: some View {
        let sortedVideos = videos.sorted { ($0.time ?? Date()) < ($1.time ?? Date()) }
        ForEach(sortedVideos) { video in
            VStack {
                ThumbnailView(video: video)
                    .onTapGesture {
						appSetting.displayingVideo = video
						appSetting.shouldShowVideo = true
                    }
                
                Text.regular(video.time?.hourAndMinuteFormattedString ?? " ").foregroundColor(colorSet.textColor)
            }
        }
    }
}
