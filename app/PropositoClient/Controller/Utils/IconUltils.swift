//
//  IconUltils.swift
//  PropositoClient
//
//  Created by Matheus Silva on 07/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

struct IconUltils {
    static func setBy(viewController: UIViewController?) {
        if #available(iOS 13.0, *) {
            if viewController?.traitCollection.userInterfaceStyle == .dark {
                UIApplication.shared.setAlternateIconName("AppIcon-DarkMode")
            } else {
                UIApplication.shared.setAlternateIconName("AppIcon")
            }
        }
    }
}
