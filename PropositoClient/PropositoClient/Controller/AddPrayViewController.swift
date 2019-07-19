//
//  AddPrayViewController.swift
//  PropositoClient
//
//  Created by Matheus Gois on 10/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit

class AddPrayViewController: UIViewController, UITextFieldDelegate {
    
    //Back
    @IBAction func close(_ sender: Any) {
        configTransition()
        self.dismiss(animated: false, completion: nil)
    }
    
    //Title
    @IBOutlet weak var titlePray: UITextField!
    @IBOutlet weak var alertTitle: UILabel!
    
    func validateTitlePray() -> Bool {
        return titlePray.text != ""
    }
    
    
    
    //Purpose
    @IBOutlet weak var purposePray: UITextField!
    @IBOutlet weak var alertPurpose: UILabel!
    
    func validatePurposePray() -> Bool {
        return purposePray.text != ""
    }
    
    
    
    //Add With Action
    @IBAction func addWithAction(_ sender: Any) {
        
        
    }
    
    
    //Add
    @IBAction func add(_ sender: Any) {
        
        if validateTitlePray() {
            if validatePurposePray() {
                let title:String   = titlePray.text   ?? ""
                let purpose:String = purposePray.text ?? ""
                let pray = Pray(id: Int.gererateId(), title: title, purpose: purpose, answered: false, acts: [])
                
                //Create Pray in CoreData
                PrayHandler.create(pray: pray) { (res) in
                    switch (res) {
                    case .success(let prayers):
                        print(prayers)
                        goToMain()
                    case .error(let description):
                        print(description)
                    }
                }
            } else {
                alertPurpose.isHidden = false
            }
        } else {
//            print("Dont have text in title")
            alertTitle.isHidden = false
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setForRemoveAlerts()
        
        //Hide Keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    //Take editing in textfilds
    func setForRemoveAlerts() {
        titlePray.addTarget(self, action: #selector(titleDidChange(_:)), for: .editingChanged)
        purposePray.addTarget(self, action: #selector(purposeDidChange(_:)), for: .editingChanged)
    }
    @objc func titleDidChange(_ textField: UITextField) {
        alertTitle.isHidden = true
    }
    @objc func purposeDidChange(_ textField: UITextField) {
        alertPurpose.isHidden = true
    }

    //Hide Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    //Transitions
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
