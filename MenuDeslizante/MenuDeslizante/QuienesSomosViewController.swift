//
//  QuienesSomosViewController.swift
//  MenuDeslizante
//
//  Created by JUAN CARLOS LOPEZ A on 23/03/16.
//  Copyright © 2016 sergio ivan lopez monzon. All rights reserved.
//


import UIKit

class QuienesSomosViewController: UIViewController {
    

    @IBOutlet weak var menuButton:UIBarButtonItem!
     override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            
            revealViewController().rightViewRevealWidth = 150
            //    extraButton.target = revealViewController()
            //    extraButton.action = "rightRevealToggle:"
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
    }
    
}
