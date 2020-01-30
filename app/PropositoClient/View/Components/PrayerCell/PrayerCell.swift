//
//  PrayerCell.swift
//  PropositoClient
//
//  Created by Matheus Silva on 25/01/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class PrayerCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var prayerViewModel: PrayerCellViewModel! {
        didSet {
            nameLabel?.text = prayerViewModel.name
            descriptionLabel?.text = prayerViewModel.detailTextString
            image?.image = prayerViewModel.image
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
