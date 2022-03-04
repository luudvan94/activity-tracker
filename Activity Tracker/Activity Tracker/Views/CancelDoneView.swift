//
//  CancelDoneView.swift
//  Activity Tracker
//
//  Created by luu van on 11/12/21.
//

import SwiftUI

struct CancelDoneView: View {
    var onCancel: () -> Void
    var onDone: () -> Void
    
    var colorSet: DayTime.ColorSet
    
    var body: some View {
        ZStack {
            HStack {
                cancel
                Spacer()
                done
            }.padding()
        }
        .background(colorSet.shadow.clipped())
    }
    
    var cancel: some View {
        Text.regular(Labels.cancel)
            .foregroundColor(.black)
            .padding()
            .buttonfity(mainColor: .white, shadowColor: .shadow, action: onCancel)
    }
    
    var done: some View {
        Text.regular(Labels.save)
            .foregroundColor(.blue)
            .padding()
            .buttonfity(mainColor: .white, shadowColor: .shadow, action: onDone)
    }
}

struct CancelDoneView_Previews: PreviewProvider {
    static var previews: some View {
        CancelDoneView(onCancel: {}, onDone: {}, colorSet: DayTime.sunset.colors)
    }
}
