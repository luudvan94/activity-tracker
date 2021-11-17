//
//  DaySelected.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import SwiftUI

struct DaySelected: ViewModifier {
    var isSelected: Bool
    var hightlightColor: Color
    
    func body(content: Content) -> some View {
        ZStack {
            if isSelected {
                Circle().fill(hightlightColor)
                    .transition(.asymmetric(insertion: .opacity, removal: .identity))
            }
            
            content
        }
    }
}

extension View {
    func selectDay(_ isSelected: Bool, hightlightColor: Color) -> some View {
        modifier(DaySelected(isSelected: isSelected, hightlightColor: hightlightColor))
    }
}


struct DaySelected_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red
            
            Text("1").selectDay(true, hightlightColor: Color.blueMint)
        }
    }
}

