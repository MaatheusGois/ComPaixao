//
//  Extensions.swift
//  PropositoClient
//
//  Created by Matheus Gois on 02/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    static func gererateId() -> Int {
        return Int.random(in: 0..<100000000)
    }
}
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
