//
//  ViewController.swift
//  SoundCloudTransition
//
//  Created by xxxAIRINxxx on 2015/02/25.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit
import ARNTransitionAnimator

final class ViewController: UIViewController {
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var button : UIButton!
    
    private var animator : ARNTransitionAnimator!
    private var modalVC : ModalViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.modalVC = storyboard.instantiateViewControllerWithIdentifier("ModalViewController") as? ModalViewController
        self.modalVC.modalPresentationStyle = .FullScreen
        
        self.setupAnimator()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewController viewWillAppear")
        
        self.animator.interactiveType = .Present
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("ViewController viewWillDisappear")
    }
    
    @IBAction func tapButton(sender: UIButton) {
        self.animator.interactiveType = .None
        self.presentViewController(self.modalVC, animated: true, completion: nil)
    }

    func setupAnimator() {
        self.animator = ARNTransitionAnimator(operationType: .Present, fromVC: self, toVC: self.modalVC)
        
        // Present
        
        self.animator.presentationBeforeHandler = { [unowned self] containerView, transitionContext in
            containerView.addSubview(self.modalVC.view)
            
            self.modalVC.view.layoutIfNeeded()
            
            let containerViewHeight = self.modalVC.containerView.frame.size.height
            self.modalVC.containerView.frame.origin.y = -containerViewHeight
            for subview in self.modalVC.containerView.subviews {
                subview.alpha = 0.5
            }
            
            self.modalVC.tabBar.frame.origin.y = containerView.frame.size.height
            self.modalVC.tabBar!.alpha = 0.0
            self.button!.alpha = 1.0
            self.imageView!.alpha = 1.0
            self.imageView!.transform = CGAffineTransformIdentity
        }
        
        self.animator.presentationCancelAnimationHandler = { [unowned self] containerView in
            let containerViewHeight = self.modalVC.containerView.frame.size.height
            self.modalVC.containerView.frame.origin.y = -containerViewHeight
            for subview in self.modalVC.containerView.subviews {
                subview.alpha = 0.5
            }
            
            self.modalVC.tabBar.frame.origin.y = containerView.frame.size.height
            self.modalVC.tabBar!.alpha = 0.0
            self.button!.alpha = 1.0
            self.imageView!.alpha = 1.0
            self.imageView!.transform = CGAffineTransformIdentity
        }
        
        self.animator.presentationAnimationHandler = { [unowned self] containerView, percentComplete in
            let containerViewHeight = self.modalVC.containerView.frame.size.height
            
            self.modalVC.containerView.frame.origin.y = -containerViewHeight + containerViewHeight * percentComplete
            for subview in self.modalVC.containerView.subviews {
                subview.alpha = 0.5 + 0.5 * percentComplete
            }
            
            self.modalVC.tabBar.frame.origin.y = containerView.frame.size.height - self.modalVC.tabBar.frame.size.height * percentComplete
            self.modalVC.tabBar.alpha = 1.0 * percentComplete
            self.button.alpha = 1.0 - 1.5 * percentComplete
            self.imageView.alpha = 1.0 - 0.2 * percentComplete
            self.imageView.transform = CGAffineTransformIdentity
            self.imageView.transform = CGAffineTransformScale(self.imageView.transform, 1.0 - 0.1 * percentComplete, 1.0 - 0.1 * percentComplete)
        }
        
        // Dismiss
        
        self.animator.dismissalAnimationHandler = { [unowned self] containerView, percentComplete in
            let containerViewHeight = self.modalVC.containerView.frame.size.height
            
            containerView.addSubview(self.view)
            
            self.view.layoutIfNeeded()
            
            self.modalVC.containerView.frame.origin.y = -containerViewHeight
            for subview in self.modalVC.containerView.subviews {
                subview.alpha = 0.5
            }
            
            self.modalVC.tabBar.frame.origin.y = containerView.frame.size.height
            self.modalVC.tabBar.alpha = 0.0
            self.button.alpha = 1.0
            self.imageView.alpha = 1.0
            self.imageView.transform = CGAffineTransformIdentity
        }
        
        self.animator.dismissalCompletionHandler = { [unowned self] containerView, completeTransition in
            self.animator.interactiveType = .Present
        }
        
        self.modalVC.transitioningDelegate = self.animator
    }
}