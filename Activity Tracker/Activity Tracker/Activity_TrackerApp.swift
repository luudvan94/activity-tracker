//
//  Activity_TrackerApp.swift
//  Activity Tracker
//
//  Created by luu van on 11/8/21.
//

import SwiftUI
import AVKit

@main
struct Activity_TrackerApp: App {
    
    init() {
        UIScrollView.appearance().keyboardDismissMode = .interactive
        try! AVAudioSession.sharedInstance().setCategory(.playback)
        Video.removeUnneccessaryVideos(with: PersistenceController.preview.container.viewContext)
    }
    
    let persistenceController = PersistenceController.preview

    var body: some Scene {
        WindowGroup {
            ActivityTrackerTab()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
