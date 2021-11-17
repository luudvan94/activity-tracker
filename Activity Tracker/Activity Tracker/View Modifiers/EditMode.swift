//
//  EditMode.swift
//  Activity Tracker
//
//  Created by luu van on 11/17/21.
//

import SwiftUI

struct EditMode: ViewModifier {
    var isEditing: Bool
    var isSelected: Bool
    var selectedColor: Color
    
    func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) {
            content
            
            if isEditing {
                seeThroughLayer
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                
                if isSelected {
                    selectedDot.offset(x: -DrawingConstants.offset, y: DrawingConstants.offset)
                }
            }
        }
        .cornerRadius(DrawingConstants.cornerRadius)
        .scaleEffect(isSelected && isEditing ? DrawingConstants.scale : 1)
        .transition(.asymmetric(insertion: .identity, removal: .opacity))
        .animation(.easeInOut(duration: DrawingConstants.animationDuration), value: isSelected)
    }
    
    var seeThroughLayer: some View {
        Color.black.opacity(DrawingConstants.opacity)
    }
    
    var selectedDot: some View {
        Circle().fill(selectedColor).frame(width: DrawingConstants.dotWidth, height: DrawingConstants.dotWidth)
    }
    
    struct DrawingConstants {
        static let opacity: CGFloat = 0.5
        static let dotWidth: CGFloat = 20
        static let cornerRadius: CGFloat = 10
        static let offset: CGFloat = 15
        static let animationDuration: CGFloat = 0.2
        static let scale: CGFloat = 0.9
    }
}

extension View {
    func editMode(isEditing: Bool, isSelected: Bool, hightlightColor: Color) -> some View {
        modifier(EditMode(isEditing: isEditing, isSelected: isSelected, selectedColor: hightlightColor))
    }
}
