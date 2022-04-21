//
//  Photo.swift
//  Activity Tracker
//
//  Created by luu van on 11/16/21.
//

import CoreData
import SwiftUI

extension Photo {
    var image: UIImage? {
        guard let data = data_ else { return nil }
        return UIImage(data: data)
    }
    
    var time: Date? {
        get { timeStamp_  }
        set { timeStamp_ = newValue }
    }
}

extension Photo {
    func setNewImage(_ image: UIImage, with time: Date = Date()) {
        self.data_ = image.jpegData(compressionQuality: 1)
        self.time = time
    }
    
    func thumbnail(size: CGSize = CGSize(width: 200, height: 200)) async -> UIImage? {
        guard let data = data_ else { return nil }
        return await UIImage(data: data)?.byPreparingThumbnail(ofSize: size)
    }
}
