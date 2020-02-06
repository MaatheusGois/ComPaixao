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
    @IBOutlet weak var collectionViewRepeat: UICollectionView!
    @IBOutlet weak var repeatNotificationsView: UIStackView!
    @IBOutlet weak var repeatSwitch: UISwitch!
    var repeatCellDelegate = RepeatCellDelegate()
    var repeatCellDataSource = RepeatCellDataSource()
    var pickerPersonDelegate = PickerPersonDelegate()
    var pickerPersonDataSource = PickerPersonDataSource()
    var repeatSelected = ""
    var remember = false
    var repetition = false
    var dateTime = Date()
    var prayerSelected: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    func setup() {
        setupName()
        setupByPrayerData()
        setupDate()
        setupTime()
        setupCollectionRepeat()
        generatorImpact()
    }
    func setupName() {
        name.tintColor = .primary
        name.addPadding(.left(10))
        lineName.frame.size.height = 0.5
    }
    func setupByPrayerData() {
        pickerPersonDelegate.config(pickerPerson: byPerson, viewController: self)
        pickerPersonDataSource.config(pickerPerson: byPerson, viewController: self)
        pickerPersonDataSource.fetch(delegate: pickerPersonDelegate)
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
    func setupCollectionRepeat() {
        repeatSelected = repeatCellDataSource.options[0]
        repeatCellDataSource.setup(collectionView: collectionViewRepeat)
        repeatCellDelegate.setup(collectionView: collectionViewRepeat, viewController: self)
    }
    func generatorImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    // MARK: - Actions
    func setupKeyboard() { //TODO - fix
        let keyboard = Keyboard(viewController: self)
        keyboard.hide()
        keyboard.up()
    }
    @IBAction func close(_ sender: Any? = nil) {
        generatorImpact()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        dateTime = sender.date
    }
    @IBAction func timePickerChanged(_ sender: UIDatePicker) {
        dateTime = sender.date
    }
    @IBAction func notificationChanged(_ sender: UISwitch) {
        remember = sender.isOn
        repeatNotificationsView.isHidden = !sender.isOn
        if !collectionViewRepeat.isHidden {
            collectionViewRepeat.isHidden = !sender.isOn
            repeatSwitch.isOn = false
            repetition = false
        }
    }
    @IBAction func repeatChanged(_ sender: UISwitch) {
        repetition = sender.isOn
        collectionViewRepeat.isHidden = !sender.isOn
    }
    @IBAction func add(_ sender: Any) {
        generatorImpact()
        let action = Action(uuid: UUID().uuidString,
                            prayID: prayerSelected,
                            name: name.text ?? "",
                            date: dateTime,
                            time: DateUltils.shared.getTime(date: dateTime),
                            remember: remember,
                            repetition: repetition,
                            whenRepeat: repetition ? repeatSelected : "",
                            completed: false)
        ActionHandler.create(act: action) { (response) in
            switch response {
            case .error(let description):
                NSLog(description)
            case .success(let action):
                if let prayerID = prayerSelected {
                    PrayerHandler.addAction(prayerID: prayerID, actionID: action.uuid) { (response) in
                        switch response {
                        case .error(let description):
                            NSLog(description)
                        case .success(_:):
                            EventManager.shared.trigger(eventName: "reloadAction")
                            EventManager.shared.trigger(eventName: "reloadPrayer")
                            self.close()
                        }
                    }
                } else {
                    EventManager.shared.trigger(eventName: "reloadAction")
                    self.close()
                }
            }
        }
    }
}
