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
}

class PhotoWrapper {
    
    enum EncodingStatus: String {
        case pending
        case completed
    }
    
    var photo: Photo
    private(set) var imageStatus: EncodingStatus
    private var newlySetImage: UIImage?
    
    init(photo: Photo) {
        self.photo = photo
        imageStatus = .completed
    }
    
    var image: UIImage {
        if let image = photo.image {
            return image
        } else if let image = newlySetImage, imageStatus == .pending {
            return image
        } else {
            return UIImage(named: "nothing")!
        }
    }
    
    func setNewImage(_ image: UIImage) {
        encodingImage(image)
        newlySetImage = image
    }
    
    private func encodingImage(_ newImage: UIImage) {
        imageStatus = .pending
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let newData = newImage.jpegData(compressionQuality: 1)
            DispatchQueue.main.async {
                self?.imageStatus = .completed
                self?.photo.data_ = newData
            }
        }
    }
}

extension PhotoWrapper: Hashable {
    static func == (lhs: PhotoWrapper, rhs: PhotoWrapper) -> Bool {
        return lhs.photo == rhs.photo
    }
    
    func hash(into hasher: inout Hasher) {
    }
}

extension PhotoWrapper: CustomStringConvertible {
    var description: String {
        String(describing: "\(imageStatus) - \(photo.objectID)")
    }
}
