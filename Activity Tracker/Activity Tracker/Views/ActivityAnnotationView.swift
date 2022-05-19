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
    
    var colorSet: DayTime.ColorSet {
        Helpers.colorByTime(activity.time)
    }
    
    var body: some View {
        VStack {
            Text.regular(activity.time.dayMonthYearFormattedString)
                .foregroundColor(.black)
                .font(.callout)
                .padding(5)
                .background(Color(.white))
                .cornerRadius(10)
            
            Image(systemName: "figure.walk.circle.fill")
                .font(.largeTitle)
                .foregroundColor(colorSet.shadow)
                .shadow(radius: 1)
        }
        .onTapGesture {
            onTapHandler()
        }
    }
}
