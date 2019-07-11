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
    @IBOutlet weak var data: UILabel!
    
//    @IBOutlet var button: UILabel!

    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                
                let originalTransform = self.transform
                
                if(originalTransform.d == 1) {
       
                    //TODO
                    let sizePadding = ((self.frame.size.height * 1.26)/2 - (self.frame.size.height)/2) - 7
                    
                    //Set scale
                    let scaledTransform = originalTransform.scaledBy(x: 1.14, y: 1.26)
                    //Set translate
                    let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0.0, y: sizePadding)
                    
                    //Animation
                    UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
                        
                        self.transform = scaledAndTranslatedTransform
                        self.alpha = 1
                        
                    })
                }
                
                
            }
            else
            {
                
                UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
                    
                    self.transform = CGAffineTransform.identity
                    self.alpha = 0.5
                    
                })
                
            }
        }
    }
    
    
    
    
    
    private static let sizingCell = UINib(nibName: Constants.cellReuseIdentifier, bundle: nil).instantiate(withOwner: nil, options: nil).first! as! Cell
    
    
    
    
    public func configure(with viewModel: ViewModel, isSizing: Bool = false) {
        body.text = viewModel.body
        
        guard !isSizing else {
            return
        }
        
        title.text = viewModel.title
        layer.cornerRadius = 12.0
        self.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.2509803922, blue: 0.3529411765, alpha: 1)
        if(self.transform.d == 1){
            self.alpha = 0.5
        }
        
        
    }
    
    public static func height(for viewModel: ViewModel, forWidth width: CGFloat) -> CGFloat {
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
        
//        return size.height
        return 200
    }
    
}
