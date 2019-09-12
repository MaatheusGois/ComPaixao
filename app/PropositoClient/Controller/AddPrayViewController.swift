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
    @IBAction func addWithAction(_ sender: Any) { }
    
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
    
    
    //Validade number of characters in the textfild
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 17
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        return changedText.count <= 17
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
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window!.layer.add(transition, forKey: nil)
    }
    
    private func goToMain(){
        configTransition()
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
}
