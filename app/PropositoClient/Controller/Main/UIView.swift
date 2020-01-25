//
//  UIView.swift
//  PropositoClient
//
//  Created by Matheus Silva on 25/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

extension UIView {
    
    enum Style {
        case card
        case circle
        case rounded
    }
    
    func setStyle(_ style: Style) {
        switch style {
        case .card:
            clipsToBounds = true
            layer.cornerRadius = 4
            
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowRadius = 12
            layer.shadowOpacity = 0.16
        case .circle:
            clipsToBounds = true
            let radius = frame.height / 2
            layer.cornerRadius = radius
            
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowRadius = 4
            layer.shadowOpacity = 0.25
            layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        case .rounded:
            clipsToBounds = true
            layer.cornerRadius = frame.height / 2
        }
    }
    
}
