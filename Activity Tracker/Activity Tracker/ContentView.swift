//
//  ContentView.swift
//  Activity Tracker
//
//  Created by luu van on 11/8/21.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
