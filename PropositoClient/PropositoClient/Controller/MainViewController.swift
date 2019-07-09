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
    @IBOutlet var flowLayoutPray: UICollectionViewFlowLayout!
    @IBOutlet var collectionViewHeightConstraintPray: NSLayoutConstraint!
    
    
    @IBOutlet var collectionViewAct: UICollectionView!
    @IBOutlet var flowLayoutAct: UICollectionViewFlowLayout!
    @IBOutlet var collectionViewHeightConstraintAct: NSLayoutConstraint!
    
    
    private var data: [ExampleModel] = ExampleData.dataSet1
    private var data2: [ExampleModel] = ExampleData.dataSet2
    
    
    private enum Segment: Int {
        case dataSet1 = 0, dataSet2, dataSet3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectioView()
        setupCollectioViewAct()
    }
    
    
    //Pray
    private func setupCollectioView() {
        let nib = UINib(nibName: Constants.exampleCellReuseIdentifier, bundle: nil)
        collectionViewPray.register(nib, forCellWithReuseIdentifier: Constants.exampleCellReuseIdentifier)
        
        let edgeInsets = UIEdgeInsets(top: 8.0, left: 20, bottom: 12, right: 16)
        flowLayoutPray.sectionInset = edgeInsets
        
        //Padding
        flowLayoutPray.minimumInteritemSpacing = 0
        flowLayoutPray.minimumLineSpacing = 16
        
        setCollectionViewHeight(with: data, edgeInsets: flowLayoutPray.sectionInset)
    }
    
    
    private func setCollectionViewHeight(with data: [ExampleModel], edgeInsets: UIEdgeInsets) {
        let viewModels = data.compactMap { ExampleViewModel(example: $0) }
        
        guard let viewModel = calculateHeighest(with: viewModels, forWidth: Constants.cardWidth) else {
            return
        }
        
        let height = ExampleCell.height(for: viewModel, forWidth: Constants.cardWidth)
        
        flowLayoutPray.itemSize = CGSize(width: Constants.cardWidth, height: height)
        
        collectionViewHeightConstraintPray.constant = height + edgeInsets.top + edgeInsets.bottom
    }
    
    //Act
    private func setupCollectioViewAct() {
        let nib = UINib(nibName: Constants.exampleCellReuseIdentifier, bundle: nil)
        collectionViewAct.register(nib, forCellWithReuseIdentifier: Constants.exampleCellReuseIdentifier)
        
        let edgeInsets = UIEdgeInsets(top: 8.0, left: 20, bottom: 12, right: 16)
        flowLayoutAct.sectionInset = edgeInsets
        
        //Padding
        flowLayoutAct.minimumInteritemSpacing = 0
        flowLayoutAct.minimumLineSpacing = 16
        
        setCollectionViewHeightAct(with: data2, edgeInsets: flowLayoutAct.sectionInset)
    }
    
    private func setCollectionViewHeightAct(with data: [ExampleModel], edgeInsets: UIEdgeInsets) {
        
        let viewModels = data.compactMap { ExampleViewModel(example: $0) }
        
        guard let viewModel = calculateHeighest(with: viewModels, forWidth: Constants.cardWidth) else {
            return
        }
        
        let height = ExampleCell.height(for: viewModel, forWidth: Constants.cardWidth)
        
        flowLayoutAct.itemSize = CGSize(width: Constants.cardWidth, height: height)
        
        collectionViewHeightConstraintAct.constant = height + edgeInsets.top + edgeInsets.bottom
    }
    
    
    
    
    
    
    
    // MARK: - UICollectionViewDatasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewPray {
            return data.count
        } else {
            return data2.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.exampleCellReuseIdentifier, for: indexPath) as! ExampleCell
        
        
        var example:ExampleModel
        
        if collectionView == self.collectionViewPray {
            example = data[indexPath.item]
            cell.data.alpha = 0
        } else {
            example = data2[indexPath.item]
        }
        
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
