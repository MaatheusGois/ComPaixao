//
//  PrayerViewController.swift
//  PropositoClient
//
//  Created by Matheus Silva on 30/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class PrayerViewController: UIViewController {
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var lineName: UIImageView!
    @IBOutlet weak var time: UIDatePicker!
    @IBOutlet weak var name: TextFieldWithReturn!
    @IBOutlet weak var repeatNotificationsView: UIStackView!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var collectionView: UICollectionView!
    var imageProfileCellDelegate = ImageProfileCellDelegate()
    var imageProfileCellDataSource = ImageProfileCellDataSource()
    @IBOutlet weak var collectionViewRepeat: UICollectionView!
    var repeatCellDelegate = RepeatCellDelegate()
    var repeatCellDataSource = RepeatCellDataSource()
    
    var imageSelected = ""
    var repeatSelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    func setup() {
        setupName()
        setupCollection()
        setupDate()
        setupTime()
        setupCollectionRepeat()
    }
    func setupName() {
        name.tintColor = .primary
        name.addPadding(.left(10))
        lineName.frame.size.height = 0.2
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
    func setupKeyboard() { //FIXME - arrumar a transicao em outra classe, erro desconhecido
        let keyboard = Keyboard(viewController: self)
        keyboard.hide()
        keyboard.up()
    }
    func generatorImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    // MARK: - Actions
    @IBAction func close(_ sender: Any) {
        generatorImpact()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func add(_ sender: Any) {
        generatorImpact()
        print(imageSelected, repeatSelected)
    }

    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
         let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.short
                dateFormatter.timeStyle = DateFormatter.Style.short
                print(sender.date)
    }
    @IBAction func timePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        print(sender.date)
    }
    @IBAction func notificationChanged(_ sender: UISwitch) {
        repeatNotificationsView.isHidden = !sender.isOn
        if !collectionViewRepeat.isHidden {
            collectionViewRepeat.isHidden = !sender.isOn
            repeatSwitch.isOn = false
        }
    }
    @IBAction func repeatChanged(_ sender: UISwitch) {
        collectionViewRepeat.isHidden = !sender.isOn
    }
}
