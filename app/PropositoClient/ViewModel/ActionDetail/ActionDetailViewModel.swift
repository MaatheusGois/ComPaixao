//
//  ActionDetailViewModel.swift
//  PropositoClient
//
//  Created by Matheus Silva on 03/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class ActionDetailViewModel {
    var name: String
    var prayer: String
    var date: String
    var hours: String
    var image: UIImage
    var repetition: String
    var notification: String
    init(action: Action) {
        name = action.name != "" ? action.name : "Sem título"
        prayer = "Por todos"
        image = UIImage(named: "person_ilustration_0\(Int.random(in: 1...6))")!
        date = action.date.getFormattedDate()
        hours = action.date.getFormattedHours()
        if action.repetition, let whenRepeat = action.whenRepeat {
            repetition = whenRepeat
        } else {
            repetition = "Não se repete"
        }
        notification = action.remember ? "Ativadas" : "Desativadas"
    }
    func getPrayer(prayerID: String) {
        PrayerHandler.getOne(uuid: prayerID) { (response) in
            switch response {
            case .error(let description):
                NSLog(description)
            case .success(let prayer):
                self.prayer = prayer.name
                let nameImage = prayer.image.split(separator: "_")
                let newName = "person_ilustration_\(nameImage[1])"
                self.image = UIImage(named: newName)! // REMAKE
            }
        }
    }
}
