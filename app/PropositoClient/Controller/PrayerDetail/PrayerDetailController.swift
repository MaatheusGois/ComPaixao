//
//  PrayerDetailController.swift
//  PropositoClient
//
//  Created by Matheus Silva on 01/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class PrayerDetailController: UIViewController {
    var prayer: Prayer!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var repetition: UILabel!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    func setup() {
        loadData()
    }
    func loadData() {
        let prayerViewModel = PrayerDetailViewModel(prayer: prayer)
        name.text = prayerViewModel.name
        subject.text = prayerViewModel.subject
        date.text = prayerViewModel.date
        repetition.text = prayerViewModel.repetition
        notification.text = prayerViewModel.notification
        image.image = prayerViewModel.image
    }
    func generatorImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    // MARK: - Actions
    @IBAction func finish(_ sender: Any? = nil) {
        close()
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
