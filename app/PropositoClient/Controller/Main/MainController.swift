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
    var prayerCellDelegate: PrayerCellDelegate!
    var prayerCellDataSource: PrayerCellDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func setup() {
        prayerCellDelegate = PrayerCellDelegate(prayers: [])
        prayerCellDataSource = PrayerCellDataSource(prayers: [])
    }
    func setupDelegate() {
        prayerCollectionView.delegate = prayerCellDelegate
        prayerCellDelegate.setup(viewController: self)
    }
    func setupDataSource() {
        prayerCellDataSource.setup(collectionView: prayerCollectionView,
                                   viewController: self)
    }
    func loadData() {
        
    }
    @IBAction func seeConfig(_ sender: Any) {
        generatorImpact()
        performSegue(withIdentifier: "toConfig", sender: nil)
    }
    @IBAction func addPrayer(_ sender: Any) {
        generatorImpact()
    }
    @IBAction func addAction(_ sender: Any) {
        generatorImpact()
    }
    func generatorImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
