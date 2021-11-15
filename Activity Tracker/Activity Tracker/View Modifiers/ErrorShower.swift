//
//  ErrorShower.swift
//  Activity Tracker
//
//  Created by luu van on 11/15/21.
//

import SwiftUI

struct ErrorShower: ViewModifier {
    var shouldShow: Bool
    var message: String
    var action: () -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            if shouldShow {
                content
                error
            } else {
                content
            }
        }
    }
    
    var error: some View {
        Group {
            Color.black.opacity(0.7)
            
            VStack {
                Image(systemName: "x.circle.fill").foregroundColor(.red).font(.largeTitle).padding(.top)
                Text.regular(message).foregroundColor(.black).padding()
            }
            .background(.white)
            .cornerRadius(20)
            .transition(AnyTransition.scale.animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)))
        }
        .ignoresSafeArea()
        .onTapGesture {
            action()
        }
    }
}

extension View {
    func showError(shouldShow: Bool, message: String, action: @escaping () -> Void) -> some View {
        modifier(ErrorShower(shouldShow: shouldShow, message: message, action: action))
    }
}
