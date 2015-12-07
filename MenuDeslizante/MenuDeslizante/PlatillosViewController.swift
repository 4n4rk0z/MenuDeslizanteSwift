//
//  PlatillosViewController.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 06/12/15.
//  Copyright © 2015 sergio ivan lopez monzon. All rights reserved.
//


import UIKit

class PlatillosViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bCompartir(sender: AnyObject) {
        self.performSegueWithIdentifier("viralizarUno", sender: nil)
        
    }
    
    @IBAction func bLike(sender: AnyObject) {
    }
    
    
    
}
