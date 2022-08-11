//
//  ViewController.swift
//  AdditionalSafeAreaInset
//
//  Created by Neil Jain on 8/11/22.
//

import UIKit

class ViewController: UIPageViewController {
    
    var shouldAttachVisualEffectView: Bool = true
    
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
        
        if shouldAttachVisualEffectView {
            NSLayoutConstraint.activate([
                visualEffectView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                visualEffectView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                visualEffectView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                visualEffectView.heightAnchor.constraint(equalToConstant: 100)
            ])
        } else {
            NSLayoutConstraint.activate([
                visualEffectView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                visualEffectView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                visualEffectView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                visualEffectView.heightAnchor.constraint(equalToConstant: 54)
            ])
            
            visualEffectView.layer.cornerRadius = 12
            visualEffectView.layer.cornerCurve = .continuous
            visualEffectView.layer.masksToBounds = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Incase PageViewController's first view controller is assigned after viewDidLoad.
        self.view.bringSubviewToFront(visualEffectView)
        self.viewControllers?.forEach({configureSafeAreaInset(for: $0)})
    }
    
    func configureSafeAreaInset(for viewController: UIViewController?) {
        var safeAreaInsetBotton = self.view.safeAreaInsets.bottom
        if self.view.traitCollection.horizontalSizeClass == .regular {
            safeAreaInsetBotton = 0
        }
        if shouldAttachVisualEffectView {
            viewController?.additionalSafeAreaInsets.bottom = self.visualEffectView.frame.height - safeAreaInsetBotton
        } else {
            viewController?.additionalSafeAreaInsets.bottom = self.view.frame.height - self.visualEffectView.frame.origin.y - safeAreaInsetBotton
        }
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
