//
//  Pray.swift
//  PropositoClient
//
//  Created by Matheus Gois on 05/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit

struct Prayer: Codable {
    let id: UUID
    var name: String
    var image: String
    var date: Date
    var time: String
    var remember: Bool
    var repetition: Bool
    var whenRepeat: String?
    var answered: Bool
    var actions: [UUID]
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, date, time, remember, repetition, answered, actions
    }
}

typealias Prayers = [Prayer]
