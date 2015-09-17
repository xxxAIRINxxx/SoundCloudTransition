//
//  ViewController.swift
//  SoundCloudTransition
//
//  Created by xxxAIRINxxx on 2015/02/25.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var button : UIButton!
    
    var animator : ARNTransitionAnimator!
    var modalVC : ModalViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        self.modalVC = storyboard.instantiateViewControllerWithIdentifier("ModalViewController") as? ModalViewController
        self.modalVC.modalPresentationStyle = .Custom
        
        self.setupAnimator()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.animator.interactiveType = .Present
    }
    
    @IBAction func tapButton(sender: UIButton) {
        self.animator.interactiveType = .None
        self.presentViewController(self.modalVC, animated: true, completion: nil)
    }

    func setupAnimator() {
        self.animator = ARNTransitionAnimator(operationType: .Present, fromVC: self, toVC: modalVC!)
        
        // Present
        
        self.animator.presentationBeforeHandler = { [weak self] (containerView: UIView, transitionContext: UIViewControllerContextTransitioning) in
            
            containerView.addSubview(self!.modalVC.view)
            
            self!.modalVC.view.layoutIfNeeded()
            
            let containerViewHeight = self!.modalVC.containerView.frame.size.height
            self!.modalVC.containerView.frame.origin.y = -containerViewHeight
            for subview in self!.modalVC.containerView.subviews {
                subview.alpha = 0.5
            }
            
            self!.modalVC.tabBar.frame.origin.y = containerView.frame.size.height
            self!.modalVC.tabBar!.alpha = 0.0
            self!.button!.alpha = 1.0
            self!.imageView!.alpha = 1.0
            self!.imageView!.transform = CGAffineTransformIdentity
        }
        
        self.animator.presentationCancelAnimationHandler = { [weak self] (containerView: UIView) in
            let containerViewHeight = self!.modalVC.containerView.frame.size.height
            self!.modalVC.containerView.frame.origin.y = -containerViewHeight
            for subview in self!.modalVC.containerView.subviews {
                subview.alpha = 0.5
            }
            
            self!.modalVC.tabBar.frame.origin.y = containerView.frame.size.height
            self!.modalVC.tabBar!.alpha = 0.0
            self!.button!.alpha = 1.0
            self!.imageView!.alpha = 1.0
            self!.imageView!.transform = CGAffineTransformIdentity
        }
        
        self.animator.presentationAnimationHandler = { [weak self] (containerView: UIView, percentComplete: CGFloat) in
            let containerViewHeight = self!.modalVC.containerView.frame.size.height
            self!.modalVC.containerView.frame.origin.y = -containerViewHeight + containerViewHeight * percentComplete
            for subview in self!.modalVC.containerView.subviews {
                subview.alpha = 0.5 + 0.5 * percentComplete
            }
            
            self!.modalVC.tabBar.frame.origin.y = containerView.frame.size.height - self!.modalVC.tabBar.frame.size.height * percentComplete
            self!.modalVC.tabBar.alpha = 1.0 * percentComplete
            self!.button.alpha = 1.0 - 1.5 * percentComplete
            self!.imageView.alpha = 1.0 - 0.2 * percentComplete
            self!.imageView.transform = CGAffineTransformIdentity
            self!.imageView.transform = CGAffineTransformScale(self!.imageView.transform, 1.0 - 0.1 * percentComplete, 1.0 - 0.1 * percentComplete)
        }
        
        // Dismiss
        
        self.animator.dismissalAnimationHandler = { [weak self] (containerView: UIView, percentComplete: CGFloat) in
            let containerViewHeight = self!.modalVC.containerView.frame.size.height
            self!.modalVC.containerView.frame.origin.y = -containerViewHeight
            for subview in self!.modalVC.containerView.subviews {
                subview.alpha = 0.5
            }
            
            self!.modalVC.tabBar.frame.origin.y = containerView.frame.size.height
            self!.modalVC.tabBar.alpha = 0.0
            self!.button.alpha = 1.0
            self!.imageView.alpha = 1.0
            self!.imageView.transform = CGAffineTransformIdentity
        }
        
        self.animator.dismissalCompletionHandler = { [weak self] (containerView: UIView, completeTransition: Bool) in
            self!.animator.interactiveType = .Present
        }
        
        self.modalVC.transitioningDelegate = self.animator
    }
}