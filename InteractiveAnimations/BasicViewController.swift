//
//  BasicViewController.swift
//  InteractiveAnimations
//
//  Created by Ricardo de Carvalho on 18/04/21.
//  Copyright © 2021 Ricardo de Carvalho. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController {
    @IBOutlet weak var handlerView: UIView!
    @IBOutlet weak var outcomeView: UIView!
    @IBOutlet weak var handlerCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var handlerCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var outcomeCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var outcomeCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var outcomeHeightConstraint: NSLayoutConstraint!
    @IBOutlet var involvedConstraints: [NSLayoutConstraint]!
    
    @IBAction func didPanFromHandler(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began: didBeginGesture()
        case .changed: didUpdate(gesture)
        case .ended: didEndGesture()
        default: break
        }
    }
    
    private func didBeginGesture() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.outcomeView.backgroundColor = .systemGreen
            self.view.layoutIfNeeded()
        }
    }
    
    private func didUpdate(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        handlerCenterXConstraint.constant = translation.x
        handlerCenterYConstraint.constant = translation.y
        outcomeCenterXConstraint.constant = translation.x * 2
        outcomeCenterYConstraint.constant = -translation.y / 1.5
        
        let mean = (translation.x + translation.y) / 2
        outcomeHeightConstraint.constant = mean
    }
    
    private func didEndGesture() {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: .curveEaseInOut,
            animations: { [weak self] in
                guard let self = self else { return }
                for constraint in self.involvedConstraints {
                    constraint.constant = 0
                }
                self.outcomeView.backgroundColor = .systemOrange
                self.view.layoutIfNeeded()
            })
    }
}
