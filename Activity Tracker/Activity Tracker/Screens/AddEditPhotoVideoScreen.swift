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
            
            toolsBar.ignoresSafeArea()
        }
        .displayPhotoVideo()
        .ignoresSafeArea(SafeAreaRegions.all, edges: Edge.Set.bottom)
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
        if photos.count > 0 || videos.count > 0 {
            PhotoVideoListView(photos: Set(photos), videos: Set(videos), colorSet: colorSet)
        } else {
            Text.regular(Labels.noPhoto).foregroundColor(colorSet.textColor)
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
            .padding(.bottom)
        }
        .foregroundColor(colorSet.textColor)
        .padding()
        .background(colorSet.shadow.clipped())
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
        newVideo.setNewVideo(video)
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
