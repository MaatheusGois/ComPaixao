//
//  PlaceholderColor.swift
//  PropositoClient
//
//  Created by Matheus Silva on 30/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit
extension UITextField {
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(
                string: self.placeholder != nil ? self.placeholder! : "",
                attributes: [NSAttributedString.Key.foregroundColor: newValue!.withAlphaComponent(0.3)])
        }
    }
}
