//
//  ActionCellDataSource.swift
//  PropositoClient
//
//  Created by Matheus Silva on 03/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

enum Filter: Int {
    case today = 0
    case tomorrow
    case nexts
    case all
}

class ActionCellDataSource: NSObject, UICollectionViewDataSource {
    var actions: Actions?
    var actionsFilted: Actions?
    weak var viewController: UIViewController?
    weak var collectionView: UICollectionView?
    weak var delegate: ActionCellDelegate?
    var filterBy = Filter.today
    func setup(collectionView: UICollectionView,
               viewController: UIViewController,
               delegate: ActionCellDelegate) {
        self.viewController = viewController
        self.collectionView = collectionView
        self.delegate = delegate
        setupCollection(collectionView: collectionView)
    }
    func setupCollection(collectionView: UICollectionView) {

        collectionView.dataSource = self
        let cell = UINib(nibName: "ActionCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: "ActionCell")
    }
    func fetch() {

        ActionHandler.getAll { (response) in
            switch response {
            case .error(let description):
                NSLog(description)
            case .success(let actions):
                self.setActions(actions: actions)
            }
        }
    }
    func setActions(actions: Actions) {
        self.actions = actions.filter { !$0.completed }
        self.choiceFilter()
        delegate?.actions = self.actionsFilted
        DispatchQueue.main.async {
            if let view = self.viewController as? MainController {
                view.actionCollectionView.reloadData()
                view.actionIllustration()
            } else if let view = self.viewController as? PrayerDetailController {
                view.collectionView.reloadData()
                view.actionIllustration()
            }
        }
    }
    func choiceFilter() {
        switch filterBy {
        case .today:
            filterToday()
        case .tomorrow:
            filterTomorrow()
        case .nexts:
            filterNexts()
        default:
            filterAll()
        }
        delegate?.actions = self.actionsFilted
    }
    func filterToday() {
        let calendar = Calendar.current
        self.actionsFilted = actions?.filter({calendar.isDateInToday($0.date)})
    }
    func filterTomorrow() {
        let calendar = Calendar.current
        self.actionsFilted = actions?.filter({calendar.isDateInTomorrow($0.date)})
    }
    func filterNexts() {
        self.actionsFilted = actions?.enumerated().compactMap { $0.offset < 10 ? $0.element : nil }
    }
    func filterAll() {
        self.actionsFilted = actions
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.actionsFilted?.count == 0 {
            return 0
        }
        return (self.actionsFilted?.count ?? 0)
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionCell",
                                                         for: indexPath) as? ActionCell {
            let index = indexPath.row
            let viewModel = ActionCellViewModel(action: (actionsFilted?[index])!)
            cell.name?.text = viewModel.name
            cell.date?.text = viewModel.date
            cell.checkButton.tag = indexPath.row
            cell.seeDetailButton.addTarget(self, action: #selector(toActionDetail(_:)), for: .touchUpInside)
            cell.checkButton.addTarget(self, action: #selector(done(_:)), for: .touchUpInside)
            return cell
        }
        return UICollectionViewCell()
    }
    @objc
    func toActionDetail(_ sender: Any) {
        if let sender = sender as? UIButton {
            self.viewController?.performSegue(withIdentifier: "toActionDetail",
                                              sender: actionsFilted?[sender.tag])
            generatorImpact()
        }
    }
    @objc
    func done(_ sender: Any) {
        ImpactFeedback.shared.generateLight()
        if let button = sender as? UIButton {
            let row = button.tag
            if var action = actionsFilted?[row] {
                action.completed = true //Make action done
                ActionHandler.update(act: action) { (response) in
                    switch response {
                    case .error(let description):
                        NSLog(description)
                    case .success(_:):
                        DispatchQueue.main.async {
                            if let cell = self.collectionView?.cellForItem(at: IndexPath(row: row, section: 0))
                                as? ActionCell {
                                cell.complete(duration: 0.5, delay: 0) { (response) in
                                    if response {
                                        EventManager.shared.trigger(eventName: "reloadAction")
                                        EventManager.shared.trigger(eventName: "reloadPrayer")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func generatorImpact() {
        ImpactFeedback.shared.generateMedium()
    }
}
