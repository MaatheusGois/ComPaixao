//
//  FilterCellDelegate.swift
//  PropositoClient
//
//  Created by Matheus Silva on 04/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class FilterCellDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var options = ["Hoje", "Amanhã", "Próximas", "Todas"]

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
        let height: Double = 30
        let width: Double = Double(options[indexPath.row].count) * 16
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 0, left: 20, bottom: 0, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        generatorImpact()
        if indexPath.row != 0 {
            if let view = viewController as? MainController {
                if let cell = view.filterCellDataSource.firstCell {
                    cell.isSelected = false
                }
            }
        }
    }
    func generatorImpact() {
        ImpactFeedback.shared.generateSelectionChanged()
    }
}
