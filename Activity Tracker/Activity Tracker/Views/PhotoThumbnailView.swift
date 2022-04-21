//
//  PhotoView.swift
//  Activity Tracker
//
//  Created by luu van on 4/18/22.
//

import SwiftUI

struct PhotoThumbnailView: View {
    var photo: Photo
    @State private var image = UIImage(named: "placeholder")
    
    var body: some View {
        Image(uiImage: image!)
            .resizable()
            .aspectRatio(DrawingConstants.photoAspectRatio, contentMode: .fit)
            .cornerRadius(DrawingConstants.photoCornerRadius)
            .shadow(radius: DrawingConstants.photoRadius)
            .task {
                image = await photo.thumbnail()
            }
    }
    
    struct DrawingConstants {
        static let photoAspectRatio: CGFloat = 1
        static let photoCornerRadius: CGFloat = 10
        static let photoRadius: CGFloat = 2
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoThumbnailView(photo: Photo())
    }
}
