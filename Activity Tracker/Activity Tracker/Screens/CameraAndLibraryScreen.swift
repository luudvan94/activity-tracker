//
//  CameraAndLibraryScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/16/21.
//

import SwiftUI
import YPImagePicker
import AVKit

struct CameraAndLibraryScreen {
    var onNewPhoto: (YPMediaPhoto) -> Void
    var onNewVideo: (YPMediaVideo) -> Void
}

extension CameraAndLibraryScreen: UIViewControllerRepresentable {
    func cameraConfig() -> YPImagePickerConfiguration {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 5
        config.shouldSaveNewPicturesToAlbum = false
        config.showsPhotoFilters = false
        config.library.skipSelectionsGallery = true
        
        config.video.compression = AVAssetExportPresetHighestQuality
        config.video.fileType = .mov
        config.video.recordingTimeLimit = 10.0
        config.video.libraryTimeLimit = 10.0
        config.video.minimumTimeLimit = 1.0
        config.showsVideoTrimmer = false
        
        config.screens = [.library, .photo, .video]
        
        return config
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraAndLibraryScreen>) -> YPImagePicker {
        let config = cameraConfig()
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            for item in items {
                switch item {
                case .photo(let photo):
                    onNewPhoto(photo)
                case .video(let video):
                    onNewVideo(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        return picker
    }
    
    func updateUIViewController(_ uiViewController: YPImagePicker, context: UIViewControllerRepresentableContext<CameraAndLibraryScreen>) {
        
    }
}
