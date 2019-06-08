//
//  StringExtensions.swift
//  Chefie
//
//  Created by Nicolae Luchian on 05/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension String {

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat
        {
            let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height);
            
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            
            return boundingBox.width;
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }

    func parseToDate() -> Date  {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
      //  dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")

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
