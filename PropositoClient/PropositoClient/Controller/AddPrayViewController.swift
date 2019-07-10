//
//  AddPrayViewController.swift
//  PropositoClient
//
//  Created by Matheus Gois on 10/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit

class AddPrayViewController: UIViewController {

    @IBAction func close(_ sender: Any) {
        //Animate transition
        let transition: CATransition = CATransition()
        transition.duration = 0.78
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Hide Keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }


    //Hide Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
