//
//  ActionCellViewModel.swift
//  PropositoClient
//
//  Created by Matheus Silva on 03/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class ActionCellViewModel {
    var name: String
    var date: String
    init(action: Action) {
        name = action.name != "" ? action.name : "Sem título"
        date = action.time != "" ? action.time : "Indefinida" //TODO - do formatter date
    }
}
