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
            Color.black.opacity(DrawingConstants.defaultOpacity)
            
            VStack(spacing: DrawingConstants.defaultSpacing) {
                Image(systemName: "x.circle.fill").foregroundColor(.red).font(.system(size: DrawingConstants.errorIconFontSize)).padding(.top)
                Text.regular(message).foregroundColor(.black).padding([.horizontal, .bottom])
            }
            .background(.white)
            .cornerRadius(DrawingConstants.cornerRadius)
            .buttonfity {
                action()
            }
            .transition(AnyTransition.scale.animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)))
        }
        .ignoresSafeArea()
    }
    
    struct DrawingConstants {
        static let errorIconFontSize: CGFloat = 60
        static let cornerRadius: CGFloat = 20
        static let defaultSpacing: CGFloat = 10
        static let defaultOpacity: CGFloat = 0.7
    }
}

extension View {
    func showError(shouldShow: Bool, message: String, action: @escaping () -> Void) -> some View {
        modifier(ErrorShower(shouldShow: shouldShow, message: message, action: action))
    }
}
