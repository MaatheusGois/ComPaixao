//
//  PrayerCellDataSource.swift
//  PropositoClient
//
//  Created by Matheus Silva on 25/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class PrayerCellDataSource: NSObject, UICollectionViewDataSource {
    var prayers: Prayers
    weak var collectionView: UICollectionView?
    weak var viewController: UIViewController?
    
    init(prayers: Prayers) {
        self.prayers = prayers
    }
    func setup(collectionView: UICollectionView, viewController: UIViewController) {
        self.collectionView = collectionView
        self.viewController = viewController
        collectionView.dataSource = self
        // Registers
        let challengeCell = UINib(nibName: "PrayerCell", bundle: nil)
        collectionView.register(challengeCell, forCellWithReuseIdentifier: "PrayerCell")
        let allChallengeCell = UINib(nibName: "AllPrayerCell", bundle: nil)
        collectionView.register(allChallengeCell, forCellWithReuseIdentifier: "AllPrayerCell")
    }
    func fetch(delegate: PrayerCellDelegate) {
        PrayerHandler.getAll { (response) in
            switch response {
            case .success(let prayers):
                print(prayers)
            case .error(let description):
                print(description) //TODO:- Gerar alerta
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.prayers.count == 0 {
            return 0
        }
        return self.prayers.count < 3 ? self.prayers.count + 1 : 4
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let verify = prayers.count > 3 ? indexPath.row == 3 : indexPath.row == prayers.count
        if verify {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllPrayerCell",
                                                             for: indexPath) as? AllPrayerCell {
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrayerCell",
                                                             for: indexPath) as? PrayerCell {
                let index = prayers.count - indexPath.row - 1
                let prayerViewModel = PrayerCellViewModel(prayer: prayers[index])
                cell.nameLabel?.text = prayerViewModel.name
                cell.descriptionLabel?.text = prayerViewModel.detailTextString
                cell.image.image = prayerViewModel.image
                return cell
            }
        }
        return UICollectionViewCell()
    }
    @objc
    func toChallengeView() {
        self.viewController?.performSegue(withIdentifier: "myChallenges",
                                          sender: nil)
    }
}
