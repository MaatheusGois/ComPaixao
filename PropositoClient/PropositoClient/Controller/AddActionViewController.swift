//
//  AddPrayViewController.swift
//  PropositoClient
//
//  Created by Matheus Gois on 02/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit

class AddActionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    //Button of close
    @IBAction func close(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.78
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    //Description
    @IBOutlet weak var descriptionPray: UITextField!

    
    
    //Picker of prayers
    var pickerData: [String] = [String]()
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
    
    
    
    //Date picker
    var dateInPicker = Date()
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: sender.date)
        
        //print Date
        print(strDate)
        dateInPicker = sender.date
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Data of Prayers
        pickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
        
        
        
        //Set a Color UIPickerView Date
        self.datePicker.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forKeyPath: "textColor")
        
        
        //Hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    

    
    
    
    
    //Button of Add Pray
    
    @IBAction func addAction(_ sender: UIButton) {
        let title = "Aqui vai o título"
        let subtitle = "Aqui vai o subtítulo"
        let mensage = "Aqui colocamos o corpo da mensagem"
        let identifier = "identifier\(title)"
        var time = self.dateInPicker - Date()
        if(time < 0){
            time = 10
        }
        self.createNotification(title, subtitle, mensage, identifier, time)
    }
    
    
    
    //Hide Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func createNotification(_ title: String,_  subtitle: String,_  mensage: String,_  identifier: String, _ time: TimeInterval) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //Create notification
        
        
        appDelegate?.enviarNotificacao(title, subtitle, mensage, identifier, time)
    }
}
