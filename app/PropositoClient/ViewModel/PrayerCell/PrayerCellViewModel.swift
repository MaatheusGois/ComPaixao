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
    var detailTextString: String
    var image: UIImage
    init(prayer: Prayer) {
        name = prayer.name != "" ? prayer.name : "Sem título"
        switch prayer.actions.count {
        case 0:
            detailTextString = "Sem práticas"
        case 1:
            detailTextString = "1 prática"
        default:
            detailTextString = "\(prayer.actions.count) práticas"
        }
        image = UIImage(named: prayer.image)! //REMAKE
    }
}
