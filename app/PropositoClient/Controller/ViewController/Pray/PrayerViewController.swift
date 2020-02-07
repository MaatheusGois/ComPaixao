//
//  PrayerViewController.swift
//  PropositoClient
//
//  Created by Matheus Silva on 30/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class PrayerViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var lineName: UIImageView!
    @IBOutlet weak var time: UIDatePicker!
    @IBOutlet weak var name: TextFieldWithReturn!
    @IBOutlet weak var subject: TextFieldWithReturn!
    @IBOutlet weak var repeatNotificationsView: UIStackView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var collectionView: UICollectionView!
    var imageProfileCellDelegate = ImageProfileCellDelegate()
    var imageProfileCellDataSource = ImageProfileCellDataSource()
    @IBOutlet weak var collectionViewRepeat: UICollectionView!
    var repeatCellDelegate = RepeatCellDelegate()
    var repeatCellDataSource = RepeatCellDataSource()
    var imageSelected = ""
    var repeatSelected = ""
    var remember = false
    var repetition = false
    var dateTime = Date()
    var prayer: Prayer!
    var isUpdate = false
    var tap: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    func setup() {
        setupName()
        setupSubject()
        setupCollection()
        setupDate()
        setupTime()
        setupCollectionRepeat()
        setupKeyboard()
        if isUpdate { edit() }
    }
    func setupName() {
        name.tintColor = .primary
        name.addPadding(.left(10))
        lineName.frame.size.height = 0.2
    }
    func setupSubject() {
        subject.tintColor = .primary
        subject.addPadding(.left(10))
    }
    func setupCollection() {
        imageSelected = imageProfileCellDataSource.images[0]
        imageProfileCellDataSource.setup(collectionView: collectionView)
        imageProfileCellDelegate.setup(collectionView: collectionView, viewController: self)
    }
    func setupCollectionRepeat() {
        repeatSelected = repeatCellDataSource.options[0]
        repeatCellDataSource.setup(collectionView: collectionViewRepeat)
        repeatCellDelegate.setup(collectionView: collectionViewRepeat, viewController: self)
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
    func edit() {
        name.setText(text: prayer.name)
        subject.setText(text: prayer.subject)
        imageSelected = prayer.image
        date.date = prayer.date
        time.date = prayer.date
        notificationSwitch.isOn = prayer.remember
        repeatSwitch.isOn = prayer.repetition
        repeatSelected = prayer.whenRepeat ?? repeatCellDataSource.options[0]
        setupEdition()
    }
    func setupEdition() {
        titleLabel.text = "Oração"
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
        let prayer = Prayer(uuid: isUpdate ? self.prayer.uuid : UUID().uuidString,
                            name: name.text ?? "",
                            subject: subject.text ?? "",
                            image: imageSelected,
                            date: dateTime,
                            time: DateUltils.shared.getTime(date: dateTime),
                            remember: remember,
                            repetition: repetition,
                            whenRepeat: repetition ? repeatSelected : "",
                            answered: false,
                            actions: isUpdate ? self.prayer.actions : [])
        if isUpdate { update(prayer: prayer) } else { create(prayer: prayer) }
    }
    func create(prayer: Prayer) {
        PrayerHandler.create(pray: prayer) { (response) in
            switch response {
            case .error(let description):
                NSLog(description)
            case .success(_:):
                EventManager.shared.trigger(eventName: "reloadPrayer")
                self.close()
            }
        }
    }
    func update(prayer: Prayer) {
        PrayerHandler.update(pray: prayer) { (response) in
            switch response {
            case .error(let description):
                NSLog(description)
            case .success(let prayer):
                EventManager.shared.trigger(eventName: "reloadPrayer", information: prayer)
                self.close()
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
