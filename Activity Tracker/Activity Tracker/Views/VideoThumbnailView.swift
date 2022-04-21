//
//  VideoThumbnailView.swift
//  Activity Tracker
//
//  Created by luu van on 4/21/22.
//

import SwiftUI

struct VideoThumbnailView: View {
    var thumbnail: UIImage?
    
    var body: some View {
        ZStack {
            Image(uiImage: thumbnail ?? UIImage(named: "placeholder")!)
                .resizable()
                .aspectRatio(DrawingConstants.photoAspectRatio, contentMode: .fit)
                .cornerRadius(DrawingConstants.photoCornerRadius)
                .shadow(radius: DrawingConstants.photoRadius)
            
            Image(systemName: "play.square").foregroundColor(Color.white).font(.title3)
        }
    }
    
    struct DrawingConstants {
        static let photoAspectRatio: CGFloat = 1
        static let photoCornerRadius: CGFloat = 10
        static let photoRadius: CGFloat = 2
    }
}
