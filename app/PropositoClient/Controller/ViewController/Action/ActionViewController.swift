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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var lineName: UIImageView!
    @IBOutlet weak var time: UIDatePicker!
    @IBOutlet weak var byPerson: UIPickerView!
    @IBOutlet weak var name: TextFieldWithReturn!
    @IBOutlet weak var collectionViewRepeat: UICollectionView!
    @IBOutlet weak var repeatNotificationsView: UIStackView!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var notificationSwitch: UISwitch!
    var repeatCellDelegate = RepeatCellDelegate()
    var repeatCellDataSource = RepeatCellDataSource()
    var pickerPersonDelegate = PickerPersonDelegate()
    var pickerPersonDataSource = PickerPersonDataSource()
    var repeatSelected = ""
    var notification = false
    var repetition = false
    var dateTime = Date()
    var prayerSelected: String?
    var prayerOldSelected: String?
    var action: Action!
    var isUpdate = false
    var tap: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup() {
        setupName()
        setupByPrayerData()
        setupDate()
        setupTime()
        setupCollectionRepeat()
        generatorImpact()
        setupKeyboard()
        if isUpdate { edit() }
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
        date.minimumDate = Date()
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
    // MARK: - Update Prayer
    func edit() {
        name.setText(text: action.name)
        date.date = action.date
        time.date = action.date
        dateTime = action.date
        setupNotification()
        setupLayout()
        setupEditRepeat()
    }
    func byPersonPicker() {
        if let prayerID = action.prayID,
            prayerID != "",
            let prayers = pickerPersonDataSource.prayers {
            var count = 0
            while prayers[count].uuid != prayerID {
                count += 1
            }
            prayerSelected = prayers[count].uuid
            prayerOldSelected = prayerSelected
            self.byPerson.selectRow(count + 1, inComponent: 0, animated: true)
        }
    }
    func setupNotification() {
        notification = action.notification
        repetition = action.repetition
        notificationSwitch.isOn = action.notification
        repeatNotificationsView.isHidden = !action.notification
        collectionViewRepeat.isHidden = !action.repetition
        repeatSwitch.isOn = action.repetition
    }
    func setupEditRepeat() {
        let selected = action.whenRepeat ?? repeatCellDataSource.options[0]
        if let index: Int = repeatCellDataSource.options.firstIndex(of: selected) {
            repeatCellDataSource.selectedCell(selected: index)
        }
        repeatSelected = selected
    }
    func setupLayout() {
        titleLabel.text = "Prática"
        subtitleLabel.text = "Atualizar"
    }
    func generatorImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    // MARK: - Actions
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
        notification = sender.isOn
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
        let actionDone = Action(uuid: isUpdate ? action.uuid : UUID().uuidString,
                            prayID: prayerSelected,
                            name: name.text ?? "",
                            date: dateTime,
                            time: DateUltils.shared.getTime(date: dateTime),
                            notification: notification,
                            repetition: repetition,
                            whenRepeat: repetition ? repeatSelected : "",
                            completed: false)
        isUpdate ? update(action: actionDone) : create(action: actionDone)
    }
    func create(action: Action) {
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
    func update(action: Action) {
        ActionHandler.update(act: action) { (response) in
            switch response {
            case .error(let description):
                NSLog(description)
            case .success(let action):
                if let prayerID = prayerSelected,
                    let prayerOldID = prayerOldSelected,
                    prayerID != prayerOldSelected,
                    prayerID != "" {
                    PrayerHandler.updateAction(prayerID: prayerID,
                                               prayerOldID: prayerOldID,
                                               actionID: action.uuid) { (response) in
                        switch response {
                        case .error(let description):
                            NSLog(description)
                        case .success(_:):
                            EventManager.shared.trigger(eventName: "reloadAction", information: action)
                            EventManager.shared.trigger(eventName: "reloadPrayer")
                            self.close()
                        }
                    }
                } else {
                    EventManager.shared.trigger(eventName: "reloadAction", information: action)
                    self.close()
                }
            }
        }
    }
    // MARK: - Keyboard
    func setupKeyboard() {
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc
    private func keyboardWillShow(sender: NSNotification) {
        view.frame.origin.y = -150
        view.addGestureRecognizer(tap)
    }
    @objc
    private func keyboardWillHide(sender: NSNotification) {
        view.frame.origin.y = 0
        view.removeGestureRecognizer(tap)
    }
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}
