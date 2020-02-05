//
//  Date.swift
//  PropositoClient
//
//  Created by Matheus Silva on 01/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class DateUltils {
    
    private init() {}
    static let shared = DateUltils()
    
    func getTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a" // "a" prints "pm" or "am"
        formatter.timeZone = TimeZone(abbreviation: "BRT")
        let hourString = formatter.string(from: date)
        return hourString
    }
    func filter(dates: [Date]) {
        let calendar = Calendar.current
        let todayDates = dates.filter({calendar.isDateInToday($0 as Date)})
        let tomorrowDates = dates.filter({calendar.isDateInTomorrow($0 as Date)})
    }
}
