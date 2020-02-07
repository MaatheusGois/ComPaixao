//
//  TutorialPageController.swift
//  PropositoClient
//
//  Created by Matheus Silva on 06/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    weak var tutorialDelegate: TutorialPageViewControllerDelegate?
    lazy var VCArr: [UIViewController] = {
        return [self.VCInstance(name: "tutorial1"),
                self.VCInstance(name: "tutorial2"),
                self.VCInstance(name: "tutorial3")]
    }()
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup() {
        setupScreen()
        setupEvents()
    }
    func setupScreen() {
        self.delegate = self
        self.dataSource = self
        if let tutorial1 = VCArr.first {
            setViewControllers([tutorial1], direction: .forward, animated: true, completion: nil)
        }
        tutorialDelegate?.tutorialPageViewController(tutorialPageViewController: self,
                                                     didUpdatePageCount: VCArr.count)
    }
    func setupEvents() {
        EventManager.shared.listenTo(eventName: "nextPage") { (index) in
            guard let index = index as? Int else { return }
            self.setViewControllers([self.VCArr[index]],
                                    direction: .forward,
                                    animated: true,
                                    completion: nil)
        }
        EventManager.shared.listenTo(eventName: "previusPage") { (index) in
            guard let index = index as? Int else { return }
            self.setViewControllers([self.VCArr[index]],
                                    direction: .reverse,
                                    animated: true,
                                    completion: nil)
        }
    }
    private func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArr.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard VCArr.count > previousIndex else { return nil }
        return VCArr[previousIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArr.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = VCArr.count
        guard orderedViewControllersCount != nextIndex else { return nil }
        guard orderedViewControllersCount > nextIndex else { return nil }
        return VCArr[nextIndex]
    }

}

extension TutorialPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = VCArr.firstIndex(of: firstViewController) {
            tutorialDelegate?.tutorialPageViewController(tutorialPageViewController: self, didUpdatePageIndex: index)
        }
    }
}

protocol TutorialPageViewControllerDelegate: class {
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int)
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int)
}

extension TutorialViewController: TutorialPageViewControllerDelegate {
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    func tutorialPageViewController(tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
}
