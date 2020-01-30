//
//  Extensions.swift
//  PropositoClient
//
//  Created by Matheus Gois on 02/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    //Subtract dates
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

extension Date {
    static func getFormattedDate(date: Date) -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy - HH:mm"
        return dateFormatterPrint.string(from: date) // Feb 01,2018
    }
}

extension Int {
    static func gererateId() -> Int {
        return Int.random(in: 0..<100000000)
    }
}
