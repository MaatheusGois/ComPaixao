//
//  AddPrayViewController.swift
//  PropositoClient
//
//  Created by Matheus Gois on 02/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit

class AddActionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    //Button of close
    @IBAction func close(_ sender: Any) {
        self.configTransition()
        self.dismiss(animated: false, completion: nil)
    }
    
    
    //Description
    @IBOutlet weak var descriptionPray: UITextField!
    @IBOutlet weak var alertDescription: UILabel!
    

    func validateDescription() -> Bool {
        return descriptionPray.text != ""
    }
    
    
    //Picker of prayers
    var pickerData: [String] = [String]()
    var pickerDataId: [Int] = [Int]()
    var pickerSelected: String = ""
    
    @IBOutlet weak var pickerPray: UIPickerView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelected = pickerData[row]
    }
    
    
    //Date picker
    var dateInPicker = Date()
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alertDate: UILabel!
    
    func validateDate() -> Bool {
        return datePicker.date >= Date()
    }
    
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        //alert is hiden when the person change the date
        alertDate.isHidden = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateInPicker = sender.date
        
    }
    
    //Button of Add Pray
    @IBAction func addAction(_ sender: UIButton) {
        if validateDescription() {
            if validateDate() {
                //Body
                let title = descriptionPray.text ?? ""
                let pray = pickerSelected
                let date = self.dateInPicker
                
                //Act
                let act = Act(id: Int.gererateId(), title: title, pray: pray, completed: false, date: date)
                
                //Create in CoreDate
                ActHandler.create(act: act) { (res) in
                    switch (res) {
                    case .success(let act):
                        self.createNotification(act)
                        self.goToMain()
                    case .error(let description):
                        print(description)
                    }
                }
            } else {
                alertDate.isHidden = false
            }
        } else {
            alertDescription.isHidden = false
        }
        

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Data of Prayers
        loadData()
        
        setForRemoveAlerts()
        
        //Hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func loadData() {
        //Load data of the Prayers
        PrayHandler.loadPrayWith { (res) in
            switch (res) {
            case .success(let prayers):
                prayers.forEach({ (pray) in
                    self.pickerData.append(pray.title)
                    self.pickerDataId.append(pray.id)
                })
                
                
            case .error(let description):
                print(description)
            }
        }
        
        if pickerData.count != 0 {
            pickerSelected = pickerData[0]
        } else {
            pickerData.append("Nenhuma oração")
        }
        //Set a Color UIPickerView Date
        self.datePicker.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forKeyPath: "textColor")
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
        descriptionPray.addTarget(self, action: #selector(descriptionDidChange(_:)), for: .editingChanged)
    }
    @objc func descriptionDidChange(_ textField: UITextField) {
        alertDescription.isHidden = true
    }
    
    //Hide Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    //Create Notification
    func createNotification(_ act:Act) {
        //call app
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        //create body
        let title = act.title
        let subtitle = act.pray
        let mensage = "A fé sem obras é morta!"
        let identifier = "identifier\(title)"
        var time = act.date - Date()
        if(time < 0){
            time = 10
        }
        //create
        appDelegate?.enviarNotificacao(title, subtitle, mensage, identifier, time)
    }
    
    //Transitions
    private func configTransition(){
        let transition: CATransition = CATransition()
        transition.duration = 0.78 / 2
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
