//
//  Pray.swift
//  PropositoClient
//
//  Created by Matheus Gois on 05/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

struct Pray: Codable {
    let id: Int
    var title, purpose: String
    var answered: Bool
    var acts:[Int]
    
    enum CodingKeys: String, CodingKey {
        case id, title, answered, acts, purpose
    }
}

typealias Prayers = [Pray]
