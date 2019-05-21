//
//  StringExtensions.swift
//  Chefie
//
//  Created by Nicolae Luchian on 05/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
extension String {
    
    func parseToDate() -> Date  {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "mm/dd/yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")

        guard let date = dateFormatter.date(from: self)
        else { return Date() }
        return date
    }
    
    func extractInfoFromDate(date : Date) -> String {
        
        var dateWeek : String = ""
        var dateMonth : String = ""
        var dateWeekDayNumber : Int = 0
        
        if let name = date.dayOfWeekLocalized() {
            dateWeek = name
        }
        
        if let monthName = date.monthNameLocalized() {
            dateMonth = monthName
        }
        
        if let weekDayNumber = date.dayNumberOfWeek() {
            dateWeekDayNumber = weekDayNumber
        }
        
        return "\(dateWeek), \(dateMonth) \(dateWeekDayNumber)"
    }
    
    func parseDateWithFormat(format: String) -> Date  {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self)
            else { return Date() }
        return date
    }
}
