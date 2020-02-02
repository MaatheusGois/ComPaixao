//
//  PrayerAllCellDataSource.swift
//  PropositoClient
//
//  Created by Matheus Silva on 25/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class PrayerAllCellDataSource: NSObject, UICollectionViewDataSource {
    var prayers: Prayers
    weak var viewController: UIViewController?
    
    init(prayers: Prayers) {
        self.prayers = prayers
    }
    func setup(collectionView: UICollectionView, viewController: UIViewController) {
        self.viewController = viewController
        collectionView.dataSource = self
        // Registers
        let challengeCell = UINib(nibName: "PrayerCell", bundle: nil)
        collectionView.register(challengeCell, forCellWithReuseIdentifier: "PrayerCell")
    }
    func fetch(delegate: PrayerAllCellDelegate) {
        PrayerHandler.getAll { (response) in
            switch response {
            case .error(let description):
                NSLog(description)
            case .success(let prayers):
                DispatchQueue.main.async {
                    var reversePrayer = prayers
                    reversePrayer = reversePrayer.reversed()
                    self.prayers = reversePrayer
                    delegate.prayers = reversePrayer
                    if let view = self.viewController as? AllPrayersController {
                        view.collectionView.reloadData()
                        view.prayerIllustration()
                    }
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prayers.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrayerCell",
                                                         for: indexPath) as? PrayerCell {
            let prayerViewModel = PrayerCellViewModel(prayer: prayers[indexPath.row])
            cell.nameLabel?.text = prayerViewModel.name
            cell.subjectLabel?.text = prayerViewModel.subject
            cell.descriptionLabel?.text = prayerViewModel.detailTextString
            cell.image?.image = prayerViewModel.image
            return cell
        }
        
        return UICollectionViewCell()
    }
}
