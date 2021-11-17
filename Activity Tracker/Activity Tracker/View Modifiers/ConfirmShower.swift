//
//  ConfirmShower.swift
//  Activity Tracker
//
//  Created by luu van on 11/17/21.
//

import SwiftUI

struct ConfirmShower: ViewModifier {
    var shouldShow: Bool
    var message: String
    var cancelAction: () -> Void
    var confirmAction: () -> Void
    
    
    func body(content: Content) -> some View {
        ZStack {
            if shouldShow {
                content
                
                Group {
                    Color.black.opacity(DrawingConstants.defaultOpacity)
                    VStack {
                        messageContainer
                        buttons
                    }
                    .transition(AnyTransition.scale.animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)))
                }
                .ignoresSafeArea()
            } else {
                content
            }
        }
    }
    
    var messageContainer: some View {
        VStack(spacing: DrawingConstants.defaultSpacing) {
            Image(systemName: "questionmark.circle.fill").foregroundColor(.yellow).font(.system(size: DrawingConstants.errorIconFontSize)).padding(.top)
            Text.regular(message).foregroundColor(.black).padding([.horizontal, .bottom])
        }
        .background(.white)
        .cornerRadius(DrawingConstants.cornerRadius)
    }
    
    var buttons: some View {
        HStack(spacing: DrawingConstants.defaultSpacing) {
            Text.regular(Labels.no).foregroundColor(.black)
                .padding()
                .padding(.horizontal, DrawingConstants.buttonHorizontalPadding)
                .buttonfity {
                    cancelAction()
                }
            Text.regular(Labels.yes).foregroundColor(.red)
                .padding()
                .padding(.horizontal, DrawingConstants.buttonHorizontalPadding)
                .buttonfity {
                    confirmAction()
                }
        }
    }
    
    struct DrawingConstants {
        static let errorIconFontSize: CGFloat = 50
        static let cornerRadius: CGFloat = 20
        static let defaultSpacing: CGFloat = 20
        static let defaultOpacity: CGFloat = 0.7
        static let buttonHorizontalPadding: CGFloat = 10
    }
}

extension View {
    func showConfirm(shouldShow: Bool, message: String, cancelaction: @escaping () -> Void, confirmAction: @escaping () -> Void) -> some View {
        modifier(ConfirmShower(shouldShow: shouldShow, message: message, cancelAction: cancelaction, confirmAction: confirmAction))
    }
}
