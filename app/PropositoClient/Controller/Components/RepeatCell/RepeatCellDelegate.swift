//
//  RepeatCellDelegate.swift
//  PropositoClient
//
//  Created by Matheus Silva on 01/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class RepeatCellDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var options = ["diariamente", "semanalmente", "mensalmente", "anualmente"]

    weak var viewController: UIViewController?
    weak var collectionView: UICollectionView?
    func setup(collectionView: UICollectionView, viewController: UIViewController) {
        collectionView.delegate = self
        self.viewController = viewController
        self.collectionView = collectionView
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: Double = 34
        let size = options[indexPath.row].count
        let width: Double = Double(size) * 12
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 0, left: 20, bottom: 0, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        generatorImpact()
        if indexPath.row != 0 {
            if let view = viewController as? PrayerViewController {
                if let cell = view.repeatCellDataSource.firstCell {
                    cell.isSelected = false
                    view.repeatSelected = options[indexPath.row]
                }
            } else if let view = viewController as? ActionViewController {
                if let cell = view.repeatCellDataSource.firstCell {
                    cell.isSelected = false
                    view.repeatSelected = options[indexPath.row]
                }
            }
        }
    }
    func generatorImpact() {
        ImpactFeedback.shared.generateSelectionChanged()
    }
}
