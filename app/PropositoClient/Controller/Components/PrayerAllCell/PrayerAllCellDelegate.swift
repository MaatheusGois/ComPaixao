//
//  PrayerAllCellDelegate.swift
//  PropositoClient
//
//  Created by Matheus Silva on 25/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class PrayerAllCellDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var prayers: Prayers
    weak var viewController: UIViewController?

    init(prayers: Prayers) {
        self.prayers = prayers
    }
    func setup(collectionView: UICollectionView, viewController: UIViewController) {
        collectionView.delegate = self
        self.viewController = viewController
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 0, left: 10, bottom: 0, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: Double = Double(collectionView.frame.width) * 0.4
        let width: Double = Double(collectionView.frame.width - 30) / 2
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toPrayerDetail(index: indexPath.row)
        generatorImpact()
    }
    func toPrayerDetail(index: Int) {
        let prayer = prayers[index]
        self.viewController?.performSegue(withIdentifier: "toPrayerDetail",
                                          sender: prayer)
    }
    func generatorImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
