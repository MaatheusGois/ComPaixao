//
//  PickerDateDelegate.swift
//  PropositoClient
//
//  Created by Matheus Silva on 01/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class PickerPersonDelegate: NSObject, UIPickerViewDelegate {
    var prayers: Prayers?
    weak var viewController: UIViewController?
    func config(pickerPerson: UIPickerView, viewController: UIViewController) {
        pickerPerson.delegate = self
        self.viewController = viewController
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Por todos"
        } else {
            let title = prayers?[row - 1].name
            return title != "" ? title : "Sem título"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let view = viewController as? ActionViewController {
            view.prayerSelected = row != 0 ? prayers?[row - 1].uuid : ""
            view.prayerNameSelected = row != 0 ? prayers?[row - 1].name ?? "Todos" : "Todos"
        }
        generatorImpact()
    }
    func generatorImpact() {
        ImpactFeedback.shared.generateSelectionChanged()
    }
}
