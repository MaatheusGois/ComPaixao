//
//  TutorialController.swift
//  PropositoClient
//
//  Created by Matheus Silva on 06/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class TutorialViewController1: UIViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class TutorialViewController2: UIViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class TutorialViewController3: UIViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class TutorialViewController: UIViewController {
    @IBOutlet weak var skip: UIButton!
    @IBOutlet weak var previus: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        setup()
    }
    func setup() {
        setupPrevius()
        setupSkip()
    }
    func setupPrevius() {
        if self.pageControl.currentPage == 0 {
            previus.fadeOut()
        } else {
            previus.fadeIn()
        }
    }
    func setupSkip() {
        if self.pageControl.currentPage == 2 {
            skip.fadeOut()
        } else {
            skip.fadeIn()
        }
    }
    // MARK: - Actions
    @IBAction func next(_ sender: Any) {
        self.pageControl.currentPage += 1
        EventManager.shared.trigger(eventName: "nextPage", information: self.pageControl.currentPage)
        setup()
    }
    @IBAction func previus(_ sender: Any) {
        self.pageControl.currentPage -= 1
        EventManager.shared.trigger(eventName: "previusPage", information: self.pageControl.currentPage)
        setup()
    }
    // MARK: - Next
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? TutorialPageViewController {
            tutorialPageViewController.tutorialDelegate = self
        }
    }
}
