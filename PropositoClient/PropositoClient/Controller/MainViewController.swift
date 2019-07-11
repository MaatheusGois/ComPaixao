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
    
    
    private var prayers: [CardModel] = Data.pray
    private var acts: [CardModel] = Data.act
    
    
    private enum Segment: Int {
        case dataSet1 = 0, dataSet2, dataSet3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        self.prayers = []
        self.acts = []
        //Load data of the Prayers
        PrayHandler.loadPrayWith { (res) in
            switch (res) {
            case .success(let prayers):
                prayers.forEach({ (pray) in
                    self.prayers.append(
                        CardModel(title: pray.title, body: pray.purpose, date: nil)
                    )
                    
                })
                
            case .error(let description):
                print(description)
            }
        }
        //Load data of the Acts
        ActHandler.loadActWith { (res) in
            switch (res) {
            case .success(let acts):
                acts.forEach({ (act) in
                    self.acts.append(CardModel(title: act.title, body: act.pray, date: Date.getFormattedDate(date: act.date)))
                })
            case .error(let description):
                print(description)
            }
        }
        setupCollectioView()
        setupCollectioViewAct()
        collectionViewAct.reloadData()
        collectionViewPray.reloadData()
    }
    
    
    //Pray
    private func setupCollectioView() {
        let nib = UINib(nibName: Constants.cellReuseIdentifier, bundle: nil)
        collectionViewPray.register(nib, forCellWithReuseIdentifier: Constants.cellReuseIdentifier)
        
        let edgeInsets = UIEdgeInsets(top: 8.0, left: 20, bottom: 12, right: 16)
        flowLayoutPray.sectionInset = edgeInsets
        
        //Padding
        flowLayoutPray.minimumInteritemSpacing = 0
        flowLayoutPray.minimumLineSpacing = 16
        
        setCollectionViewHeight(with: prayers, edgeInsets: flowLayoutPray.sectionInset)
    }
    
    
    private func setCollectionViewHeight(with data: [CardModel], edgeInsets: UIEdgeInsets) {
        let viewModels = data.compactMap { ViewModel(example: $0) }
        
        guard let viewModel = calculateHeighest(with: viewModels, forWidth: Constants.cardWidth) else {
            return
        }
        
        let height = Cell.height(for: viewModel, forWidth: Constants.cardWidth)
        
        flowLayoutPray.itemSize = CGSize(width: Constants.cardWidth, height: height)
        
        collectionViewHeightConstraintPray.constant = height + edgeInsets.top + edgeInsets.bottom
    }
    
    //Act
    private func setupCollectioViewAct() {
        let nib = UINib(nibName: Constants.cellReuseIdentifier, bundle: nil)
        collectionViewAct.register(nib, forCellWithReuseIdentifier: Constants.cellReuseIdentifier)
        
        let edgeInsets = UIEdgeInsets(top: 8.0, left: 20, bottom: 12, right: 16)
        flowLayoutAct.sectionInset = edgeInsets
        
        //Padding
        flowLayoutAct.minimumInteritemSpacing = 0
        flowLayoutAct.minimumLineSpacing = 16
        
        setCollectionViewHeightAct(with: acts, edgeInsets: flowLayoutAct.sectionInset)
    }
    
    private func setCollectionViewHeightAct(with data: [CardModel], edgeInsets: UIEdgeInsets) {
        
        let viewModels = data.compactMap { ViewModel(example: $0) }
        
        guard let viewModel = calculateHeighest(with: viewModels, forWidth: Constants.cardWidth) else {
            return
        }
        
        let height = Cell.height(for: viewModel, forWidth: Constants.cardWidth)
        
        flowLayoutAct.itemSize = CGSize(width: Constants.cardWidth, height: height)
        
        collectionViewHeightConstraintAct.constant = height + edgeInsets.top + edgeInsets.bottom
    }
    
    
    
    
    
    
    
    // MARK: - UICollectionViewDatasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewPray {
            return prayers.count
        } else {
            return acts.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier, for: indexPath) as! Cell
        
        
        var example:CardModel
        
        if collectionView == self.collectionViewPray {
            example = prayers[indexPath.item]
            cell.date.alpha = 0
        } else {
            example = acts[indexPath.item]
        }
        
        let viewModel = ViewModel(example: example)
        
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
        
        sender.setBackgroundImage(image, for: .normal)
        
    }
    
    
    

}
