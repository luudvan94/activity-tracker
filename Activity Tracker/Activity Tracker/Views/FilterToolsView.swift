//
//  FilterToolsView.swift
//  Activity Tracker
//
//  Created by luu van on 11/24/21.
//

import SwiftUI

struct FilterToolsView: View {
    @EnvironmentObject var appSetting: AppSetting
    
    @Binding var sortDirection: SearchFilterData.SortDirection
    var sortAction: () -> Void

    var colorSet: TimeColor.ColorSet {
        appSetting.colorSet
    }
    
    var body: some View {
        HStack {
            sort
            Spacer()
        }
    }
    
    @ViewBuilder
    var sort: some View {
        ZStack() {
            Image(systemName: sortDirection == .ascending ? "arrow.up.square.fill" : "arrow.down.app.fill")
                .foregroundColor(colorSet.main)
                .font(.title)
                .padding(8)
        }
        .buttonfity {
            withAnimation {
                sortAction()
            }
        }
        .frame(width: DrawingConstants.sortWidth)
    }
    
    struct DrawingConstants {
        static let sortWidth: CGFloat = 50
    }
}

struct FilterToolsView_Previews: PreviewProvider {
    static var previews: some View {
        FilterToolsView(sortDirection: .constant(.ascending)) {}
    }
}
