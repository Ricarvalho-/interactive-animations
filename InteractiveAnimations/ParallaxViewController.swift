//
//  ParallaxViewController.swift
//  InteractiveAnimations
//
//  Created by Ricardo de Carvalho on 18/04/21.
//  Copyright © 2021 Ricardo de Carvalho. All rights reserved.
//

import UIKit

class ParallaxViewController: UIViewController {
    @IBOutlet weak var backgroundCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var midwayCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var midwayCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var foregroundCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var foregroundCenterYConstraint: NSLayoutConstraint!
    @IBOutlet var involvedConstraints: [NSLayoutConstraint]!
    
    // TODO: Try to combine with UIInterpolatingMotionEffect to parallax on device tilt too
    
    @IBAction func didPan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed: didUpdate(gesture)
        case .ended: didEndGesture()
        default: break
        }
    }
    
    private func didUpdate(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        backgroundCenterXConstraint.constant = translation.x * 0.2
        backgroundCenterYConstraint.constant = translation.y * 0.2
        midwayCenterXConstraint.constant = translation.x * 0.35
        midwayCenterYConstraint.constant = translation.y * 0.35
        foregroundCenterXConstraint.constant = translation.x * 0.5
        foregroundCenterYConstraint.constant = translation.y * 0.5
    }
    
    private func didEndGesture() {
        UIView.animate(
            withDuration: 0.75,
            delay: 0,
            usingSpringWithDamping: 0.65,
            initialSpringVelocity: 0.25,
            options: .curveEaseInOut,
            animations: { [weak self] in
                guard let self = self else { return }
                for constraint in self.involvedConstraints {
                    constraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
    }
}
