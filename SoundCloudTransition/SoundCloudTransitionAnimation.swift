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
    fileprivate weak var modalVC: ModalViewController!
    
    var completion: (() -> Void)?
    
    deinit {
        print("deinit SoundCloudTransitionAnimation")
    }
    
    init(rootVC: ViewController, modalVC: ModalViewController) {
        self.rootVC = rootVC
        self.modalVC = modalVC
    }
    
    func willAnimation(_ transitionType: TransitionType, containerView: UIView) {
        if transitionType.isPresenting {
            let containerViewHeight = self.modalVC.containerView.frame.size.height
            self.modalVC.containerView.frame.origin.y = -containerViewHeight
            for subview in self.modalVC.containerView.subviews {
                subview.alpha = 0.5
            }
            
            self.modalVC.tabBar.frame.origin.y = containerView.frame.size.height
            self.modalVC.tabBar.alpha = 0.0
            self.rootVC.button.alpha = 1.0
            self.rootVC.imageView.alpha = 1.0
            self.rootVC.imageView.transform = CGAffineTransform.identity
        } else {
            
        }
    }
    
    func updateAnimation(_ transitionType: TransitionType, percentComplete: CGFloat) {
        if transitionType.isPresenting {
            let containerViewHeight = self.modalVC.containerView.frame.size.height
            
            self.modalVC.containerView.frame.origin.y = -containerViewHeight + containerViewHeight * percentComplete
            for subview in self.modalVC.containerView.subviews {
                subview.alpha = 0.5 + 0.5 * percentComplete
            }
            
            self.modalVC.tabBar.frame.origin.y = self.modalVC.view.frame.size.height - self.modalVC.tabBar.frame.size.height * percentComplete
            self.modalVC.tabBar.alpha = 1.0 * percentComplete
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
            
            self.modalVC.tabBar.frame.origin.y = self.modalVC.view.frame.size.height
            self.modalVC.tabBar.alpha = 0.0
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
    
    func destVC() -> UIViewController { return self.modalVC }
}
