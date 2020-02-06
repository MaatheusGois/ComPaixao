//
//  Keyboard.swift
//  PropositoClient
//
//  Created by Matheus Silva on 31/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class Keyboard {
    var viewController: UIViewController?
    var keyboardSizeUp: CGFloat = 150
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    /// Hide Keyboard
    func hide() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: viewController,
            action: #selector(dismissKeyboard))
        viewController?.view.addGestureRecognizer(tap)
    }
    /// Set view up, when keyboard is actived
    func up(keyboardSizeUp: CGFloat = 150) {
        self.keyboardSizeUp = keyboardSizeUp
        //notication when kwyboard is show
        guard let viewController = viewController else { return }
        NotificationCenter.default.addObserver(viewController, selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        //notication when kwyboard is hide
        NotificationCenter.default.addObserver(viewController, selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc
    private func keyboardWillShow(sender: NSNotification) {
//        viewController?.view.frame.origin.y = -(keyboardSizeUp)
    }
    @objc
    private func keyboardWillHide(sender: NSNotification) {
//        viewController?.view.frame.origin.y = 0
    }
    @objc
    private func dismissKeyboard() {
//        viewController?.view.endEditing(true)
    }
}
