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
    @IBOutlet weak var illustrationAction: UIImageView!
    var prayerCellDelegate: PrayerCellDelegate = PrayerCellDelegate(prayers: [])
    var prayerCellDataSource: PrayerCellDataSource = PrayerCellDataSource(prayers: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup() {
        setupCellDelegate()
        setupCellDataSource()
        loadCellData()
        prayerIllustration()
        setupEvents()
    }
    func setupCellDelegate() {
        prayerCellDelegate.setup(collectionView: prayerCollectionView, viewController: self)
    }
    func setupCellDataSource() {
        prayerCellDataSource.setup(collectionView: prayerCollectionView, viewController: self)
    }
    func loadCellData() {
        prayerCellDataSource.fetch(delegate: prayerCellDelegate)
    }
    func prayerIllustration() {
        if prayerCellDataSource.prayers.count > 0 {
            illustrationPrayer.alpha = 0
        } else {
            illustrationPrayer.alpha = 1
        }
    }
    func actionIllustration() {
    }
    func setupEvents() {
        EventManager.shared.listenTo(eventName: "addPrayer") {
            self.prayerCellDataSource.fetch(delegate: self.prayerCellDelegate)
        }
    }
    func generatorImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    //MARK: - Actions
    @IBAction func seeConfig(_ sender: Any) {
        generatorImpact()
    }
    @IBAction func addPrayer(_ sender: Any) {
        generatorImpact()
    }
    @IBAction func addAction(_ sender: Any) {
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
        }
    }
}
