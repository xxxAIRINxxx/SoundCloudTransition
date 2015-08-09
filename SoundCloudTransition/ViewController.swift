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
    
    var animator : ARNTransitionAnimator?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAnimator(false)
    }
    
    @IBAction func tapButton(sender: UIButton) {
        self.setupAnimator(true)
    }

    func setupAnimator(isPreset: Bool) {
        var storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var modalVC = storyboard.instantiateViewControllerWithIdentifier("ModalViewController") as? ModalViewController
        modalVC!.modalPresentationStyle = .Custom
        
        self.animator = ARNTransitionAnimator(parentController: self, modalViewController: modalVC!)
        
        self.animator!.presentationBeforeHandler = { [weak self] (containerView: UIView) in
            containerView.addSubview(modalVC!.view)
            
            // Update Auto Layout
            modalVC!.view.layoutIfNeeded()
            
            let containerViewHeight = modalVC!.containerView!.frame.size.height
            modalVC!.containerView!.frame.origin.y = -containerViewHeight
            for subview in modalVC!.containerView!.subviews as! [UIView] {
                subview.alpha = 0.5
            }
            
            modalVC!.tabBar!.frame.origin.y = containerView.frame.size.height
            modalVC!.tabBar!.alpha = 0.0
            self!.button!.alpha = 1.0
            self!.imageView!.alpha = 1.0
            self!.imageView!.transform = CGAffineTransformIdentity
        }
        
        self.animator!.presentationAnimationHandler = { [weak self] (containerView: UIView, percentComplete: CGFloat) in
            let containerViewHeight = modalVC!.containerView!.frame.size.height
            modalVC!.containerView!.frame.origin.y = -containerViewHeight + containerViewHeight * percentComplete
            for subview in modalVC!.containerView!.subviews as! [UIView] {
                subview.alpha = 0.5 + 0.5 * percentComplete
            }
            
            modalVC!.tabBar!.frame.origin.y = containerView.frame.size.height - modalVC!.tabBar!.frame.size.height * percentComplete
            modalVC!.tabBar!.alpha = 1.0 * percentComplete
            modalVC!.containerView!.alpha = 1.0 * percentComplete
            self!.button.alpha = 1.0 - 1.5 * percentComplete
            self!.imageView.alpha = 1.0 - 0.2 * percentComplete
            self!.imageView.transform = CGAffineTransformIdentity
            self!.imageView.transform = CGAffineTransformScale(self!.imageView.transform, 1.0 - 0.1 * percentComplete, 1.0 - 0.1 * percentComplete)
        }
        
        self.animator!.presentationCompletionHandler = { [weak self] (containerView: UIView, didComplete: Bool) in
            if didComplete == false {
                self!.setupAnimator(false)
            }
        }
        
        self.animator!.dismissalAnimationHandler = { [weak self] (containerView: UIView, percentComplete: CGFloat) in
            containerView.bringSubviewToFront(modalVC!.view)
            
            let containerViewHeight = modalVC!.containerView!.frame.size.height
            modalVC!.containerView!.frame.origin.y = -containerViewHeight
            for subview in modalVC!.containerView!.subviews as! [UIView] {
                subview.alpha = 0.5
            }
            
            modalVC!.tabBar!.frame.origin.y = containerView.frame.size.height
            modalVC!.tabBar!.alpha = 0.0
            self!.button.alpha = 1.0
            self!.imageView.alpha = 1.0
            self!.imageView.transform = CGAffineTransformIdentity
            self!.setupAnimator(false)
        }
        
        modalVC!.transitioningDelegate = self.animator!
        
        if isPreset == true {
            self.presentViewController(modalVC!, animated: true, completion: nil)
        } else {
            self.animator!.needPresentationInteractive = true
        }
    }
}

