//
//  AddNewButtonView.swift
//  Activity Tracker
//
//  Created by luu van on 11/13/21.
//

import SwiftUI

struct AddNewButtonView: View {    
    var colorSet: DayTime.ColorSet
    var onTap: () -> Void
    
    var body: some View {
        ZStack {
            Circle().fill(colorSet.main)
            
            Image(systemName: "plus")
                .font(.title)
                .foregroundColor(colorSet.textColor)
        }
        .onTapGesture {
            withAnimation {
                onTap()
            }
        }
    }
}
