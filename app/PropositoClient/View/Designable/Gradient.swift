//
//  Gradient.swift
//  PropositoClient
//
//  Created by Matheus Silva on 24/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class Colors {
    var gl:CAGradientLayer!

    init() {
        let colorTop = UIColor(red: 41 / 255.0, green: 54 / 255.0, blue: 111 / 255.0, alpha: 0.7).cgColor
        let colorBottom = UIColor(red: 37 / 255.0, green: 45 / 255.0, blue: 81 / 255.0, alpha: 1.0).cgColor

        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}


