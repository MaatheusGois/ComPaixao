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
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var byPerson: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    func setup() {
        setupName()
        setupByPrayer()
        setupDate()
        setupTime()
    }
    func setupName() {
        name.addPadding(.left(20))
        lineName.frame.size.height = 0.5
    }
    func setupByPrayer() {
        byPerson.subviews[0].subviews[1].backgroundColor = UIColor(named: "primary")
        byPerson.subviews[0].subviews[2].backgroundColor = UIColor(named: "primary")
        byPerson.subviews[0].subviews[1].alpha = 0.2
        byPerson.subviews[0].subviews[2].alpha = 0.2
    }
    func setupDate() {
        date.subviews[0].subviews[1].backgroundColor = UIColor(named: "primary")
        date.subviews[0].subviews[2].backgroundColor = UIColor(named: "primary")
        date.subviews[0].subviews[1].alpha = 0.2
        date.subviews[0].subviews[2].alpha = 0.2
    }
    func setupTime() {
        time.subviews[0].subviews[1].backgroundColor = UIColor(named: "primary")
        time.subviews[0].subviews[2].backgroundColor = UIColor(named: "primary")
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
