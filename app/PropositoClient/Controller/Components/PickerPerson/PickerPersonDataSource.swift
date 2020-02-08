//
//  PickerPersonDataSource.swift
//  PropositoClient
//
//  Created by Matheus Silva on 01/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class PickerPersonDataSource: NSObject, UIPickerViewDataSource {
    var prayers: Prayers?
    weak var viewController: UIViewController?
    func config(pickerPerson: UIPickerView, viewController: UIViewController) {
        pickerPerson.dataSource = self
        self.viewController = viewController
    }
    func fetch(delegate: PickerPersonDelegate) {
        PrayerHandler.getAll { (response) in
            switch response {
            case .error(let description):
                NSLog(description)
            case .success(let prayers):
                DispatchQueue.main.async {
                    var reversePrayer = prayers
                    reversePrayer = reversePrayer.reversed().filter({ !$0.answered })
                    self.prayers = reversePrayer
                    delegate.prayers = reversePrayer
                    if let view = self.viewController as? ActionViewController {
                        view.byPerson.reloadAllComponents()
                        if view.isUpdate { view.byPersonPicker() }
                    }
                }
            }
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (prayers?.count ?? 0) + 1
    }
}
