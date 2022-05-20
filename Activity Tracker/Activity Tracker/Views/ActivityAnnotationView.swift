//
//  ActivityMapMarker.swift
//  Activity Tracker
//
//  Created by luu van on 3/4/22.
//

import SwiftUI

struct ActivityAnnotationView: View {
    var activity: Activity
    var onTapHandler: () -> Void
    
    @State private var showContent = false
    
    var colorSet: DayTime.ColorSet {
        Helpers.colorByTime(activity.time)
    }
    
    var body: some View {
        ZStack {
            if showContent {
                VStack {
                    Circle()
                        .strokeBorder(colorSet.shadow, lineWidth: 5)
                        .background(Circle().fill(.white))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.caption)
                        .foregroundColor(colorSet.shadow)
                        .offset(x: 0, y: -1)
                }
                .transition(.scale.animation(.spring()))
            }
        }
        .onAppear {
            showContent = true
        }
        .onTapGesture {
            onTapHandler()
        }
    }
}
