//
//  ActivityCardView.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import SwiftUI
import SwiftUIFlowLayout

struct ActivityCardView: View {
    @ObservedObject var activity: Activity
    var onActivityTapHandler: ActivityDetailHandler
    
    var body: some View {
        let sortedTags = activity.tags.sorted { $0.name > $1.name }.map { $0.name }
        let colorSet = Helpers.colorByTime(activity.time)
        VStack(alignment: .leading) {
            Text.regular(activity.time.hourAndMinuteFormattedString).foregroundColor(.black)
            
            VStack(alignment: .leading) {
                FlowLayout(mode: .scrollable, items: sortedTags) { item in
                    Text.tag(item)
                        .foregroundColor(.black)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                
                Text.regular(activity.note).foregroundColor(colorSet.textColor)
            }
            .padding()
            .buttonfity(mainColor: colorSet.main, shadowColor: colorSet.shadow, action: {
                onActivityTapHandler(activity)
            })

        }
    }
}
