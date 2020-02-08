//
//  PrayerDetailController.swift
//  PropositoClient
//
//  Created by Matheus Silva on 01/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class PrayerDetailController: UIViewController {
    var prayer: Prayer!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var repetition: UILabel!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var illustrationAction: UIImageView!
    var actionCellDelegate = ActionCellDelegate()
    var actionCellDataSource = ActionCellDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupEvents()
    }
    func setup() {
        loadData()
        setupAction()
        setupActions()
    }
    func setupAction() {
        actionCellDelegate.setup(collectionView: collectionView, viewController: self)
        actionCellDataSource.setup(collectionView: collectionView, viewController: self)
    }
    func setupActions() {
        PrayerHandler.getActions(uuid: prayer.uuid) { (response) in
            switch response {
            case .error(let description):
                print(description)
            case .success(let actions):
                self.actionCellDataSource.setActions(actions: actions, delegate: actionCellDelegate)
            }
        }
    }
    func loadData() {
        let prayerViewModel = PrayerDetailViewModel(prayer: prayer)
        name.text = prayerViewModel.name
        subject.text = prayerViewModel.subject
        date.text = prayerViewModel.date
        hours.text = prayerViewModel.hours
        repetition.text = prayerViewModel.repetition
        notification.text = prayerViewModel.notification
        image.image = prayerViewModel.image
    }
    func actionIllustration() {
        if (actionCellDataSource.actionsFilted?.count ?? 0) > 0 {
            illustrationAction.fadeOut(duration: 0, delay: 0) { (_) in }
        } else {
            illustrationAction.fadeIn(duration: 0.3, delay: 0) { (_) in }
        }
    }
    func setupEvents() {
        EventManager.shared.listenTo(eventName: "reloadAction") {
            self.setupActions()
        }
        EventManager.shared.listenTo(eventName: "reloadPrayer") { prayer in
            guard let prayer = prayer as? Prayer else { return }
            self.prayer = prayer
            self.setup()
        }
    }
    func generatorImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    // MARK: - Actions
    @IBAction func finish(_ sender: Any? = nil) {
        generatorImpact()
        PrayerHandler.answered(pray: prayer) { (response) in
            switch response {
            case .error(let description):
                NSLog(description)
            case .success(_:):
                DispatchQueue.main.async {
                    self.close()
                    EventManager.shared.trigger(eventName: "reloadPrayer")
                    EventManager.shared.trigger(eventName: "reloadAction")
                }
            }
        }
    }
    @IBAction func close(_ sender: Any? = nil) {
        generatorImpact()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func edit(_ sender: Any? = nil) {
        generatorImpact()
        performSegue(withIdentifier: "toPrayerEdit", sender: nil)
    }
    @IBAction func deletePrayer(_ sender: Any? = nil) {
        generatorImpact()
        UIAlert.show(controller: self, title: "Tem certeza que deseja apagar essa oração?",
                     message: "Junto a essa oração, serão deletados todas as práticas relacionadas a ela",
                     alertAction1: "Apagar") { (response) in
                        if response {
                            self.generatorImpact()
                            PrayerHandler.delete(pray: self.prayer) { (response) in
                                switch response {
                                case .error(let description):
                                    print(description)
                                case .success(_:):
                                    DispatchQueue.main.async {
                                        self.close()
                                        EventManager.shared.trigger(eventName: "reloadPrayer")
                                        EventManager.shared.trigger(eventName: "reloadAction")
                                    }
                                }
                            }
                        }
        }
    }
    @IBAction func addAction(_ sender: Any) {
        generatorImpact()
        performSegue(withIdentifier: "toAction", sender: nil)
    }
    // MARK: - NEXT
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? ActionDetailController,
            let action = sender as? Action {
            view.action = action
        } else if let view = segue.destination as? PrayerViewController {
            view.prayer = prayer
            view.isUpdate = true
        } else if let view = segue.destination as? ActionViewController {
            view.prayID = prayer.uuid
            view.isAdd = true
        }
    }
}
