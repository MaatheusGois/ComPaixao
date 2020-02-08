//
//  ConfigurationController.swift
//  PropositoClient
//
//  Created by Matheus Silva on 01/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class ConfigurationController: UIViewController {
    @IBOutlet weak var prayerSwitch: UISwitch!
    @IBOutlet weak var actionSwitch: UISwitch!
    @IBOutlet weak var iCloudSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        prayerSwitch.isOn = PrayerNotification.isOn
        actionSwitch.isOn = ActionNotification.isOn
        iCloudSwitch.isOn = IClodNotification.isOn
    }
    @IBAction func prayerSwitchChanged(_ sender: UISwitch) {
        PrayerNotification.isOn = sender.isOn
    }
    @IBAction func actionSwitchChanged(_ sender: UISwitch) {
        ActionNotification.isOn = sender.isOn
    }
    @IBAction func iCloudSwitchChanged(_ sender: UISwitch) {
        IClodNotification.isOn = sender.isOn
    }
    @IBAction func close(_ sender: Any) {
        generatorImpact()
        self.dismiss(animated: true, completion: nil)
    }
    func generatorImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
