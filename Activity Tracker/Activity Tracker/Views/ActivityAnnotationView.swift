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
            Text.regular(activity.time.formattedMonthDayYearMinuteHour)
                    .font(.callout)
                    .padding(5)
                    .background(Color(.white))
                    .cornerRadius(10)
            
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(colorSet.shadow)
            
            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .foregroundColor(colorSet.shadow)
                .offset(x: 0, y: -5)
        }
        .onTapGesture {
            onTapHandler()
        }
    }
}
