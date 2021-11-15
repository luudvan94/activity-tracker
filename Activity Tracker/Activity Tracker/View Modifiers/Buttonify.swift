//
//  3DTouchableButton.swift
//  Activity Tracker
//
//  Created by luu van on 11/8/21.
//

import SwiftUI

struct Buttonify: ViewModifier {
    @GestureState private var tapped = false
    @State private var tapStartTime: Date?
    
    var mainColor: Color
    var shadowColor: Color
    var action: () -> Void
    
    func body(content: Content) -> some View {
        let gesture = gesture()
            .onChanged { gesture in
                if tapStartTime == nil {
                    tapStartTime = gesture.time
                }
            }
            .onEnded { gesture in
                if shouldTriggerAction(withEndTime: gesture.time) {
                    action()
                }
                tapStartTime = nil
            }
        
        ZStack {
            content
                .gesture(gesture)
                .offset(y: offset(on: tapped))
                .animation(.easeInOut(duration: DrawingConstants.animationDuration), value: tapped)
        }
        .background(
            GeometryReader { g in
                let cornerRadius = min(min(g.size.width, g.size.height) / 4, DrawingConstants.cornerRadius)
                ZStack {
                    shadowColor
                        .cornerRadius(cornerRadius)
                        .offset(y: DrawingConstants.shadowOffY)

                    mainColor
                        .cornerRadius(cornerRadius)
                        .offset(y: offset(on: tapped))
                        .animation(.easeInOut(duration: DrawingConstants.animationDuration), value: tapped)
                    
                }
            }
        )
    }
    
    private func gesture() -> GestureStateGesture<DragGesture, Bool> {
        DragGesture(minimumDistance: 0)
            .updating($tapped) { (_, tapped, _) in
                tapped = true
            }
    }

    private func shouldTriggerAction(withEndTime endTime: Date) -> Bool {
        guard let startTime = tapStartTime else { return false }
        let acceptableTime: Double = 0.5
        
        let timeIntervalBetweenTapStartAndEndTime = startTime.distance(to: endTime)
        if timeIntervalBetweenTapStartAndEndTime > acceptableTime { return false }
        
        return true
    }
    
    private func shadowPosition(in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x,
            y: center.y + DrawingConstants.shadowOffY
        )
    }
    
    private func offset(on tap: Bool) -> CGFloat {
        return tap ? DrawingConstants.shadowOffY : 0
    }
    
    struct DrawingConstants {
        static let shadowOffY: CGFloat = 6
        static let cornerRadius: CGFloat = 15
        static let animationDuration: Double = 0.1
    }
}

extension View {
    func buttonfity(mainColor: Color = .white, shadowColor: Color = .shadow, action: @escaping () -> Void) -> some View {
        modifier(Buttonify(mainColor: mainColor, shadowColor: shadowColor, action: action))
    }
}

struct Buttonify_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red
            
            VStack {
                Text("Text").buttonfity(mainColor: .white, shadowColor: .gray, action: {
                }).frame(width: 100, height: 70)
                
                Image(systemName: "calendar").buttonfity(mainColor: .white, shadowColor: .gray, action: {}).frame(width: 80, height: 50)
            }
        }
    }
}
