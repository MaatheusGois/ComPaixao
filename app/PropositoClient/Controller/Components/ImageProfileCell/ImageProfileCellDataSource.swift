//
//  ImageProfileCellDataSource.swift
//  PropositoClient
//
//  Created by Matheus Silva on 31/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class ImageProfileCellDataSource: NSObject, UICollectionViewDataSource {
    var images = ["person_01", "person_02", "person_03", "person_04", "person_05", "person_06"]
    weak var collectionView: UICollectionView?
    var firstCell: ImageProfileCell?
    var selected = 0
    func setup(collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.dataSource = self
        let cell = UINib(nibName: "ImageProfileCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: "ImageProfileCell")
    }
    func selectedCell(selected: Int) {
        self.selected = selected
        collectionView?.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ImageProfileCell",
            for: indexPath
        ) as? ImageProfileCell {
            guard let image = UIImage(named: images[indexPath.row]) else {
                return UICollectionViewCell()
            }
            if indexPath.row == selected {
                cell.isSelected = true
                firstCell = cell
            }
            cell.image.image = image
            return cell
        }
        return UICollectionViewCell()
    }
}
