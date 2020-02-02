//
//  ImageProfileCellDelegate.swift
//  PropositoClient
//
//  Created by Matheus Silva on 31/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class ImageProfileCellDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var images = ["person_01", "person_02", "person_03", "person_04", "person_05", "person_06"]
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
        let height: Double = 60
        let width: Double = 60 //Double(collectionView.frame.width) * 0.42666666666
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, 
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 0, left: 20, bottom: 0, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            if let view = viewController as? PrayerViewController {
                if let cell = view.imageProfileCellDataSource.firstCell {
                    cell.isSelected = false
                    view.imageSelected = images[indexPath.row]
                }
            }
        }
        generatorImpact()
    }
    func generatorImpact() {
        ImpactFeedback.shared.generateSelectionChanged()
    }
}
