//
//  ExampleCell.swift
//  PropositoClient
//
//  Created by Matheus Gois on 01/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit

final class Cell: UICollectionViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var body: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var date: UILabel!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected { }
        }
    }
    
    public func configure(with viewModel: ViewModel, isSizing: Bool = false) {
        body.text = viewModel.body
        date.text = viewModel.date
        title.text = viewModel.title
        layer.cornerRadius = Constants.layoutCornerRadius
        self.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.2509803922, blue: 0.3529411765, alpha: 1)
    }
    
    public static func height(for viewModel: ViewModel, forWidth width: CGFloat) -> CGFloat {
        return Constants.maximumCardHeight
    }
    
}
