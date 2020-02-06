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
    }
    func setup() {
        loadData()
        setupAction()
        setupActions()
        setupEvents()
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
    }
    func generatorImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    // MARK: - Actions
    @IBAction func finish(_ sender: Any? = nil) {
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
    }
    @IBAction func deletePrayer(_ sender: Any? = nil) {
        close()
    }
    // MARK: - NEXT
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if let view = segue.destination as? ActionDetailController {
            guard let action = sender as? Action else {
                NSLog("Não esta chegando a Ação")
                return
            }
            view.action = action
        }
    }
}
