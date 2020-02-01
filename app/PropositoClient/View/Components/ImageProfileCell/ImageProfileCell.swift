//
//  ImageProfileCell.swift
//  PropositoClient
//
//  Created by Matheus Silva on 31/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class ImageProfileCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    override var isSelected: Bool {
        didSet {
            image.alpha = isSelected ? 0.5 : 1
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
