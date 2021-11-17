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

struct ViewAddPhotosScreen: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @Binding var photos: [PhotoWrapper]
    var colorSet: TimeColor.ColorSet
    
    @State private var showCameraLibraryScreen = false
    @State private var images = [UIImage]()
    @State private var selectedImage: Image?
    @State private var showImageViewer = false
    
    var body: some View {
        ZStack {
            colorSet.main.ignoresSafeArea()
            
            ScrollView {
                VStack {
                    title
                    newPhoto
                    photoList
                    
                }
                .padding()
            }
        }
        .fullScreenCover(isPresented: $showCameraLibraryScreen) {
            CameraAndLibraryScreen(onNewPhoto: onNewPhoto)
        }
        .overlay(
            ImageViewer(image: $selectedImage, viewerShown: $showImageViewer)
        )
    }
    
    var title: some View {
        Text.header(Labels.photos).foregroundColor(colorSet.textColor)
    }
    
    var newPhoto: some View {
        Text(Labels.newPhoto)
            .foregroundColor(.black)
            .padding(.vertical, DrawingConstants.addNewPhotoInnerVerticalPadding)
            .padding(.horizontal, DrawingConstants.addNewPhotoInnerHorizontalPadding)
            .buttonfity {
                showCameraLibraryScreen = true
            }
    }
    
    @ViewBuilder
    var photoList: some View {
        let columns: [GridItem] =
                 Array(repeating: .init(.flexible()), count: 2)
        
        LazyVGrid(columns: columns) {
            ForEach(photos, id: \.self) { photo in
                Image(uiImage: photo.image)
                    .resizable()
                    .aspectRatio(DrawingConstants.photoAspectRatio, contentMode: .fit)
                    .cornerRadius(DrawingConstants.photoCornerRadius)
                    .shadow(radius: 2)
                    .onTapGesture {
                        selectedImage = Image(uiImage: photo.image)
                        showImageViewer = true
                    }
                
            }
        }.padding(.top)
    }
    
    private func onNewPhoto(_ photo: YPMediaPhoto) {
        let newPhoto = PhotoWrapper(photo: Photo(context: context))
        newPhoto.setNewImage(photo.image)
        photos.append(newPhoto)
    }
    
    struct DrawingConstants {
        static let addNewPhotoInnerVerticalPadding: CGFloat = 5
        static let addNewPhotoInnerHorizontalPadding: CGFloat = 20
        static let photoAspectRatio: CGFloat = 1
        static let photoCornerRadius: CGFloat = 10
    }
}

struct ViewAddPhotosScreen_Previews: PreviewProvider {
    static var previews: some View {
        ViewAddPhotosScreen(photos: .constant([]), colorSet: TimeColor.noon.color)
    }
}
