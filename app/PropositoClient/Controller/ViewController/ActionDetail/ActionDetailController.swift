//
//  ActionDetailController.swift
//  PropositoClient
//
//  Created by Matheus Silva on 03/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class ActionDetailController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var prayer: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var repetition: UILabel!
    @IBOutlet weak var notification: UILabel!
    var action: Action!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupEvents()
        // Do any additional setup after loading the view.
    }
    func setup() {
        loadData()
    }
    func setupEvents() {
        EventManager.shared.listenTo(eventName: "reloadAction") { action in
            guard let action = action as? Action else { return }
            self.action = action
            self.setup()
        }
    }
    func loadData() {
        let viewModel = ActionDetailViewModel(action: action)
        if let prayerID = action.prayID {
            viewModel.getPrayer(prayerID: prayerID)
        }
        image.image = viewModel.image
        name.text = viewModel.name
        prayer.text = viewModel.prayer
        date.text = viewModel.date
        hours.text = viewModel.hours
        repetition.text = viewModel.repetition
        notification.text = viewModel.notification
    }
    func generatorImpact() {
        ImpactFeedback.shared.generateMedium()
    }
    // MARK: - Actions
    @IBAction func finish(_ sender: Any? = nil) {
        generatorImpact()
        ActionHandler.done(uuid: action.uuid) { (response) in
            switch response {
            case .error(let description):
                NSLog(description)
            case .success(_:):
                DispatchQueue.main.async {
                    self.close()
                    EventManager.shared.trigger(eventName: "reloadAction")
                }
            }
        }
    }
    @IBAction func close(_ sender: Any? = nil) {
        generatorImpact()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func edit(_ sender: Any? = nil) {
        generatorImpact()
        performSegue(withIdentifier: "toActionEdit", sender: nil)
    }
    @IBAction func deletePrayer(_ sender: Any? = nil) {
        generatorImpact()
        UIAlert.show(controller: self, title: "Tem certeza que deseja apagar essa prática?",
                     message: "Não será mais possível recuperá-la",
                     alertAction1: "Apagar") { (response) in
            if response {
                self.generatorImpact()
                ActionHandler.delete(act: self.action) { (response) in
                    switch response {
                    case .error(let description):
                        print(description)
                    case .success(_:):
                        DispatchQueue.main.async {
                            self.close()
                            EventManager.shared.trigger(eventName: "reloadPrayer")
                            EventManager.shared.trigger(eventName: "reloadAction")
                        }
                    }
                }
            }
        }
    }
    // MARK: - NEXT
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let view = segue.destination as? ActionViewController {
            view.action = action
            view.isUpdate = true
        }
    }
}
