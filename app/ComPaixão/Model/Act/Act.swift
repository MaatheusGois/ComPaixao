//
//  Act.swift
//  PropositoClient
//
//  Created by Matheus Gois on 08/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation


struct Act: Codable {
    let id, prayID: Int
    var title, pray: String
    var completed: Bool
    var date: Date
    
    enum CodingKeys: String, CodingKey {
        case id, prayID, title, pray, completed, date
    }
}

typealias Acts = [Act]
