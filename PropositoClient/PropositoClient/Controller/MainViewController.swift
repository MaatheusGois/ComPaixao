//
//  MainViewController.swift
//  PropositoClient
//
//  Created by Matheus Gois on 01/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet var collectionViewPray: UICollectionView!
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    
    
    
    private var data: [ExampleModel] = ExampleData.dataSet1
    var first = false
    
    private enum Segment: Int {
        case dataSet1 = 0, dataSet2, dataSet3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        first = true
        setupCollectioView()
    }
    
    private func setupCollectioView() {
        let nib = UINib(nibName: Constants.exampleCellReuseIdentifier, bundle: nil)
        collectionViewPray.register(nib, forCellWithReuseIdentifier: Constants.exampleCellReuseIdentifier)
        
        let edgeInsets = UIEdgeInsets(top: 8.0, left: 20, bottom: 12, right: 16)
        flowLayout.sectionInset = edgeInsets
        
        //Padding
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 16
        
        setCollectionViewHeight(with: data, edgeInsets: flowLayout.sectionInset)
    }
    
    private func setCollectionViewHeight(with data: [ExampleModel], edgeInsets: UIEdgeInsets) {
        let viewModels = data.compactMap { ExampleViewModel(example: $0) }
        
        guard let viewModel = calculateHeighest(with: viewModels, forWidth: Constants.cardWidth) else {
            return
        }
        
        let height = ExampleCell.height(for: viewModel, forWidth: Constants.cardWidth)
        
        flowLayout.itemSize = CGSize(width: Constants.cardWidth, height: height)
        
        collectionViewHeightConstraint.constant = height + edgeInsets.top + edgeInsets.bottom
    }
    
    // MARK: - UICollectionViewDatasource
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.exampleCellReuseIdentifier, for: indexPath) as! ExampleCell
        let example = data[indexPath.item]
        
        let viewModel = ExampleViewModel(example: example)
        
        cell.configure(with: viewModel)

        
        cell.button.tag = indexPath.row
        cell.button.addTarget(self,
                              action: #selector(funcButton),
                              for: .touchUpInside)
        return cell
    }
    
    @objc func funcButton(sender : UIButton){
        print(sender.tag)
        guard let image = UIImage(named: "checkUP") else {
        
            print("Image Not Found")
            return
            
        }
        
        sender.setBackgroundImage(image, for: .selected)
        
    }
    
    
    

}
