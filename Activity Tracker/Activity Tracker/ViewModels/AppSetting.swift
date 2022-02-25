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
        case add
    }
    
    @Published var displayingTab: Tab = .add
    @Published var colorSet: DayTime.ColorSet = Helpers.colorByTime()
    
    func selectTab(_ tab: Tab) {
        if displayingTab != tab {
            displayingTab = tab
        }
    }
}
