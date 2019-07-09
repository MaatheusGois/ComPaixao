//
//  Pray.swift
//  PropositoClient
//
//  Created by Matheus Gois on 05/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

struct Pray: Codable {
    let id: Int
    let title, purpose: String
    let answered: Bool
    let acts:[String]
    
    enum CodingKeys: String, CodingKey {
        case id, title, answered, acts, purpose
    }
}

typealias Prayers = [Pray]
