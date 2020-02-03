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
    @IBOutlet weak var repetition: UILabel!
    @IBOutlet weak var notification: UILabel!
    var action: Action!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    func setup() {
        loadData()
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
        repetition.text = viewModel.repetition
        notification.text = viewModel.notification
    }
    func generatorImpact() {
        ImpactFeedback.shared.generateMedium()
    }
    // MARK: - Actions
    @IBAction func finish(_ sender: Any? = nil) {
        action.completed = true //Make action done
        ActionHandler.update(act: action) { (response) in
            switch response {
            case .error(let description):
                NSLog(description)
            case .success( _):
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
    }
    @IBAction func deletePrayer(_ sender: Any? = nil) {
        close()
    }
}
