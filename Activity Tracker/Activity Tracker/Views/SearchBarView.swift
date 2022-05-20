//
//  SearchBarView.swift
//  Activity Tracker
//
//  Created by luu van on 5/20/22.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        TextField("", text: $searchText)
            .modifier(TextFieldClearButton(text: $searchText))
            .placeholder(Labels.searchTag, when: searchText.isEmpty)
            .padding(.leading)
            .frame(height: DrawingConstants.searchBarHeight)
            .background(.white)
            .cornerRadius(DrawingConstants.searchBarCornerRadius)
    }
    
    struct DrawingConstants {
        static let searchBarHeight: CGFloat = 50
        static let searchBarCornerRadius: CGFloat = 20.0
    }
}
