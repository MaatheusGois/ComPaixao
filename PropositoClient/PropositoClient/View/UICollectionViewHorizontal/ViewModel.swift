//
//  ViewModel.swift
//  PropositoClient
//
//  Created by Matheus Gois on 01/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit

struct ViewModel: DynamicHeightCalculable {
    
    let title: String
    let body: String?
    let date: String?
    
    init(example: CardModel) {
        title = example.title
        body = example.body
        date = example.date
    }
    
    public func height(forWidth width: CGFloat) -> CGFloat {
        let sizingLabel = UILabel()
        sizingLabel.numberOfLines = 0
        sizingLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        sizingLabel.lineBreakMode = .byTruncatingTail
        sizingLabel.text = body
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size = sizingLabel.sizeThatFits(maxSize)
        
//        return size.height
        return 200
    }
    
}
