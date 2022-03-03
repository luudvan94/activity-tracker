//
//  RoundedBorderContainerView.swift
//  Activity Tracker
//
//  Created by luu van on 2/24/22.
//

import SwiftUI

struct RoundedBorderContainerView<ContentView>: View where ContentView: View {
    @ViewBuilder var content: () -> ContentView
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                content()
            }
            .padding(.horizontal)
        }
        .background(Color.white)
        .cornerRadius(DrawingConstants.cornerRadius)
    }
}

fileprivate struct DrawingConstants {
    static let cornerRadius: CGFloat = 20
}
