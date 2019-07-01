//
//  DynamicHeightCalculable.swift
//  PropositoClient
//
//  Created by Matheus Gois on 01/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit

protocol DynamicHeightCalculable {
    func height(forWidth: CGFloat) -> CGFloat
}

func calculateHeighest<T: DynamicHeightCalculable>(with viewModels: [T], forWidth width: CGFloat) -> T? {
    var largestViewModel = viewModels.first
    var largestHeight: CGFloat = 0
    
    for viewModel in viewModels {
        let height = viewModel.height(forWidth: width)
        
        if height > largestHeight {
            largestHeight =  height
            largestViewModel = viewModel
        }
    }
    
    return largestViewModel
}
