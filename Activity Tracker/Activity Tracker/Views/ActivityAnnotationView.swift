//
//  ActivityMapMarker.swift
//  Activity Tracker
//
//  Created by luu van on 3/4/22.
//

import SwiftUI

struct ActivityAnnotationView: View {
    
    var colorSet: DayTime.ColorSet
    var onTapHandler: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(colorSet.main)
            
            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .foregroundColor(colorSet.main)
                .offset(x: 0, y: -5)
        }
        .onTapGesture {
            onTapHandler()
        }
    }
}
