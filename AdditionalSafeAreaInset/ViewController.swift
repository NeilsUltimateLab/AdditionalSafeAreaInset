//
//  ViewController.swift
//  AdditionalSafeAreaInset
//
//  Created by Neil Jain on 8/11/22.
//

import UIKit

class ViewController: UIPageViewController {
    
    private var contents: [ContentViewController] = {
        (0...5).map {
            ContentViewController(index: $0)
        }
    }()
    
    private var visualEffectView: UIVisualEffectView = {
        let visualEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: visualEffect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        self.delegate = self
        self.dataSource = self
        let firstVC = contents.first
        configureSafeAreaInset(for: firstVC)
        self.setViewControllers(firstVC.flatMap{[$0]}, direction: .forward, animated: false)
        
        self.view.addSubview(visualEffectView)
        visualEffectView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        visualEffectView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Incase PageViewController's first view controller is assigned after viewDidLoad.
        self.view.bringSubviewToFront(visualEffectView)
    }
    
    func configureSafeAreaInset(for viewController: UIViewController?) {
        // This patch is applied since we are setting the first view controller inside viewDidLoad in which we will not have fully resolved frame for either visualEffectView or safeAreaInsets for viewController's view.
        viewController?.additionalSafeAreaInsets.bottom = max(100, self.visualEffectView.frame.height) - max(34, self.view.safeAreaInsets.bottom)
    }
}

extension ViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingViewControllers.forEach({configureSafeAreaInset(for: $0)})
    }
}

extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? ContentViewController else { return nil }
        let previousVC = contents[safe: vc.index - 1]
        return previousVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? ContentViewController else { return nil }
        let nextVC = contents[safe: vc.index + 1]
        return nextVC
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        if self.indices.contains(index) {
            return self[index]
        }
        return nil
    }
}
