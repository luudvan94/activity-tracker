//
//  ActivitiesListContainer.swift
//  Activity Tracker
//
//  Created by luu van on 11/22/21.
//

import SwiftUI

struct ActivitiesListContainer<ContentView>: View where ContentView: View {
    @ViewBuilder var content: () -> ContentView
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: DrawingConstants.defaultSpacing) {
                    content()
                }
                .padding()
            }
            .background(Color.white)
            .cornerRadius(DrawingConstants.activityCardCornerRadius)
        }
    }
}

fileprivate struct DrawingConstants {
    static let activityCardScaleFactor: CGFloat = 0.92
    static let activityCardAnimationDuation: CGFloat = 0.1
    static let activityCardCornerRadius: CGFloat = 20
    static let defaultSpacing: CGFloat = 60
    static let notFoundIconFontSize: CGFloat = 80
}
