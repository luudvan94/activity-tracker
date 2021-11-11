//
//  Helpers.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import SwiftUI

enum TimeColor {
    typealias ColorSet = (main: Color, shadow: Color)
    
    case sunrise
    case dayLight
    case noon
    case sunset
    case night
    
    var color: ColorSet {
        switch self {
        case .sunrise: return (Color.realLightBlue, Color.realLightBlueShadow)
        case .dayLight: return (Color.blueMint, Color.blueMintShadow)
        case .noon: return (Color.lightYellow, Color.lightYellowShadow)
        case .sunset: return (Color.redPink, Color.redPinkShadow)
        case .night: return (Color.mildDarkBlue, Color.mildDarkBlueShadow)
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
}


