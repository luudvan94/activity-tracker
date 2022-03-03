//
//  FeatureFilterView.swift
//  Activity Tracker
//
//  Created by luu van on 3/3/22.
//

import SwiftUI

struct FeatureFilterView: View {
    var colorSet: DayTime.ColorSet
    
    var iconName: String
    var title: String
    var isSelected: Bool
    var onSelected: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: iconName).font(.title3).foregroundColor(colorSet.shadow)
            Text.regular(title).foregroundColor(colorSet.textColor).padding(.trailing)
            
            Image(systemName: "circle.fill")
                .font(.footnote)
                .foregroundColor(isSelected ? colorSet.main : .white)
            
        }
        .padding()
        .buttonfity {
            onSelected()
        }
    }
}
