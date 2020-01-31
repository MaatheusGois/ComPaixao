//
//  ActionViewController.swift
//  PropositoClient
//
//  Created by Matheus Silva on 31/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import Foundation
import UIKit

class ActionViewController: UIViewController {
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var lineName: UIImageView!
    @IBOutlet weak var time: UIDatePicker!
    @IBOutlet weak var byPerson: UIPickerView!
    @IBOutlet weak var name: TextFieldWithReturn!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    func setup() {
        setupName()
//        setupByPrayer()
        setupDate()
        setupTime()
    }
    func setupName() {
        name.tintColor = .primary
        name.addPadding(.left(10))
        lineName.frame.size.height = 0.5
    }
    func setupByPrayer() {
        byPerson.subviews[1].backgroundColor = .primary
        byPerson.subviews[2].backgroundColor = .primary
        byPerson.subviews[1].alpha = 0.2
        byPerson.subviews[2].alpha = 0.2
    }
    func setupDate() {
        date.subviews[0].subviews[1].backgroundColor = .primary
        date.subviews[0].subviews[2].backgroundColor = .primary
        date.subviews[0].subviews[1].alpha = 0.2
        date.subviews[0].subviews[2].alpha = 0.2
    }
    func setupTime() {
        time.subviews[0].subviews[1].backgroundColor = .primary
        time.subviews[0].subviews[2].backgroundColor = .primary
        time.subviews[0].subviews[1].alpha = 0.2
        time.subviews[0].subviews[2].alpha = 0.2
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
