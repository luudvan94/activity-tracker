//
//  Helpers.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import SwiftUI

enum TimeColor {
    typealias ColorSet = (main: Color, shadow: Color, textColor: Color)
    
    case sunrise
    case dayLight
    case noon
    case sunset
    case night
    
    var color: ColorSet {
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
    static func colorByTime(_ time: Date = Date()) -> TimeColor.ColorSet {
        let totalMinutes = time.hour * 60 + time.minute
        let timeColor: TimeColor
        switch totalMinutes {
        case 300..<480: timeColor = TimeColor.sunrise
        case 480..<720: timeColor = TimeColor.dayLight
        case 720..<1020: timeColor = TimeColor.noon
        case 1020..<1380: timeColor = TimeColor.sunset
        default: timeColor = TimeColor.night
        }
        return timeColor.color
    }
    
    struct NotFoundIcon {
        private static let icons = ["tortoise.fill", "ladybug.fill", "hare.fill", "gamecontroller.fill", "earbuds", "moon.stars.fill", "eyes.inverse"]
        
        static func random() -> String {
            icons.randomElement() ?? icons[0]
        }
    }
}


