//
//  AddPrayViewController.swift
//  PropositoClient
//
//  Created by Matheus Gois on 02/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit

class AddActionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    @IBAction func close(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.78
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
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
    
    //picker of prayers
    var pickerData: [String] = [String]()
    @IBOutlet weak var pickerPray: UIPickerView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Set a Color UIPickerView Date
        self.datePicker.setValue(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forKeyPath: "textColor")
        
        
        //Data of Prayers
        pickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
        
        
        
        //Hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Picker of Pray
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    
    
    
    
    //Notification
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    @IBAction func sendNotification(_ sender: UIButton) {
        //O appDelegate é chamado para usar seu novo método de notificação
        
        //Nas variáveis abaixo definimos o corpo da mensagem
        let titulo = "Aqui vai o título"
        let subtitulo = "Aqui vai o subtítulo"
        let mensagem = "Aqui colocamos o corpo da mensagem"
        
        //O identificador serve para o caso de queremos identificar uma notificação especifica
        let identificador = "identifier\(Int.random(in: 0..<6))"
        
        
        //Tempo
        var tempo = self.dateInPicker - Date()
        if(tempo < 0){
            tempo = 10
        }
        print(tempo)
        self.appDelegate?.enviarNotificacao(titulo, subtitulo, mensagem, identificador, tempo)
        
    }
    
    
    
    //Hide Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
