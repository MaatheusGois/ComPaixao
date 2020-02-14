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
    var notification = false
    var repetition = false
    var dateTime = Date()
    var prayer: Prayer!
    var isUpdate = false
    var tap: UITapGestureRecognizer!
    var swipe: UISwipeGestureRecognizer!
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
        date.minimumDate = Date()
        date.date = Date()
        date.subviews[0].subviews[1].backgroundColor = .primary
        date.subviews[0].subviews[2].backgroundColor = .primary
        date.subviews[0].subviews[1].alpha = 0.2
        date.subviews[0].subviews[2].alpha = 0.2
    }
    func setupTime() {
        time.minimumDate = Date()
        time.date = Date()
        time.subviews[0].subviews[1].backgroundColor = .primary
        time.subviews[0].subviews[2].backgroundColor = .primary
        time.subviews[0].subviews[1].alpha = 0.2
        time.subviews[0].subviews[2].alpha = 0.2
    }
    // MARK: - Update Prayer
    func edit() {
        name.setText(text: prayer.name)
        subject.setText(text: prayer.subject)
        date.date = prayer.date
        time.date = prayer.date
        dateTime = prayer.date
        setupNotification()
        setupLayout()
        setupEditImage()
        setupEditRepeat()
    }
    func setupNotification() {
        notification = prayer.notification
        repetition = prayer.repetition
        notificationSwitch.isOn = prayer.notification
        repeatNotificationsView.isHidden = !prayer.notification
        collectionViewRepeat.isHidden = !prayer.repetition
        repeatSwitch.isOn = prayer.repetition
    }
    func setupEditImage() {
        if let index: Int = imageProfileCellDataSource.images.firstIndex(of: prayer.image) {
            imageProfileCellDataSource.selectedCell(selected: index)
        }
        imageSelected = prayer.image
    }
    func setupEditRepeat() {
        let selected = prayer.whenRepeat ?? repeatCellDataSource.options[0]
        if let index: Int = repeatCellDataSource.options.firstIndex(of: selected) {
            repeatCellDataSource.selectedCell(selected: index)
        }
        repeatSelected = selected
    }
    func setupLayout() {
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
        time.date = dateTime
    }
    @IBAction func timePickerChanged(_ sender: UIDatePicker) {
        dateTime = sender.date
        date.date = dateTime
    }
    @IBAction func notificationChanged(_ sender: UISwitch) {
        if sender.isOn { Notification.getAuthorization() }
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
        let updateTime = dateTime > Date() ? dateTime : Date().addingTimeInterval(60)
        let prayer = Prayer(uuid: isUpdate ? self.prayer.uuid : UUID().uuidString,
                            name: name.text ?? "",
                            subject: subject.text ?? "",
                            image: imageSelected,
                            date: updateTime,
                            time: DateUltils.shared.getTime(date: updateTime),
                            notification: notification,
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
                self.sendNotification(prayer: prayer)
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
                self.sendNotification(prayer: prayer)
                self.close()
            }
        }
    }
    func sendNotification(prayer: Prayer) {
        if prayer.notification, PrayerNotification.isOn {
            Notification.send(titulo: "Lembre-se de orar 🙏🏻",
                              subtitulo: "Sua oração é por: \(prayer.name != "" ? prayer.name : "Ops, sem título 🤷‍♂")",
                              mensagem:
                                "O propósito é: \(prayer.subject != "" ? prayer.subject : "Ops, sem descrição 😬")",
                              identificador: prayer.uuid,
                              type: "prayer",
                              timeInterval: prayer.date.timeIntervalSinceNow,
                              repeats: prayer.repetition)
        }
    }
    // MARK: - Keyboard
    func setupKeyboard() {
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
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
        view.addGestureRecognizer(swipe)
    }
    @objc
    private func keyboardWillHide(sender: NSNotification) {
        view.frame.origin.y = 0
        view.removeGestureRecognizer(tap)
        view.removeGestureRecognizer(swipe)
    }
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}
