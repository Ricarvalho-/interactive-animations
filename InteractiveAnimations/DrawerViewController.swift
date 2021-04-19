//
//  DrawerViewController.swift
//  InteractiveAnimations
//
//  Created by Ricardo de Carvalho on 18/04/21.
//  Copyright © 2021 Ricardo de Carvalho. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {
    @IBOutlet weak var handlerView: UIView!
    @IBOutlet weak var topDrawerConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandDrawerConstraint: NSLayoutConstraint!
    @IBOutlet weak var collapseDrawerConstraint: NSLayoutConstraint!
    
    private var gestureLocationRelativeToHandler = CGFloat.zero
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if animated {
            collapseDrawerConstraint.priority = UILayoutPriority(rawValue: 999)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard animated else { return }
        
        animateWithDefaultSpring() { [weak self] in
            guard let self = self else { return }
            self.collapseDrawerConstraint.priority = UILayoutPriority(rawValue: 1)
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func didTapBackground(_ gesture: UITapGestureRecognizer) {
        collapseAndDismiss()
    }
    
    @IBAction func didPanFromHandler(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began: didBegin(gesture)
            fallthrough
        case .changed: didUpdate(gesture)
        case .ended: didEnd(gesture)
        default: break
        }
    }
    
    private func didBegin(_ gesture: UIPanGestureRecognizer) {
        self.expandDrawerConstraint.priority = UILayoutPriority(rawValue: 1)
        
        gestureLocationRelativeToHandler = gesture.location(in: handlerView).y
    }
    
    private func didUpdate(_ gesture: UIPanGestureRecognizer) {
        let locationRelativeToScreenCenter = gesture.location(in: view).y - view.frame.height / 2
        
        topDrawerConstraint.constant = locationRelativeToScreenCenter - gestureLocationRelativeToHandler
    }
    
    private func didEnd(_ gesture: UIPanGestureRecognizer) {
        let yLocation = gesture.location(in: view).y
        let expandThreshold = view.frame.height / 3
        let collapseThreshold = view.frame.height / 3 * 2
        
        if yLocation < expandThreshold {
            expand()
        } else if yLocation > collapseThreshold {
            collapseAndDismiss()
        } else {
            snapToCenter()
        }
    }
    
    private func snapToCenter() {
        animateWithDefaultSpring() { [weak self] in
            guard let self = self else { return }
            self.topDrawerConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func expand() {
        animateWithDefaultSpring() { [weak self] in
            guard let self = self else { return }
            self.expandDrawerConstraint.priority = UILayoutPriority(rawValue: 999)
            self.view.layoutIfNeeded()
        }
    }
    
    private func collapseAndDismiss() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.collapseDrawerConstraint.priority = UILayoutPriority(rawValue: 999)
            self.view.layoutIfNeeded()
        }) { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }
    
    private func animateWithDefaultSpring(_ animations: @escaping () -> Void) {
        UIView.animate(withDuration: 0.75,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut,
                       animations: animations)
    }
}

extension DrawerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
    }
}
