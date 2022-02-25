//
//  SearchBarAndFilterButtonView.swift
//  Activity Tracker
//
//  Created by luu van on 11/22/21.
//

import SwiftUI

struct SearchBarAndFilterButtonView: View {
    @EnvironmentObject var searchFilterData: SearchFilterData
    @EnvironmentObject var appSetting: AppSetting
    
    var onFilterTap: () -> Void
    @State private var searchText = ""
    
    var body: some View {
        HStack(alignment: .center) {
            searchBar
            filter
        }
    }
    
    var colorSet: DayTime.ColorSet {
        appSetting.colorSet
    }
    
    var searchBar: some View {
        TextField("search by note content", text: $searchText)
            .padding(.leading)
            .frame(height: DrawingConstants.searchBarHeight)
            .background(.white)
            .cornerRadius(DrawingConstants.searchBarCornerRadius)
    }
    
    @ViewBuilder
    var filter: some View {
        ZStack() {
            Image(systemName: "camera.filters")
                .foregroundColor(colorSet.main)
                .font(.title)
                .padding(8)
            
            if searchFilterData.isBeingFilted {
                Circle().fill(.red).frame(DrawingConstants.filteredIconSize).offset(DrawingConstants.filteredIconOffset)
            }
        }
        .buttonfity(
            mainColor: .white,
            shadowColor: .shadow,
            action: onFilterTap)
        .frame(width: DrawingConstants.filterWidth)
    }
    
    struct DrawingConstants {
        static let filterWidth: CGFloat = 50
        static let searchBarHeight: CGFloat = 50
        static let searchBarCornerRadius: CGFloat = 20.0
        static let filteredIconSize: CGSize = CGSize(width: 10, height: 10)
        static let filteredIconOffset: CGPoint = CGPoint(x: 10, y: -10)
    }
}

struct SearchBarAndFilterButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarAndFilterButtonView(onFilterTap: {})
    }
}

extension View {
    func offset(_ point: CGPoint) -> some View {
        offset(x: point.x, y: point.y)
    }
    
    func frame(_ size: CGSize) -> some View {
        frame(width: size.width, height: size.height)
    }
}
