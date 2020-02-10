//
//  Date.swift
//  PropositoClient
//
//  Created by Matheus Silva on 04/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

extension Date {
    ///Subtract dates
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

extension Date {
    func getFormattedDate() -> String {
        let meses = ["Janeiro", "Fevereiro", "Março", "Abril",
                     "Maio", "Junho", "Julho", "Agosto",
                     "Septembro", "Outubro", "Novembro", "Dezembro"]
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.timeZone = TimeZone(identifier: "BRT")
        dateFormatterPrint.dateFormat = "dd|MM|yyyy"
        let dateArray = dateFormatterPrint.string(from: self).lowercased().split(separator: "|")
        let index: Int = Int(dateArray[1]) ?? 0
        let string = "\(dateArray[0]) de \(meses[index - 1]) de \(dateArray[2])"
        return string
    }
    func getFormattedHours() -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.timeZone = TimeZone(identifier: "BRT")
        dateFormatterPrint.dateFormat = "HH:mm a"
        let string = dateFormatterPrint.string(from: self).lowercased()
        return string
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
