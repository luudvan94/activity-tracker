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
        
        GeometryReader { geometry in
            ZStack {
                shadowColor
                    .cornerRadius(DrawingConstants.shadowCornerRadius)
                    .position(shadowPosition(in: geometry))
            
                mainColor
                    .cornerRadius(DrawingConstants.cornerRadius)
                    .position(position(on: tapped, in: geometry))
                    .animation(.easeInOut(duration: DrawingConstants.animationDuration), value: tapped)
                
                content
                    .position(position(on: tapped, in: geometry))
                    .animation(.easeInOut(duration: DrawingConstants.animationDuration), value: tapped)
            }
            .gesture(gesture)
        }
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
    
    private func position(on tap: Bool, in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return tap ? shadowPosition(in: geometry) : center
    }
    
    struct DrawingConstants {
        static let shadowOffY: CGFloat = 6
        static let cornerRadius: CGFloat = 10
        static let shadowCornerRadius: CGFloat = 12
        static let animationDuration: Double = 0.1
    }
}

extension View {
    func buttonfity(mainColor: Color, shadowColor: Color, action: @escaping () -> Void) -> some View {
        modifier(Buttonify(mainColor: mainColor, shadowColor: shadowColor, action: action))
    }
}

struct Buttonify_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red
            
            VStack {
                Text("Text").buttonfity(mainColor: .white, shadowColor: .gray, action: {
                    print("tap action")
                }).frame(width: 100, height: 70)
                
                Image(systemName: "calendar").buttonfity(mainColor: .white, shadowColor: .gray, action: {}).frame(width: 80, height: 50)
            }
        }
    }
}
