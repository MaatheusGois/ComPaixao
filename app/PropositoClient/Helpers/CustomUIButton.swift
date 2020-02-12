//
//  CustomUIButton.swift
//  PropositoClient
//
//  Created by Matheus Silva on 06/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class CustomUIButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func setup() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20.0
        self.layer.borderWidth = 1.5
        self.frame.size.height = 40.0
        self.setTitleColor(.white, for: .normal)
        self.sizeToFit()
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
    }
}
