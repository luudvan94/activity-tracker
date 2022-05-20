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
    @State private var showContent = false
    
    var colorSet: DayTime.ColorSet {
        Helpers.colorByTime(activity.time)
    }
        
    var body: some View {
        ZStack {
            if showContent {
                VStack(alignment: .leading) {
                    time
                    
                    VStack(alignment: .leading) {
                        features
                        tags
                        note
                    }
                    .padding()
                    .buttonfity(mainColor: colorSet.main, shadowColor: colorSet.shadow, action: {
                        onActivityTapHandler(activity)
                    })
                }
                .transition(AnyTransition.asymmetric(insertion: .scale(scale: DrawingConstants.cardScaleFactor).animation(.easeInOut(duration: DrawingConstants.cardAnimationDuration)), removal: .identity))
            }
        }
        .onAppear {
            showContent = true
        }
    }
    
    var time: some View {
        Text.regular(activity.time.hourAndMinuteFormattedString).foregroundColor(.black)
    }
    
    @ViewBuilder
    var features: some View {
        if activity.featureIcons.count > 0 {
            HStack(spacing: 10) {
                Spacer()
                
                ForEach(activity.featureIcons, id: \.self) { icon in
                    Image(systemName: icon)
                        .foregroundColor(colorSet.textColor)
                        .font(.body)
                }
            }
        } else {
            EmptyView().frame(height: 0)
        }
        
    }
        
    @ViewBuilder
    var tags: some View {
        let sortedTags = activity.tags.sorted { $0.name > $1.name }.map { $0.name }

        FlowLayout(mode: .scrollable, items: sortedTags) { item in
            Text.tag(item)
                .foregroundColor(.black)
                .padding(5)
                .background(Color.white)
                .cornerRadius(10)
        }
    }
    
    var note: some View {
        Text.regular(activity.note).foregroundColor(colorSet.textColor)
    }
    
    struct DrawingConstants {
        static let cardScaleFactor: CGFloat = 0.92
        static let cardAnimationDuration: CGFloat = 0.1
    }
}
