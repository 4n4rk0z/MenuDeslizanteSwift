//
//  PerfilViewController.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 21/11/15.
//  Copyright © 2015 sergio ivan lopez monzon. All rights reserved.
//

import UIKit
import Parse

class PerfilViewController: UIViewController {

    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            
            revealViewController().rightViewRevealWidth = 150
            //    extraButton.target = revealViewController()
            //    extraButton.action = "rightRevealToggle:"
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        let user = PFUser.currentUser()
        
        if user == nil{
            self.performSegueWithIdentifier("login", sender: nil)
        }
        
        
    }
    
    @IBAction func cerrarSesion(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error:NSError?) -> Void in
            //self.presentViewController(vc, animated: true, completion: nil)
             self.performSegueWithIdentifier("login", sender: nil)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
