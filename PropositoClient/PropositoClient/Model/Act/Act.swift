//
//  Act.swift
//  PropositoClient
//
//  Created by Matheus Gois on 08/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation


struct Act: Codable {
    let id: Int
    let title, pray: String
    let completed: Bool
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id, title, pray, completed, date
    }
}

typealias Acts = [Act]
