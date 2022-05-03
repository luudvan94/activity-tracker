//
//  PhotoView.swift
//  Activity Tracker
//
//  Created by luu van on 4/18/22.
//

import SwiftUI

struct ThumbnailView: View {
    var photo: Photo?
    var video: Video?
    @State private var image = UIImage(named: "placeholder")
    
    var body: some View {
        ZStack {
            if let photo = photo {
                Image(uiImage: image!)
                    .resizable()
                    .aspectRatio(DrawingConstants.photoAspectRatio, contentMode: .fit)
                    .cornerRadius(DrawingConstants.photoCornerRadius)
                    .shadow(radius: DrawingConstants.photoRadius)
                    .task {
                        image = await photo.thumbnail()
                    }
            } else if let video = video {
                Image(uiImage: video.thumbnail ?? UIImage(named: "placeholder")!)
                    .resizable()
                    .aspectRatio(DrawingConstants.photoAspectRatio, contentMode: .fit)
                    .cornerRadius(DrawingConstants.photoCornerRadius)
                    .shadow(radius: DrawingConstants.photoRadius)
                
                Image(systemName: "play.square").foregroundColor(Color.white).font(.title)
            }
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
        ThumbnailView(photo: Photo())
    }
}
