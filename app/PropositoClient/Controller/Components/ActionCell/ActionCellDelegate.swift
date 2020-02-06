//
//  ActionCellDelegate.swift
//  PropositoClient
//
//  Created by Matheus Silva on 03/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class ActionCellDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var actions: Actions?
    weak var viewController: UIViewController?

    func setup(collectionView: UICollectionView, viewController: UIViewController) {
        collectionView.delegate = self
        self.viewController = viewController
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 0, left: 10, bottom: 0, right: 17)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: Double = Double(collectionView.frame.width) * 0.08454
        let width: Double = Double(collectionView.frame.width) - 20
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toActionDetail(index: indexPath.row)
        generatorImpact()
    }
    func toActionDetail(index: Int) {
        let action = actions?[index]
        self.viewController?.performSegue(withIdentifier: "toActionDetail",
                                          sender: action)
    }
    func generatorImpact() {
        ImpactFeedback.shared.generateMedium()
    }
}
