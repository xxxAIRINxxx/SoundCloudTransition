//
//  ModalViewController.swift
//  SoundCloudTransition
//
//  Created by xxxAIRINxxx on 2015/02/25.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {
    
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var tabBar : UITabBar!
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
