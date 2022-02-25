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
        RoundedBorderContainerView {
            VStack(spacing: DrawingConstants.defaultSpacing) {
                content()
            }
            .padding()
        }
    }
}

fileprivate struct DrawingConstants {
    static let defaultSpacing: CGFloat = 60
}
