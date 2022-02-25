//
//  Helpers.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import SwiftUI

enum DayTime {
    typealias ColorSet = (main: Color, shadow: Color, textColor: Color)
    
    case sunrise
    case dayLight
    case noon
    case sunset
    case night
    
    var colors: ColorSet {
        switch self {
        case .sunrise: return (Color.realLightBlue, Color.realLightBlueShadow, Color.black)
        case .dayLight: return (Color.blueMint, Color.blueMintShadow, Color.black)
        case .noon: return (Color.lightYellow, Color.lightYellowShadow, Color.black)
        case .sunset: return (Color.redPink, Color.redPinkShadow, Color.white)
        case .night: return (Color.mildDarkBlue, Color.mildDarkBlueShadow, Color.white)
        }
    }
    
}

struct Helpers {
    static func colorByTime(_ time: Date = Date()) -> DayTime.ColorSet {
        let totalMinutes = time.hour * 60 + time.minute
        let timeColor: DayTime
        switch totalMinutes {
        case 300..<480: timeColor = DayTime.sunrise
        case 480..<720: timeColor = DayTime.dayLight
        case 720..<1020: timeColor = DayTime.noon
        case 1020..<1380: timeColor = DayTime.sunset
        default: timeColor = DayTime.night
        }
        return timeColor.colors
    }
    
    struct NotFoundIcon {
        private static let icons = ["tortoise.fill", "ladybug.fill", "hare.fill", "gamecontroller.fill", "earbuds", "moon.stars.fill", "eyes.inverse"]
        
        static func random() -> String {
            icons.randomElement() ?? icons[0]
        }
    }
}


