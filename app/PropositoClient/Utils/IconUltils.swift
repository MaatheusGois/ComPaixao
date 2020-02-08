//
//  IconUltils.swift
//  PropositoClient
//
//  Created by Matheus Silva on 07/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

struct AppIcon {
    static func change() {
        if #available(iOS 13.0, *) {
            DispatchQueue.main.async {
                if Global.isDark {
                    UIApplication.shared.setAlternateIconName("AppIcon-DarkMode") { err in
                        print(err)
                    }
                } else {
                    UIApplication.shared.setAlternateIconName("AppIcon")
                }
            }
        }
    }
}
