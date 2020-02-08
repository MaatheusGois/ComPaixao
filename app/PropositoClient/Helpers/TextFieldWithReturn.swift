//
//  KeyboardReturn.swift
//  PropositoClient
//
//  Created by Matheus Silva on 30/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class TextFieldWithReturn: UITextField, UITextFieldDelegate {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func setText(text: String) {
        self.text = text
    }
}
