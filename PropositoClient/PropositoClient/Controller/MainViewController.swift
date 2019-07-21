//
//  MainViewController.swift
//  PropositoClient
//
//  Created by Matheus Gois on 01/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UIScrollViewDelegate {
    //Main Scroll View
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet var collectionViewPray: UICollectionView!
    @IBOutlet var flowLayoutPray: UICollectionViewFlowLayout!
    @IBOutlet var collectionViewHeightConstraintPray: NSLayoutConstraint!
    
    
    @IBOutlet var collectionViewAct: UICollectionView!
    @IBOutlet var flowLayoutAct: UICollectionViewFlowLayout!
    @IBOutlet var collectionViewHeightConstraintAct: NSLayoutConstraint!
    
    
    private var prayersCard: [CardModel] = Data.pray
    private var prayers = [Pray]()
    private var actsCard: [CardModel] = Data.act
    private var acts = [Act]()
    
    private enum Segment: Int {
        case dataSet1 = 0, dataSet2, dataSet3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainScrollView.delegate = self
        loadData()
    }
    
    //Remove horizontal scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if mainScrollView.contentOffset.x != 0 {
            mainScrollView.contentOffset.x = 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        collectionViewAct.reloadData()
        collectionViewPray.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        loadDataPray()
        loadDataAct()
    }
    
    private func loadDataPray(){
        self.prayersCard = []
        self.prayers = []
        PrayHandler.loadPrayWith { (res) in
            switch (res) {
            case .success(let prayers):
                prayers.forEach({ (pray) in
                    if !pray.answered {
                        self.prayers.append(pray)
                        self.prayersCard.append(
                            CardModel(title: pray.title, body: pray.purpose, date: nil)
                        )
                    }
                })
                
            case .error(let description):
                print(description)
            }
        }
        setupCollectioViewPray()
        collectionViewPray.reloadData()
    }
    private func loadDataAct(){
        self.actsCard = []
        self.acts = []
        ActHandler.loadActWith { (res) in
            switch (res) {
            case .success(let acts):
                acts.forEach({ (act) in
                    if !act.completed {
                        self.acts.append(act)
                        self.actsCard.append(
                            CardModel(title: act.title, body: act.pray, date: Date.getFormattedDate(date: act.date))
                        )
                    }
                })
            case .error(let description):
                print(description)
            }
        }
        setupCollectioViewAct()
        collectionViewAct.reloadData()
    }
    
    
    func loadData() {
        self.prayersCard = []
        self.actsCard = []
        //Load data of the Prayers
        PrayHandler.loadPrayWith { (res) in
            switch (res) {
            case .success(let prayers):
                prayers.forEach({ (pray) in
                    if !pray.answered {
                        self.prayers.append(pray)
                        self.prayersCard.append(
                            CardModel(title: pray.title, body: pray.purpose, date: nil)
                        )
                    }
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
                    if !act.completed {
                        self.acts.append(act)
                        self.actsCard.append(
                            CardModel(title: act.title, body: act.pray, date: Date.getFormattedDate(date: act.date))
                        )
                    }
                })
            case .error(let description):
                print(description)
            }
        }
        setupCollectioViewPray()
        setupCollectioViewAct()
        collectionViewAct.reloadData()
        collectionViewPray.reloadData()
    }
    
    
    // Config CollectioView Pray
    private func setupCollectioViewPray() {
        let nib = UINib(nibName: Constants.cellReuseIdentifier, bundle: nil)
        collectionViewPray.register(nib, forCellWithReuseIdentifier: Constants.cellReuseIdentifier)
        
        let edgeInsets = UIEdgeInsets(top: 8.0, left: 20, bottom: 12, right: 16)
        flowLayoutPray.sectionInset = edgeInsets
        
        //Padding
        flowLayoutPray.minimumInteritemSpacing = 0
        flowLayoutPray.minimumLineSpacing = 16
        
        setCollectionViewHeight(with: prayersCard, edgeInsets: flowLayoutPray.sectionInset)
    }
    private func setCollectionViewHeight(with data: [CardModel], edgeInsets: UIEdgeInsets) {
        let viewModels = data.compactMap { ViewModel(example: $0) }
        
        guard let viewModel = calculateHeighest(with: viewModels, forWidth: Constants.cardWidth) else {
            return
        }
        
        let height = Cell.height(for: viewModel, forWidth: Constants.cardWidth)
        
        flowLayoutPray.itemSize = CGSize(width: Constants.cardWidth, height: height)
        
//        collectionViewHeightConstraintPray.constant = height + edgeInsets.top + edgeInsets.bottom
    }
    
    // Config CollectioView Act
    private func setupCollectioViewAct() {
        let nib = UINib(nibName: Constants.cellReuseIdentifier, bundle: nil)
        collectionViewAct.register(nib, forCellWithReuseIdentifier: Constants.cellReuseIdentifier)
        
        let edgeInsets = UIEdgeInsets(top: 8.0, left: 20, bottom: 12, right: 16)
        flowLayoutAct.sectionInset = edgeInsets
        
        //Padding
        flowLayoutAct.minimumInteritemSpacing = 0
        flowLayoutAct.minimumLineSpacing = 16
        
        setCollectionViewHeightAct(with: actsCard, edgeInsets: flowLayoutAct.sectionInset)
    }
    
    private func setCollectionViewHeightAct(with data: [CardModel], edgeInsets: UIEdgeInsets) {
        
        let viewModels = data.compactMap { ViewModel(example: $0) }
        
        guard let viewModel = calculateHeighest(with: viewModels, forWidth: Constants.cardWidth) else {
            return
        }
        
        let height = Cell.height(for: viewModel, forWidth: Constants.cardWidth)
        
        flowLayoutAct.itemSize = CGSize(width: Constants.cardWidth, height: height)
        
//        collectionViewHeightConstraintAct.constant = height + edgeInsets.top + edgeInsets.bottom
    }
    
    
    
    
    
    
    
    // CollectionView Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewPray { return prayersCard.count } else { return actsCard.count }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier, for: indexPath) as! Cell
        var example:CardModel
        
        if collectionView == self.collectionViewPray {
            example = prayersCard[indexPath.item]
            cell.date.alpha = 0
            cell.button.addTarget(self,
                                  action: #selector(funcPrayButtonCheck),
                                  for: .touchUpInside)
        } else {
            example = actsCard[indexPath.item]
            cell.button.addTarget(self,
                                  action: #selector(funcActButtonCheck),
                                  for: .touchUpInside)
        }
        
        let viewModel = ViewModel(example: example)
        cell.configure(with: viewModel)
        cell.button.tag = indexPath.row
        
        
        return cell
    }
    
    @objc func funcPrayButtonCheck(sender : UIButton){
        var prayToUpdate = self.prayers[sender.tag]
        prayToUpdate.answered = true
        updatePray(prayToUpdate)
    }
    @objc func funcActButtonCheck(sender : UIButton){
        var actToUpdate = self.acts[sender.tag]
        actToUpdate.completed = true
        updateAct(actToUpdate)
    }
    
    private func updatePray(_ prayToUpdate:Pray){
        PrayHandler.update(pray: prayToUpdate) { (res) in
            switch (res) {
            case .success(let pray):
                print(pray)
                loadDataPray()
            case .error(let description):
                print(description)
            }
        }
    }
    private func updateAct(_ actToUpdate:Act){
        ActHandler.update(act: actToUpdate) { (res) in
            switch (res) {
            case .success(let act):
                print(act)
                loadDataAct()
            case .error(let description):
                print(description)
            }
        }
    }
    
}
