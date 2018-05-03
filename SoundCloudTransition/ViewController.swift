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
    
    private var animator : ARNTransitionAnimator?
    private var modalVC : ModalViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAnimator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewController viewWillAppear")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ViewController viewWillDisappear")
    }
    
    @IBAction func tapButton() {
        self.present(self.modalVC, animated: true, completion: nil)
    }

    func setupAnimator() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.modalVC = storyboard.instantiateViewController(withIdentifier: "ModalViewController") as? ModalViewController
        self.modalVC.modalPresentationStyle = .fullScreen
        
        let animation = SoundCloudTransitionAnimation(rootVC: self, modalVC: self.modalVC)
        animation.completion = { [weak self] in
            self?.setupAnimator()
        }
        
        self.animator = ARNTransitionAnimator(duration: 0.4, animation: animation)
        let gestureHandler = TransitionGestureHandler(targetVC: self, direction: .bottom)
        self.animator?.registerInteractiveTransitioning(.present, gestureHandler: gestureHandler)
        
        self.modalVC.transitioningDelegate = self.animator
    }
}
