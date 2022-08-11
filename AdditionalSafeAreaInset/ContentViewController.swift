//
//  ContentViewController.swift
//  AdditionalSafeAreaInset
//
//  Created by Neil Jain on 8/11/22.
//

import UIKit

class ContentViewController: UIViewController {
    
    var index: Int
    
    private lazy var barContainer: UIView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.cornerCurve = .continuous
        view.layer.masksToBounds = true
        return view
    }()
    
    init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.samples[safe: index]
        configureViews()
    }
    
    private func configureViews() {
        self.view.addSubview(barContainer)
        barContainer.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        barContainer.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        barContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        barContainer.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
}

extension UIColor {
    static var samples: [UIColor] {
        [.systemRed, .systemOrange, .systemGreen, .systemYellow, .systemPink, .systemMint]
    }
}
