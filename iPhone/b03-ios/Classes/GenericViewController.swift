//
//  GenericViewController.swift
//  Mustage
//
//  Created by Oleg Baidalka on 07.04.2020.
//  Copyright © 2020 Bossly. All rights reserved.
//

import UIKit

enum KeyboardState {
    case willShow
    case didShow
    case willHide
    case didHide

    func name() -> Notification.Name {
        switch self {
        case .willShow:
            return NSNotification.Name.UIKeyboardWillShow
        case .didShow:
            return NSNotification.Name.UIKeyboardDidShow
        case .willHide:
            return NSNotification.Name.UIKeyboardWillHide
        case .didHide:
            return NSNotification.Name.UIKeyboardDidHide
        }
    }
}

class GenericViewController: UIViewController {

    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint! {
        didSet {
            bottomConstraintConstant = bottomConstraint.constant
        }
    }

    private var bottomConstraintConstant: CGFloat = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        register(forKeyboard: [.willHide, .willShow])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        unregisterKeyboard([.willShow, .willHide])
    }
    
    // MARK: - Keyboard
    
    private func register(forKeyboard states: [KeyboardState]) {
        let center = NotificationCenter.default

        states.forEach {
            let notification = $0.name()
            let method: (Notification) -> Void

            switch $0 {
            case .willShow:
                method = keyboardWillShow(_:)
            case .didShow:
                method = keyboardDidShow(_:)
            case .willHide:
                method = keyboardWillHide(_:)
            case .didHide:
                method = keyboardDidHide(_:)
            }

            _ = center.addObserver(forName: notification, object: nil, queue: nil, using: { notification in
                method(notification)
            })
        }
    }

    private func unregisterKeyboard(_ states: [KeyboardState] = [.willShow, .didShow, .willHide, .didHide]) {
        let center = NotificationCenter.default
        states.forEach {
            center.removeObserver(self, name: $0.name(), object: nil)
        }
    }

    func keyboardWillHide(_ notification: Notification) {
        adjustPosition(notification)
    }
    func keyboardDidHide(_ notification: Notification) {}
    func keyboardWillShow(_ notification: Notification) {
        adjustPosition(notification)
    }
    func keyboardDidShow(_ notification: Notification) {}

    private func adjustPosition(_ notification: Notification) {
        let userInfo = notification.userInfo
        let duration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
        let curve = userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UIView.AnimationOptions
        let keyboardFrame = userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect
        let keyboardHeight: CGFloat = keyboardFrame?.height ?? 0
        let keyboardMaxPosition = keyboardFrame?.minY ?? UIScreen.main.bounds.height
        let isKeyboardOpened = keyboardMaxPosition < UIScreen.main.bounds.height
        var constant = isKeyboardOpened ? keyboardHeight : 0

        constant = max(constant - view.safeAreaInsets.bottom, 0)
        bottomConstraint.constant = bottomConstraintConstant + constant

        UIView.animate(withDuration: duration, delay: 0, options: curve ?? .curveLinear, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
