//
//  RepeatCell.swift
//  PropositoClient
//
//  Created by Matheus Silva on 01/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class RepeatCell: UICollectionViewCell {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var text: UILabel!
    
    override var isSelected: Bool {
        didSet {
            background.backgroundColor = isSelected ? .secondary02 : .secondary
            text.textColor = isSelected ? .default02 : .primary
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
