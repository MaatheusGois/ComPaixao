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
