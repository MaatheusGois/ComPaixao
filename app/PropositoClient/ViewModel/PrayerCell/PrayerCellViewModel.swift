//
//  PrayerCellViewModel.swift
//  PropositoClient
//
//  Created by Matheus Silva on 27/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class PrayerCellViewModel {
    var name: String
    var subject: String
    var detailTextString: String
    var image: UIImage
    init(prayer: Prayer) {
        name = prayer.name != "" ? prayer.name : "Sem título"
        subject = prayer.subject != "" ? prayer.subject : "Sem Assunto"
        detailTextString = "Sem práticas"
        image = UIImage(named: prayer.image)! //REMAKE
    }
    func updateAction(prayer: Prayer,
                      withCompletion completion: @escaping (Bool) -> Void) {
        PrayerHandler.getActions(uuid: prayer.uuid) { (response) in
            switch response {
            case .error(let description):
                NSLog(description)
                completion(false)
            case .success(var actions):
                actions = actions.filter { !$0.completed }
                switch actions.count {
                case 0:
                    detailTextString = "Sem práticas"
                case 1:
                    detailTextString = "1 prática"
                default:
                    detailTextString = "\(actions.count) práticas"
                }
                completion(true)
            }
        }
    }
}
