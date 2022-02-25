//
//  AddNewButtonView.swift
//  Activity Tracker
//
//  Created by luu van on 11/13/21.
//

import SwiftUI

struct AddNewButtonView: View {
    @Binding var isAdding: Bool
    
    var colorSet: DayTime.ColorSet
    var onTap: () -> Void
    
    var body: some View {
        ZStack {
            Circle().fill(colorSet.main)
            
            if isAdding {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.title)
                    .foregroundColor(colorSet.textColor)
            } else {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(colorSet.textColor)
            }
        }
        .onTapGesture {
            withAnimation {
                onTap()
            }
        }
    }
}

struct AddNewButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewButtonView(isAdding: .constant(false), colorSet: DayTime.noon.colors, onTap: {})
    }
}
