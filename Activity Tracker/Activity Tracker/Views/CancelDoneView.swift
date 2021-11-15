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
    
    var body: some View {
        HStack {
            cancel
            Spacer()
            done
        }
    }
    
    var cancel: some View {
        Image(systemName: "x.circle.fill")
            .font(.title)
            .foregroundColor(.red)
            .padding()
            .buttonfity(mainColor: .white, shadowColor: .shadow, action: onCancel)
    }
    
    var done: some View {
        Image(systemName: "checkmark.circle.fill")
            .font(.title)
            .foregroundColor(.green)
            .padding()
            .buttonfity(mainColor: .white, shadowColor: .shadow, action: onDone)
    }
}

struct CancelDoneView_Previews: PreviewProvider {
    static var previews: some View {
        CancelDoneView(onCancel: {}, onDone: {})
    }
}
