//
//  MenuView.swift
//  Activity Tracker
//
//  Created by luu van on 2/24/22.
//

import SwiftUI

struct MenuView<ContentView>: View where ContentView: View {
    @ViewBuilder var content: () -> ContentView
    var colorSet: DayTime.ColorSet
    var action: () -> Void
    
    var body: some View {
        ZStack {
            Color.clear
            content()
        }
        .padding()
        .buttonfity(mainColor: colorSet.main, shadowColor: colorSet.shadow, action: action)
    }
}
