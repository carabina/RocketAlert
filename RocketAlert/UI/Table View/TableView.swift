//
//  RocketTableView.swift
//  RocketAlert
//
//  Created by Giuseppe Sapienza on 02/03/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import UIKit

class RocketTableView: UITableView, RocketSubView {
    
    required init(authorView: RocketAuthorView, in container: RocketContainerView) {
        self.container = container
        self.authorView = authorView
        super.init(frame: .zero, style: .plain)
        self.container.addSubview(self)
        
        self.setAutoresizingMask()
        self.setPositionConstraints()
        self.setSizeConstraints()
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = UITableViewAutomaticDimension
        
        self.separatorStyle = .none
        self.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardOpening), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHiding), name: .UIKeyboardWillHide, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var container: RocketContainerView!
    weak var authorView: UIView!
    
    var heightConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.heightConstraint.constant = self.contentSize.height
    }
    
    @objc func handleKeyboardOpening(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let tabBarHeight: CGFloat = RocketAlertView.hasTabBar ? 44 : 0
        self.bottomConstraint.constant = -(keyboardHeight - tabBarHeight)
        self.scrollToLastVisibleCell()
    }
    
    @objc func handleKeyboardHiding(_ sender: Notification) {
        self.bottomConstraint.constant = -10
    }
    
    private func scrollToLastVisibleCell() {
        DispatchQueue.main.async {
            let indexPath = self.indexPath(for: self.visibleCells.last!)
            self.scrollToRow(at: indexPath!, at: .middle, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        print("🔥 [Rocket] Deinit RocketTableView")
    }

}

extension RocketTableView: RocketAnimatable {
    func closeAnimation(completionHandler: (()->())? = nil) {
        let animator = UIViewPropertyAnimator.init(duration: 1, curve: .easeInOut) {
            self.prepareAnimation()
        }
        
        animator.addCompletion { (_) in
            completionHandler?()
        }
        
        animator.startAnimation()
    }
    
    func prepareAnimation() {
        self.alpha = 0
    }
    
    func openAnimation(completionHandler: (()->())? = nil) {
        let animator = UIViewPropertyAnimator.init(duration: 1, curve: .easeInOut) {
            self.alpha = 1
        }
        
        animator.addCompletion { (_) in
            completionHandler?()
        }
        
        animator.startAnimation()
    }
}


extension RocketTableView: RocketViewLayout {
    func setAutoresizingMask() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setPositionConstraints() {
        self.rightAnchor.constraint(equalTo: self.authorView.leftAnchor, constant: -6).isActive = true
        self.bottomConstraint = self.bottomAnchor.constraint(equalTo: self.authorView.bottomAnchor, constant: -10)
        self.bottomConstraint.isActive = true
    }

    func setSizeConstraints() {
        self.widthAnchor.constraint(equalTo: self.container.widthAnchor, multiplier: 0.6).isActive = true
        self.topAnchor.constraint(greaterThanOrEqualTo: self.container.topAnchor, constant: 20).isActive = true
        self.heightConstraint = self.heightAnchor.constraint(equalToConstant: 44)
        self.heightConstraint.priority = .defaultLow
        self.heightConstraint.isActive = true
    }
}
