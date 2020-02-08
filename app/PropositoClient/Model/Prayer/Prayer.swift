//
//  Pray.swift
//  PropositoClient
//
//  Created by Matheus Gois on 05/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit

struct Prayer: Codable {
    let uuid: String
    var name: String
    var subject: String
    var image: String
    var date: Date
    var time: String
    var notification: Bool
    var repetition: Bool
    var whenRepeat: String?
    var answered: Bool
    var actions: [String]
    enum CodingKeys: String, CodingKey {
        case uuid, name, subject, image, date, time, notification, repetition, answered, actions
    }
}

typealias Prayers = [Prayer]
