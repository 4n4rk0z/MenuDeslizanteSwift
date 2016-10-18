//
//  gratisViewController.swift
//  MenuDeslizante
//
//  Created by Billy Jack Bates Garcia on 10/18/16.
//  Copyright © 2016 sergio ivan lopez monzon. All rights reserved.
//

import UIKit

class gratisViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "fondo_pago")!.drawInRect(self.view.bounds)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continuarPago(sender: AnyObject) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("pagoVC") as! UINavigationController
        
        self.presentViewController(vc, animated: true, completion: nil)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "popPago")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    @IBAction func cancelar(sender: AnyObject) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
