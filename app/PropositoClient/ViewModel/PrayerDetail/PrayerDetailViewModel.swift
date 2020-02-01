//
//  PrayerDetailViewModel.swift
//  PropositoClient
//
//  Created by Matheus Silva on 01/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class PrayerDetailViewModel {
    var name: String
    var date: String
    var image: UIImage
    var repetition: String
    var notification: String
    init(prayer: Prayer) {
        name = prayer.name
        date = prayer.date.description
        if prayer.repetition, let whenRepeat = prayer.whenRepeat {
            repetition = whenRepeat
        } else {
            repetition = "Não se repete"
        }
        notification = prayer.remember ? "Ativadas" : "Desativadas"
        let nameImage = prayer.image.split(separator: "_")
        let newName = "person_ilustration_\(nameImage[1])"
        image = UIImage(named: newName)! //REMAKE
    }
}
