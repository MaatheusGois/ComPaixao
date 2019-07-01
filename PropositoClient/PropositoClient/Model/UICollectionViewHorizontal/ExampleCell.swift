//
//  ExampleCell.swift
//  PropositoClient
//
//  Created by Matheus Gois on 01/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit

final class ExampleCell: UICollectionViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var body: UILabel!
    

    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.backgroundColor = UIColor.red
//                self.tickImageView.isHidden = false
            }
            else
            {
                self.transform = CGAffineTransform.identity
                self.backgroundColor = UIColor.gray
//                self.alpha = 0.5
//                self.tickImageView.isHidden = true
            }
        }
    }
    
    
    
    
    
    private static let sizingCell = UINib(nibName: Constants.exampleCellReuseIdentifier, bundle: nil).instantiate(withOwner: nil, options: nil).first! as! ExampleCell
    
    public func configure(with viewModel: ExampleViewModel, isSizing: Bool = false) {
        body.text = viewModel.body
        
        guard !isSizing else {
            return
        }
        
        title.text = viewModel.title
        layer.cornerRadius = 7.0
    }
    
    public static func height(for viewModel: ExampleViewModel, forWidth width: CGFloat) -> CGFloat {
        sizingCell.prepareForReuse()
        sizingCell.configure(with: viewModel, isSizing: true)
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = width
        
        let size = sizingCell.contentView.systemLayoutSizeFitting(fittingSize,
                                                                  withHorizontalFittingPriority: .required,
                                                                  verticalFittingPriority: .defaultLow)
        

        guard size.height < Constants.maximumCardHeight else {
            return Constants.maximumCardHeight
        }
        
        return size.height
    }
    
}
