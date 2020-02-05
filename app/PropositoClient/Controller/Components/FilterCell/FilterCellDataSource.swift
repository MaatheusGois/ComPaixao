//
//  FilterCellDataSource.swift
//  PropositoClient
//
//  Created by Matheus Silva on 04/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class FilterCellDataSource: NSObject, UICollectionViewDataSource {
    var options = ["Hoje", "Amanhã", "Próximas", "Todas"]
    weak var collectionView: UICollectionView?
    var firstCell: FilterCell?
    func setup(collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.dataSource = self
        let cell = UINib(nibName: "FilterCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: "FilterCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "FilterCell",
            for: indexPath
        ) as? FilterCell {
            if indexPath.row == 0 {
                cell.isSelected = true
                firstCell = cell
            } else {
                cell.name.textColor = .default01
                cell.circle.alpha = 0
            }
            cell.name.text = options[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
}
