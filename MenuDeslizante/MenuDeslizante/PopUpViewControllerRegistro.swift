//
//  PopUpViewControllerRegistro.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 24/01/16.
//  Copyright © 2016 sergio ivan lopez monzon. All rights reserved.
//

import UIKit
import QuartzCore
import Parse
import ParseFacebookUtilsV4

@objc public class PopUpViewControllerRegistro : UIViewController {

    var mainViewController: UIView!
    @IBOutlet weak var popUpView: UIView!
    
    
    @IBOutlet weak var textfMail: UITextField!
    @IBOutlet weak var textfPassword: UITextField!
    @IBOutlet weak var textfPasswordConfirmation: UITextField!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override public init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
    }
    
    
    public func showInView(aView: UIView!, animated: Bool){
        
        mainViewController = aView
        aView.addSubview(self.view)
        self.showAnimate()
    }
    
       
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    
    @IBAction func btnEnviar(sender: AnyObject) {
        let user = PFUser()
        
        if self.textfMail.text?.isEmpty == true || self.textfPassword.text?.isEmpty == true || self.textfPasswordConfirmation.text?.isEmpty == true{
            // User needs to verify email address before continuing
            let alertController = UIAlertController(title: "Error",
                message: "Debe llenar los campos vacios",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default,
                handler: nil))
            // Display alert
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        if (self.textfPasswordConfirmation.text == textfPassword.text && (self.textfPassword.text?.isEmpty != nil)){
            
        user.password = textfPassword.text
        user.email = textfMail.text?.lowercaseString
        user.username = textfMail.text?.lowercaseString
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                
                if (error.code == 125){
                    // User needs to verify email address before continuing
                    let alertController = UIAlertController(title: "Error",
                        message: "Correo electronico inválido",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertController.addAction(UIAlertAction(title: "OK",
                        style: UIAlertActionStyle.Default,
                        handler: nil))
                    // Display alert
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                print(errorString)
                // Show the errorString somewhere and let the user try again.
            } else {
                
                
                // User needs to verify email address before continuing
                let alertController = UIAlertController(title: "Bienvenido",
                    message: "usuario registrado",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                    alertController.addAction(UIAlertAction(title: "OK",
                    style: UIAlertActionStyle.Default,
                    handler: { alertController in self.processSignOut()}))
                    // Display alert
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
        
            }

        }
        else{
            
            // User needs to verify email address before continuing
            let alertController = UIAlertController(title: "Error",
                message: "Contraseñas no coinciden",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default,
                handler: nil))
            // Display alert
            self.presentViewController(alertController, animated: true, completion: nil)
            

        }

    }
    
    func ligarFb(user: PFUser)
    {
        if !PFFacebookUtils.isLinkedWithUser(user) {
            PFFacebookUtils.linkUserInBackground(user, withReadPermissions: nil, block: {
                (succeeded: Bool?, error: NSError?) -> Void in
                if (succeeded != nil) {
                    print("Woohoo, the user is linked with Facebook!")
                }
            })
        }
    }
    
    @IBAction func loginFacebook(sender: AnyObject) {
        
        //let publishPermissions : [String]? = ["publish_actions"]
        let readPermissions : [String]? = ["email", "user_likes", "user_photos", "user_posts", "user_friends"]
        
        // Log In with Read Permissions
        PFFacebookUtils.logInInBackgroundWithReadPermissions(readPermissions, block: { (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
                
                self.ligarFb(user)
                self.performSegueWithIdentifier("Home", sender: nil)
                
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        })
        
    }
    
    
    @IBAction func btnCancelar(sender: AnyObject) {
        self.removeAnimate()
    }
    
    func processSignOut() {
        
        // // Sign out
        PFUser.logOut()
        
        self.removeAnimate()
    }
  
}
