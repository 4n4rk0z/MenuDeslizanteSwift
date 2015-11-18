//
//  NewsTableViewController.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 17/11/15.
//  Copyright © 2015 sergio ivan lopez monzon. All rights reserved.
//

import UIKit

class NewsTableViewController: UIViewController {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

