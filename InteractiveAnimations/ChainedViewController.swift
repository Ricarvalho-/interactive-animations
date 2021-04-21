//
//  ChainedViewController.swift
//  InteractiveAnimations
//
//  Created by Ricardo de Carvalho on 21/04/21.
//  Copyright © 2021 Ricardo de Carvalho. All rights reserved.
//

import UIKit

class ChainedViewController: UIViewController {
    @IBOutlet weak var chipImageView: UIImageView!
    @IBOutlet weak var chipCollapseConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollContentPadding: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollContentPadding.constant = view.frame.height / 2
    }
    
    @IBAction func onChipClicked() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.toggleChipCollapsed()
            self?.view.layoutIfNeeded()
        }
    }
    
    private func toggleChipCollapsed() {
        let isCollapsed = chipCollapseConstraint.isActive
        chipCollapseConstraint.isActive = !isCollapsed
        chipImageView.image = UIImage(
            systemName: "flag.circle\(isCollapsed ? "" : ".fill")"
        )
    }
}
