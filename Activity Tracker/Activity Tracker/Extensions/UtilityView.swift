//
//  UtilityView.swift
//  Activity Tracker
//
//  Created by luu van on 11/9/21.
//

import SwiftUI

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}

extension View {
    func placeholder<Content: View>(when shouldShow: Bool, alignment: Alignment = .leading, @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func placeholder(_ text: String, when shouldShow: Bool, alignment: Alignment = .leading) -> some View {
        placeholder(when: shouldShow, alignment: alignment) { Text(text).foregroundColor(.gray) }
    }
}
