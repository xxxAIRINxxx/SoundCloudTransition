//
//  SoundCloudTransitionAnimation.swift
//  SoundCloudTransition
//
//  Created by xxxAIRINxxx on 2016/09/19.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import Foundation
import UIKit
import ARNTransitionAnimator

final class SoundCloudTransitionAnimation : TransitionAnimatable {
    
    fileprivate weak var rootVC: ViewController!
    fileprivate weak var modalTab: UITabBarController!
    fileprivate weak var modalVC: ModalViewController!
    
    var completion: (() -> Void)?
    
    deinit {
        print("deinit SoundCloudTransitionAnimation")
    }
    
    init(_ rootVC: ViewController, _ modalTab: UITabBarController, _ modalVC: ModalViewController) {
        self.rootVC = rootVC
        self.modalTab = modalTab
        self.modalVC = modalVC
    }
    
    public func prepareContainer(_ transitionType: TransitionType, containerView: UIView, from fromVC: UIViewController, to toVC: UIViewController) {
        if transitionType.isPresenting {
            containerView.addSubview(toVC.view)
        }
        fromVC.view.setNeedsLayout()
        fromVC.view.layoutIfNeeded()
        toVC.view.setNeedsLayout()
        toVC.view.layoutIfNeeded()
    }
    
    func willAnimation(_ transitionType: TransitionType, containerView: UIView) {
        let tabBar = self.modalTab.tabBar
        
        if transitionType.isPresenting {
            let containerViewHeight = self.modalVC.containerView.frame.size.height
            self.modalVC.containerView.frame.origin.y = -containerViewHeight
            for subview in self.modalVC.containerView.subviews {
                subview.alpha = 0.5
            }
            
            tabBar.frame.origin.y = containerView.frame.size.height
            tabBar.alpha = 0.0
            self.rootVC.button.alpha = 1.0
            self.rootVC.imageView.alpha = 1.0
            self.rootVC.imageView.transform = CGAffineTransform.identity
        }
    }
    
    func updateAnimation(_ transitionType: TransitionType, percentComplete: CGFloat) {
        let tabBar = self.modalTab.tabBar
        
        if transitionType.isPresenting {
            let containerViewHeight = self.modalVC.containerView.frame.size.height
            
            self.modalVC.containerView.frame.origin.y = -containerViewHeight + containerViewHeight * percentComplete
            for subview in self.modalVC.containerView.subviews {
                subview.alpha = 0.5 + 0.5 * percentComplete
            }
            
            tabBar.frame.origin.y = self.modalVC.view.frame.size.height - tabBar.frame.size.height * percentComplete
            tabBar.alpha = 1.0 * percentComplete
            self.rootVC.button.alpha = 1.0 - 1.5 * percentComplete
            self.rootVC.imageView.alpha = 1.0 - 0.2 * percentComplete
            self.rootVC.imageView.transform = CGAffineTransform.identity
            self.rootVC.imageView.transform = self.rootVC.imageView.transform.scaledBy(x: 1.0 - 0.1 * percentComplete, y: 1.0 - 0.1 * percentComplete)
        } else {
            let containerViewHeight = self.modalVC.containerView.frame.size.height
            
            self.modalVC.containerView.frame.origin.y = -containerViewHeight
            for subview in self.modalVC.containerView.subviews {
                subview.alpha = 0.5
            }
            
            tabBar.frame.origin.y = self.modalVC.view.frame.size.height
            tabBar.alpha = 0.0
            self.rootVC.button.alpha = 1.0
            self.rootVC.imageView.alpha = 1.0
            self.rootVC.imageView.transform = CGAffineTransform.identity
        }
    }
    
    func finishAnimation(_ transitionType: TransitionType, didComplete: Bool) {
        if didComplete && !transitionType.isPresenting {
            self.completion?()
        }
    }
}

extension SoundCloudTransitionAnimation {
    
    func sourceVC() -> UIViewController { return self.rootVC }
    
    func destVC() -> UIViewController { return self.modalTab }
}
