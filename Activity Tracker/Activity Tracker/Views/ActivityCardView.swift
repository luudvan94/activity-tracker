//
//  ActivityCardView.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import SwiftUI
import SwiftUIFlowLayout

struct ActivityCardView: View {
    
    var body: some View {
        VStack {
            FlowLayout(mode: .scrollable, items: ["asda", "asda asdads", "asdasd", "asdasd bavsbdvan dbvansdvnavsdbavndv"]) { item in
                Text.regular(item)
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(10)
            }

        }
        .padding(5)
        .buttonfity(mainColor: .redPink, shadowColor: .redPinkShadow, action: {})
    }
}

struct ActivityCardView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCardView()
    }
}
