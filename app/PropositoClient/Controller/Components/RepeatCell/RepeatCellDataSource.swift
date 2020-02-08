//
//  RepeatCellDataSource.swift
//  PropositoClient
//
//  Created by Matheus Silva on 01/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class RepeatCellDataSource: NSObject, UICollectionViewDataSource {
    var options = ["diariamente", "semanalmente", "mensalmente", "anualmente"]
    weak var collectionView: UICollectionView?
    var firstCell: RepeatCell?
    var selected = 0
    func setup(collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.dataSource = self
        register()
    }
    func register() {
        let cell = UINib(nibName: "RepeatCell", bundle: nil)
        collectionView?.register(cell, forCellWithReuseIdentifier: "RepeatCell")
    }
    func selectedCell(selected: Int) {
        self.selected = selected
        collectionView?.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RepeatCell",
            for: indexPath
        ) as? RepeatCell {
            if indexPath.row == selected {
                cell.isSelected = true
                firstCell = cell
            } else {
                cell.background.backgroundColor = .secondary
                cell.text.textColor = .primary
            }
            cell.text.text = options[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
}
