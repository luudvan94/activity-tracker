//
//  ViewAddPhotosScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/16/21.
//

import SwiftUI
import ImageViewer
import CoreData
import YPImagePicker
import AVKit

struct AddEditPhotoVideoScreen: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @Binding var photos: [Photo]
    @Binding var videos: [Video]
    @Binding var showCameraLibraryScreen: Bool
    var colorSet: DayTime.ColorSet

    @State private var images = [UIImage]()
    @State private var selectedImage: Image?
    @State private var selectedVideo: Video?
    @State private var editingPhotos = Set<Photo>()
    @State private var editingVideos = Set<Video>()
    @State private var showImageViewer = false
    @State private var isEditing = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            colorSet.main.ignoresSafeArea()
            
            ScrollView {
                VStack {
                    title
                    VStack {
                        content()
                    }.padding(.vertical)
                }
                .padding()
            }
            
            toolsBar
        }
        .fullScreenCover(isPresented: $showCameraLibraryScreen) {
            CameraAndLibraryScreen(onNewPhoto: onNewPhoto, onNewVideo: onNewVideo)
        }
        .sheet(item: $selectedVideo) { video in
            VideoPlayer(player: AVPlayer(url: video.url!))
        }
        .overlay(
            ImageViewer(image: $selectedImage, viewerShown: $showImageViewer)
        )
    }
    
    var title: some View {
        Text.header(Labels.photos).foregroundColor(colorSet.textColor)
    }
    
    @ViewBuilder
    func content() -> some View {
        let columns: [GridItem] =
        Array(repeating: .init(.flexible()), count: 2)
        
        if photos.count > 0 || videos.count > 0 {
            Group {
                if photos.count > 0 {
                    LazyVGrid(columns: columns) {
                        photoList
                    }.padding(.top)
                }
                
                if videos.count > 0 {
                    LazyVGrid(columns: columns) {
                        videoList
                    }.padding(.top)
                }
                
                Spacer(minLength: 100)
            }
        } else {
            Text.regular(Labels.noPhoto).foregroundColor(colorSet.textColor)
        }
    }
    
    @ViewBuilder
    var photoList: some View {
        let sortedPhotos = photos.sorted { ($0.time ?? Date()) < ($1.time ?? Date()) }
        ForEach(sortedPhotos, id: \.self) { photo in
            VStack {
                PhotoThumbnailView(photo: photo)
                    .editMode(isEditing: isEditing, isSelected: editingPhotos.contains(photo), hightlightColor: colorSet.main)
                    .onTapGesture {
                        if isEditing {
                            withAnimation {
                                if editingPhotos.contains(photo) {
                                    editingPhotos.remove(photo)
                                } else {
                                    editingPhotos.insert(photo)
                                }
                            }
                        } else {
                            selectedImage = Image(uiImage: photo.image!)
                            showImageViewer = true
                        }
                    }
                
                if let time = photo.time {
                    Text.regular(time.hourAndMinuteFormattedString).foregroundColor(colorSet.textColor)
                }
            }
            
        }
    }
    
    @ViewBuilder
    var videoList: some View {
        let sortedVideos = videos.sorted { ($0.time ?? Date()) < ($1.time ?? Date()) }
        ForEach(sortedVideos, id: \.self) { video in
            VStack {
                VideoThumbnailView(thumbnail: video.thumbnail)
                    .editMode(isEditing: isEditing, isSelected: editingVideos.contains(video), hightlightColor: colorSet.main)
                    .onTapGesture {
                        if isEditing {
                            withAnimation {
                                if editingVideos.contains(video) {
                                    editingVideos.remove(video)
                                } else {
                                    editingVideos.insert(video)
                                }
                            }
                        } else {
                            selectedVideo = video
                        }
                    }
            }
            
        }
    }
    
    @ViewBuilder
    var toolsBar: some View {
        ZStack {
            HStack {
                HStack {
                    if photos.count > 0 {
                        select
                    }
                    
                    if !isEditing {
                        addNewPhoto
                    }
                }
                
                Spacer()
                
                if isEditing && (editingPhotos.count > 0 || editingVideos.count > 0) {
                    Image(systemName: "trash.fill").foregroundColor(.red).padding().buttonfity {
                        withAnimation {
                            removePhotos()
                        }
                    }
                }
            }
        }
        .foregroundColor(colorSet.textColor)
        .padding()
        .background(colorSet.shadow.clipped())
        .padding(.horizontal)
    }
    
    var addNewPhoto: some View {
        Text.regular(Labels.newPhoto).foregroundColor(.black).padding().buttonfity {
            showCameraLibraryScreen = true
        }
    }
    
    @ViewBuilder
    var select: some View {
        let selectTitle = isEditing ? Labels.cancel : Labels.select
        Text.regular(selectTitle).foregroundColor(.black).padding().buttonfity {
            withAnimation {
                isEditing.toggle()
                if !isEditing {
                    editingPhotos.removeAll()
                }
            }
        }
    }
    
    private func onNewPhoto(_ photo: YPMediaPhoto) {
        let newPhoto = Photo(context: context)
        newPhoto.setNewImage(photo.image)
        photos.append(newPhoto)
    }
    
    private func onNewVideo(_ video: YPMediaVideo) {
        let newVideo = Video(context: context)
        newVideo.thumbnail = video.thumbnail
        newVideo.url = video.url
        videos.append(newVideo)
    }
    
    private func removePhotos() {
        if isEditing && editingPhotos.count > 0 {
            photos.removeAll { editingPhotos.contains($0) }
            isEditing = false
            editingPhotos.removeAll()
        }
    }
    
    struct DrawingConstants {
        static let addNewPhotoInnerVerticalPadding: CGFloat = 5
        static let addNewPhotoInnerHorizontalPadding: CGFloat = 20
        static let photoAspectRatio: CGFloat = 1
        static let photoCornerRadius: CGFloat = 10
        static let editBorderLineWidth: CGFloat = 2
        static let editBorderDash: CGFloat = 10
        static let editPadding: CGFloat = 20
    }
}

struct ViewAddPhotosScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddEditPhotoVideoScreen(photos: .constant([]), videos: .constant([]), showCameraLibraryScreen: .constant(false), colorSet: DayTime.noon.colors)
    }
}
