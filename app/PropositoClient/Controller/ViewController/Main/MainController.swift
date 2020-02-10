//
//  MainController.swift
//  PropositoClient
//
//  Created by Matheus Silva on 24/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    @IBOutlet weak var chapter: UILabel!
    @IBOutlet weak var prayerCollectionView: UICollectionView!
    @IBOutlet weak var illustrationPrayer: UIImageView!
    @IBOutlet weak var actionCollectionView: UICollectionView!
    @IBOutlet weak var illustrationAction: UIImageView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    var prayerCellDelegate: PrayerCellDelegate = PrayerCellDelegate(prayers: [])
    var prayerCellDataSource: PrayerCellDataSource = PrayerCellDataSource(prayers: [])
    var actionCellDelegate = ActionCellDelegate()
    var actionCellDataSource = ActionCellDataSource()
    var filterCellDelegate = FilterCellDelegate()
    var filterCellDataSource = FilterCellDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup() {
        setupPrayer()
        setupAction()
        setupFilter()
        prayerIllustration()
        setupEvents()
        setupVC()
        setupChapter()
    }
    func setupVC() {
        FirstTime.isOn = true
    }
    func setupChapter() {
        ChapterHandler.getOne { (response) in
            switch response {
            case .error(let description):
                NSLog(description)
            case .success(let chapter):
                self.chapter.text = chapter.title
            }
        }
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
    func setupFilter() {
        filterCellDataSource.setup(collectionView: filterCollectionView)
        filterCellDelegate.setup(collectionView: filterCollectionView, viewController: self)
    }
    func prayerIllustration() {
        if prayerCellDataSource.prayers.count > 0 {
            illustrationPrayer.fadeOut(duration: 0, delay: 0) { (_) in }
        } else {
            illustrationPrayer.fadeIn(duration: 0.3, delay: 0) { (_) in }
        }
    }
    func actionIllustration() {
        if (actionCellDataSource.actionsFilted?.count ?? 0) > 0 {
            illustrationAction.fadeOut(duration: 0, delay: 0) { (_) in }
        } else {
            illustrationAction.fadeIn(duration: 0.3, delay: 0) { (_) in }
        }
    }
    func setupEvents() {
        EventManager.shared.listenTo(eventName: "reloadPrayer") {
            self.prayerCellDataSource.fetch(delegate: self.prayerCellDelegate)
        }
        EventManager.shared.listenTo(eventName: "reloadAction") {
            self.actionCellDataSource.fetch(delegate: self.actionCellDelegate)
        }
        EventManager.shared.listenTo(eventName: "toPrayerDetail") { sender in
            self.performSegue(withIdentifier: "toPrayerDetail", sender: sender)
        }
        EventManager.shared.listenTo(eventName: "toActionDetail") { sender in
            self.performSegue(withIdentifier: "toActionDetail", sender: sender)
        }
    }
    func generatorImpact() {
        ImpactFeedback.shared.generateMedium()
    }
    // MARK: - Actions
    @IBAction func seeConfig(_ sender: Any) {
        generatorImpact()
    }
    @IBAction func addPrayer(_ sender: Any? = nil) {
        generatorImpact()
    }
    @IBAction func addAction(_ sender: Any? = nil) {
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
