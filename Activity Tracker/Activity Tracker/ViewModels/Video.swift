//
//  Video.swift
//  Activity Tracker
//
//  Created by luu van on 4/21/22.
//

import SwiftUI
import CoreData
import AVKit

extension Video {
    var thumbnail: UIImage? {
        get {
            guard let data = thumbnail_data_ else { return nil }
            return UIImage(data: data)
        }
        set {
            guard let image = newValue else { return }
            self.thumbnail_data_ = image.jpegData(compressionQuality: 1)
        }
    }
    
    var time: Date? {
        get { timestamp_  }
        set { timestamp_ = newValue }
    }
    
    var url: URL? {
        get {
            guard let name = name_ else { return nil }
            
            return FileManager.getDocumentsDirectory().appendingPathComponent(name)
        }
        set {
            guard let url = newValue, let fileExtension = newValue?.pathExtension, fileExtension != "" else { return }
            let fileName = "\(Date().timeIntervalSince1970).\(fileExtension)"
            name_ = fileName
            let newUrl = FileManager.getDocumentsDirectory().appendingPathComponent(fileName)
            try? FileManager.default.moveItem(at: url, to: newUrl)
        }
    }
}

