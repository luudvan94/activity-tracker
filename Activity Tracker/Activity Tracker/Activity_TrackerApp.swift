//
//  Activity_TrackerApp.swift
//  Activity Tracker
//
//  Created by luu van on 11/8/21.
//

import SwiftUI

@main
struct Activity_TrackerApp: App {
    
    init() {
        UIScrollView.appearance().keyboardDismissMode = .interactive
    }
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ActivityTrackerTab()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
