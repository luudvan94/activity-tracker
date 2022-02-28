//
//  CameraAndLibraryScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/16/21.
//

import SwiftUI
import YPImagePicker

struct CameraAndLibraryScreen {
    var onNewPhoto: (YPMediaPhoto) -> Void
}

extension CameraAndLibraryScreen: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraAndLibraryScreen>) -> YPImagePicker {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 5
        config.shouldSaveNewPicturesToAlbum = false
        config.showsPhotoFilters = false
        config.library.skipSelectionsGallery = true
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            for item in items {
                switch item {
                case .photo(let photo):
                    onNewPhoto(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        return picker
    }
    
    func updateUIViewController(_ uiViewController: YPImagePicker, context: UIViewControllerRepresentableContext<CameraAndLibraryScreen>) {
        
    }
}
