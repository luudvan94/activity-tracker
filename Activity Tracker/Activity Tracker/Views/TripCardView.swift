//
//  TripCardView.swift
//  Activity Tracker
//
//  Created by luu van on 2/28/22.
//

import SwiftUI

struct TripCardView: View {
    @ObservedObject var trip: Trip
    var onTripTapHandler: TripDetailHandler
    
    var colorSet: DayTime.ColorSet {
        Helpers.colorByTime(trip.time)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            time
            
            ZStack(alignment: .leading) {
                Color.clear
                
                HStack {
                    VStack(alignment: .leading) {
                        Text.header(trip.name)
                        Text.regular("\(trip.activities_?.count ?? 0) activities")
                    }
                    
                    Spacer()
                    
                    Image(systemName: "airplane").font(.largeTitle)
                }
                .foregroundColor(colorSet.textColor)
            }
            .padding()
            .buttonfity(mainColor: colorSet.main, shadowColor: colorSet.shadow, action: {
                onTripTapHandler(trip)
            })

        }
    }
    
    var time: some View {
        Text.regular(trip.time.hourAndMinuteFormattedString).foregroundColor(.black)
    }
}
