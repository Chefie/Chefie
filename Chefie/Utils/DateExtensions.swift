//
//  DateExtensions.swift
//  Chefie
//
//  Created by Nicolae Luchian on 05/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import Firebase

class DateUtils {
    
    public static func getCurrentTimeStamp() -> Timestamp {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        formatter.locale = Locale.current
        
        let time: Date = formatter.date(from: Date().convertDateToString()) ?? Date(timeIntervalSince1970: 0)
        let timeStamp: Timestamp = Timestamp(date: time)
        
        return timeStamp
    }
}

extension Date {

    func convertDateToTimeStamp() -> String {
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let formattedDate = format.string(from: date)
        
        return formattedDate
    }
    
    func convertDateToString() -> String {
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyyy HH:mm:ss"
        format.locale = Locale.current
        let formattedDate = format.string(from: date)
      
        return formattedDate
    }
    
    func timeAgo() -> String {
        
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: Bundle.main.preferredLocalizations[0])
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.calendar = calendar
        
        var dateString: String?
        
        let interval = calendar.dateComponents([.year, .month, .weekOfYear, .day], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            formatter.allowedUnits = [.year] //2 years
        } else if let month = interval.month, month > 0 {
            formatter.allowedUnits = [.month] //1 month
        } else if let week = interval.weekOfYear, week > 0 {
            formatter.allowedUnits = [.weekOfMonth] //3 weeks
        } else if let day = interval.day, day > 0 {
            formatter.allowedUnits = [.day] // 6 days
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: Bundle.main.preferredLocalizations[0])
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            
            dateString = dateFormatter.string(from: self)
        }
        
        if dateString == nil {
            dateString = formatter.string(from: self, to: Date())
        }
        
        return dateString!
    
    }
    
    func timeAgoSinceDate() -> String {
        
        // From Time
        let fromDate = Date()
        
        // To Time
        let toDate = self
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }
        
        return "a moment ago"
    }
    func timeAgoDisplay() -> String {
        
        var calendar = Calendar.current
    //    calendar.locale = Locale(identifier: Bundle.main.preferredLocalizations[0])
        
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: self)!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: self)!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to:  self)!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: self)!
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff)s"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff)m"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff)h"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff)d"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) weeks ago"
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    
    func monthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
   
        let name = dateFormatter.string(from: self).capitalized
        return String(name.prefix(3)).capitalized
    }
    
    func dayNumberOfWeek() -> Int? {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: Bundle.main.preferredLocalizations[0])
        return calendar.dateComponents([.weekday], from: self).weekday
    }
    
    func monthNameLocalized() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self).capitalized(with: Locale.current)
    }
    
    func dayOfWeekLocalized() -> String?  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized(with: Locale.current)
    }
}
