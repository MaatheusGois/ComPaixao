//
//  FilterCell.swift
//  PropositoClient
//
//  Created by Matheus Silva on 04/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var circle: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var isSelected: Bool {
        didSet {
            name.textColor = isSelected ? .primary : .default01
            circle.backgroundColor = isSelected ? .primary : .default01
            circle.alpha = isSelected ? 1 : 0
        }
    }

}
