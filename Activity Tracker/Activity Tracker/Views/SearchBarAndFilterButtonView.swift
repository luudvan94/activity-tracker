//
//  SearchBarAndFilterButtonView.swift
//  Activity Tracker
//
//  Created by luu van on 11/22/21.
//

import SwiftUI

struct SearchBarAndFilterButtonView: View {
    var colorSet: TimeColor.ColorSet
    @State private var searchText = ""
    
    var body: some View {
        HStack(alignment: .center) {
            searchBar
            filter
        }
    }
    
    var searchBar: some View {
        TextField("search by note content", text: $searchText)
            .padding(.leading)
            .frame(height: DrawingConstants.searchBarHeight)
            .background(.white)
            .cornerRadius(DrawingConstants.searchBarCornerRadius)
    }
    
    var filter: some View {
        Image(systemName: "camera.filters")
            .foregroundColor(colorSet.main)
            .font(.title)
            .padding(8)
            .buttonfity(
                mainColor: .white,
                shadowColor: .shadow,
                action: {  })
            .frame(width: DrawingConstants.filterWidth)
    }
    
    struct DrawingConstants {
        static let filterWidth: CGFloat = 50
        static let searchBarHeight: CGFloat = 50
        static let searchBarCornerRadius: CGFloat = 20.0
    }
}

struct SearchBarAndFilterButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarAndFilterButtonView(colorSet: TimeColor.noon.color)
    }
}
