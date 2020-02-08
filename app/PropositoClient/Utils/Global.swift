//
//  Global.swift
//  PropositoClient
//
//  Created by Matheus Silva on 02/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

struct Global {
    static let uuidAllPrayer = UUID(uuidString: "8D31B96A-02AC-4531-976F-A455686F8FE2")!
    static var isDark: Bool {
        get {
            let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "main") as? MainController
            return viewController?.traitCollection.userInterfaceStyle == .dark
        }
    }
}
