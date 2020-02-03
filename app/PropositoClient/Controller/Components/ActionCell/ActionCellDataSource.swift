//
//  ActionCellDataSource.swift
//  PropositoClient
//
//  Created by Matheus Silva on 03/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class ActionCellDataSource: NSObject, UICollectionViewDataSource {
    var actions: Actions?
    weak var viewController: UIViewController?
    
    
    func setup(collectionView: UICollectionView, viewController: UIViewController) {
        self.viewController = viewController
        collectionView.dataSource = self
        // Registers
        let challengeCell = UINib(nibName: "PrayerCell", bundle: nil)
        collectionView.register(challengeCell, forCellWithReuseIdentifier: "PrayerCell")
        let allChallengeCell = UINib(nibName: "AllPrayerCell", bundle: nil)
        collectionView.register(allChallengeCell, forCellWithReuseIdentifier: "AllPrayerCell")
    }
    func fetch(delegate: ActionCellDelegate) {
        ActionHandler.getAll { (response) in
            switch response {
            case .error(let description):
                NSLog(description)
            case .success(let actions):
                DispatchQueue.main.async {
                    self.actions = actions
                    delegate.actions = actions
                    if let view = self.viewController as? MainController {
                        view.prayerCollectionView.reloadData()
                        view.actionIllustration()
                    }
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.actions?.count == 0 {
            return 0
        }
        return self.prayers.count < 3 ? self.prayers.count + 1 : 4
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionCell",
                                                         for: indexPath) as? ActionCell {
//            let index = indexPath.row
//            let viewModel = ActionCellViewModel(action: actions[index])
//            cell.nameLabel?.text = viewModel.name
//            cell.descriptionLabel?.text = viewModel.detailTextString
            return cell
        }
        
        return UICollectionViewCell()
    }
    @objc
    func toAllPrayers() {
        self.viewController?.performSegue(withIdentifier: "toAllPrayers",
                                          sender: nil)
        generatorImpact()
    }
    func generatorImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
