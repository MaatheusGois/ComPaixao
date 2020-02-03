//
//  MainController.swift
//  PropositoClient
//
//  Created by Matheus Silva on 24/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    @IBOutlet weak var prayerCollectionView: UICollectionView!
    @IBOutlet weak var illustrationPrayer: UIImageView!
    @IBOutlet weak var actionCollectionView: UICollectionView!
    @IBOutlet weak var illustrationAction: UIImageView!
    var prayerCellDelegate: PrayerCellDelegate = PrayerCellDelegate(prayers: [])
    var prayerCellDataSource: PrayerCellDataSource = PrayerCellDataSource(prayers: [])
    var actionCellDelegate = ActionCellDelegate()
    var actionCellDataSource = ActionCellDataSource()
    //Buttons Filter - FIXME: - Nunca mais faça isso (Fazer uma collectioin)
    @IBOutlet weak var today: UIButton!
    @IBOutlet weak var tomorrow: UIButton!
    @IBOutlet weak var nexts: UIButton!
    @IBOutlet weak var all: UIButton!
    @IBOutlet weak var circleToday: UIImageView!
    @IBOutlet weak var circleTomorrow: UIImageView!
    @IBOutlet weak var circleNexts: UIImageView!
    @IBOutlet weak var circleAll: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup() {
        setupPrayer()
        setupAction()
        prayerIllustration()
        setupEvents()
    }
    func setupPrayer() {
        prayerCellDelegate.setup(collectionView: prayerCollectionView, viewController: self)
        prayerCellDataSource.setup(collectionView: prayerCollectionView, viewController: self)
        prayerCellDataSource.fetch(delegate: prayerCellDelegate)
    }
    func setupAction() {
        actionCellDelegate.setup(collectionView: actionCollectionView, viewController: self)
        actionCellDataSource.setup(collectionView: actionCollectionView, viewController: self)
        actionCellDataSource.fetch(delegate: actionCellDelegate)
    }
    func prayerIllustration() {
        if prayerCellDataSource.prayers.count > 0 {
            illustrationPrayer.fadeOut(duration: 0, delay: 0) { (_) in }
        } else {
            illustrationPrayer.fadeIn(duration: 0.3, delay: 0) { (_) in }
        }
    }
    func actionIllustration() {
        if (actionCellDataSource.actions?.count ?? 0) > 0 {
            illustrationAction.fadeOut(duration: 0, delay: 0) { (_) in }
        } else {
            illustrationAction.fadeIn(duration: 0.3, delay: 0) { (_) in }
        }
    }
    func setupEvents() {
        EventManager.shared.listenTo(eventName: "addPrayer") {
            self.prayerCellDataSource.fetch(delegate: self.prayerCellDelegate)
        }
        EventManager.shared.listenTo(eventName: "reloadAction") {
            self.actionCellDataSource.fetch(delegate: self.actionCellDelegate)
        }
    }
    func generatorImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    // MARK: - Actions
    @IBAction func seeConfig(_ sender: Any) {
        generatorImpact()
    }
    @IBAction func addPrayer(_ sender: Any) {
        generatorImpact()
    }
    @IBAction func addAction(_ sender: Any) {
        generatorImpact()
    }
    @IBAction func seeActionsToday(_ sender: Any) {
        generatorImpact()
    }
    @IBAction func seeActionsTomorrow(_ sender: Any) {
        generatorImpact()
    }
    @IBAction func seeActionsNexts(_ sender: Any) {
        generatorImpact()
    }
    @IBAction func seeActionsAll(_ sender: Any) {
        generatorImpact()
    }
    // MARK: - NEXT
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? PrayerDetailController {
            guard let prayer = sender as? Prayer else {
                NSLog("Não esta chegando a Oração")
                return
            }
            view.prayer = prayer
        } else if let view = segue.destination as? ActionDetailController {
            guard let action = sender as? Action else {
                NSLog("Não esta chegando a Ação")
                return
            }
            view.action = action
        }
    }
}
