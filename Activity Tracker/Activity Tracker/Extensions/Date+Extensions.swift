//
//  Date+Extensions.swift
//  DayTracker
//
//  Created by Luu Van on 7/8/21.
//

import SwiftUI

extension Date {
    var day: Int {
        return Calendar.current.dateComponents([Calendar.Component.day], from: self).day ?? 0
    }
    
    var dayMonthYearFormattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return dateFormatter.string(from: self)
    }
    
    var weekDayMonthYearFormattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
    
    var hourAndMinuteFormattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)
    }
    
    var formattedMonthDayYearMinuteHour: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    var weekDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }
    
    var numberOfDaysInMonth: Int {
        return Calendar.current.range(of: Calendar.Component.day, in: .month, for: self)?.count ?? 31
    }
    
    static func newDate(with day: Int, from source: Date) -> Date {
        var components = Calendar.current.dateComponents([Calendar.Component.day, .month, .year], from: source)
        components.day = day
        
        let date = Calendar.current.date(from: components) ?? source
        return date
    }
    
    static func randomBetween(start: Date, end: Date) -> Date {
        var date1 = start
        var date2 = end
        if date2 < date1 {
            let temp = date1
            date1 = date2
            date2 = temp
        }
        let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? self
    }
}
