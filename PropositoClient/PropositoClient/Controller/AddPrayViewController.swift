//
//  AddPrayViewController.swift
//  PropositoClient
//
//  Created by Matheus Gois on 10/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit

class AddPrayViewController: UIViewController {
    
    //Back
    @IBAction func close(_ sender: Any) {
        configTransition()
        self.dismiss(animated: false, completion: nil)
    }
    
    //Title
    @IBOutlet weak var titlePray: UITextField!
    
    
    
    
    //Purpose
    
    @IBOutlet weak var purposePray: UITextField!

    
    
    
    //Add With Action
    @IBAction func addWithAction(_ sender: Any) {
        
        
    }
    
    
    //Add
    @IBAction func add(_ sender: Any) {
        let title = titlePray.text ?? ""
        let purpose = purposePray.text ?? ""
        let id = Int.gererateId()
        let pray = Pray(id: id, title: title, purpose: purpose, answered: false, acts: [])
        PrayHandler.create(pray: pray) { (res) in
            switch (res) {
            case .success(let prayers):
                print(prayers)
                goToMain()
            case .error(let description):
                print(description)
            }
        }
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
    
    private func configTransition(){
        let transition: CATransition = CATransition()
        transition.duration = 0.78  / 2
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window!.layer.add(transition, forKey: nil)
    }
    
    private func goToMain(){
        configTransition()
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
}
