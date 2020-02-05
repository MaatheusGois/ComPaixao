//
//  ActionCellDataSource.swift
//  PropositoClient
//
//  Created by Matheus Silva on 03/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class ActionCellDataSource: NSObject, UICollectionViewDataSource {
    var actions: Actions?
    weak var viewController: UIViewController?
    var collectionView: UICollectionView?
    
    func setup(collectionView: UICollectionView, viewController: UIViewController) {
        self.viewController = viewController
        self.collectionView = collectionView
        setupCollection(collectionView: collectionView)
    }
    func setupCollection(collectionView: UICollectionView) {
        collectionView.dataSource = self
        let cell = UINib(nibName: "ActionCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: "ActionCell")
    }
    func fetch(delegate: ActionCellDelegate) {
        ActionHandler.getAll { (response) in
            switch response {
            case .error(let description):
                NSLog(description)
            case .success(let actions):
                let actionsNoCompleted = actions.filter { !$0.completed }
                DispatchQueue.main.async {
                    self.actions = actionsNoCompleted
                    delegate.actions = actionsNoCompleted
                    if let view = self.viewController as? MainController {
                        view.actionCollectionView.reloadData()
                        view.actionIllustration()
                    }
                }
            }
        }
    }
    func getActionsToday() -> Actions? {
        let calendar = Calendar.current
        return actions?.filter({calendar.isDateInToday($0.date)})
    }
    func getActionsTomorrow() -> Actions? {
        let calendar = Calendar.current
        return actions?.filter({calendar.isDateInTomorrow($0.date)})
    }
    func getActionsNexts() -> Actions? {
        return actions?.enumerated().compactMap { $0.offset < 10 ? $0.element : nil }
    }
    func getActionsAll() -> Actions? {
        return actions
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.actions?.count == 0 {
            return 0
        }
        return (self.actions?.count ?? 0)
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionCell",
                                                         for: indexPath) as? ActionCell {
            let index = indexPath.row
            let viewModel = ActionCellViewModel(action: (actions?[index])!)
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
                                              sender: actions?[sender.tag])
            generatorImpact()
        }
    }
    @objc
    func done(_ sender: Any) {
        if let button = sender as? UIButton {
            let row = button.tag
            if var action = actions?[row] {
                action.completed = true //Make action done
                ActionHandler.update(act: action) { (response) in
                    switch response {
                    case .error(let description):
                        NSLog(description)
                    case .success( _):
                        DispatchQueue.main.async {
                            if let cell = self.collectionView?.cellForItem(at: IndexPath(row: row, section: 0))
                                as? ActionCell {
                                cell.complete(duration: 0.5, delay: 0) { (response) in
                                    if response {
                                        EventManager.shared.trigger(eventName: "reloadAction")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        generatorImpact()
    }
//    func hideAction(row: Int, withCompletion
//        completion: @escaping (Bool) -> Void) {
//         else {
//            completion(false)
//        }
//    }
    func generatorImpact() {
        ImpactFeedback.shared.generateMedium()
    }
}
