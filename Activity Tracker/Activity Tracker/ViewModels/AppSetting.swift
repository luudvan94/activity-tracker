//
//  AppSetting.swift
//  Activity Tracker
//
//  Created by luu van on 11/22/21.
//

import Combine

class AppSetting: ObservableObject {
    enum Tab {
        case home
        case search
        case user
    }
    
    @Published var displayingTab: Tab = .home
    @Published var colorSet: TimeColor.ColorSet = Helpers.colorByTime()
    
    func selectTab(_ tab: Tab) {
        if displayingTab != tab {
            displayingTab = tab
        }
    }
}
