//
//  SwitcherVC.swift
//  PropositoClient
//
//  Created by Matheus Silva on 07/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

struct Switcher {
    static func updateRootVC() {
        var rootVC: UIViewController?
        if FirstTime.isOn {
            rootVC = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "main") as? MainController
        } else {
            rootVC = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "tutorial") as? TutorialViewController
        }
        AppIcon.change()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = rootVC
    }
}
