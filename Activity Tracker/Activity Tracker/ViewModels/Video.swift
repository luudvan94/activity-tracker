//
//  Video.swift
//  Activity Tracker
//
//  Created by luu van on 4/21/22.
//

import SwiftUI
import CoreData
import AVKit

extension Video: Entity {
    static var entityName = "Video"
}

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
            
            return FileManager.url(with: name)
        }
        set {
            guard let url = newValue, let fileExtension = newValue?.pathExtension, fileExtension != "" else { return }
            let fileName = "AT-\(Date().timeIntervalSince1970).\(fileExtension)"
            name_ = fileName
            let newUrl = FileManager.url(with: fileName)
            try? FileManager.default.moveItem(at: url, to: newUrl)
        }
    }
}

extension Video {
    static func remove(urls: [URL]) {
        FileManager.remove(urls: urls)
    }
    
    static func removeUnneccessaryVideos(with context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<Video>(entityName: Video.entityName)
        
        guard let videos = try? context.fetch(fetchRequest) else { return }
        let usedVideoNames = videos.compactMap { $0.url }.compactMap { $0.lastPathComponent }
        let allVideoUrls = (FileManager.default.urls(for: .documentDirectory) ?? []).filter { $0.pathExtension == "mov" }.compactMap { $0 }
        
        let unusedVideoUrls = allVideoUrls.filter { !usedVideoNames.contains($0.lastPathComponent) }
        FileManager.remove(urls: unusedVideoUrls)
    }
}

