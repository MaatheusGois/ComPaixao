//
//  PrayerCellDelegate.swift
//  PropositoClient
//
//  Created by Matheus Silva on 25/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class PrayerCellDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var prayers: Prayers
    weak var viewController: UIViewController?

    init(prayers: Prayers) {
        self.prayers = prayers
    }
    func setup(collectionView: UICollectionView, viewController: UIViewController) {
        collectionView.delegate = self
        self.viewController = viewController
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: Double = Double(collectionView.frame.width) * 0.29333333333
        let width: Double = Double(collectionView.frame.width) * 0.42666666666
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let verify = prayers.count > 3 ? indexPath.row == 3 : indexPath.row < prayers.count
        if verify { toChallengeDetail(index: indexPath.row) }
    }
    func toChallengeDetail(index: Int) {
        let prayer = prayers[prayers.count - index - 1]
        self.viewController?.performSegue(withIdentifier: "challengeDetail",
                                          sender: prayer)
    }
}
