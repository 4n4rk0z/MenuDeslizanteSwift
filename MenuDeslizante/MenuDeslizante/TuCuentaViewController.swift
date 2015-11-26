//
//  TuCuentaView.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 21/11/15.
//  Copyright © 2015 sergio ivan lopez monzon. All rights reserved.
//

//
//  ViewController.swift
//  App Cocina
//
//  Created by Emmanuel Valentín Granados López on 26/09/15.
//  Copyright © 2015 DevWorms. All rights reserved.
//

import UIKit
import Parse
import ParseTwitterUtils
import ParseFacebookUtilsV4

class TuCuentaView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textfMail: UITextField!
    @IBOutlet weak var textfPassword: UITextField!
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // Do any additional setup after loading the view, typically from a nib.
            textfMail.delegate = self
            textfPassword.delegate = self
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
    
    @IBAction func loginMail(sender: AnyObject) {
        
        let mail = textfMail.text
        let pass = textfPassword.text
        PFUser.logInWithUsernameInBackground(mail!, password:pass!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                self.performSegueWithIdentifier("cerrarsesion", sender: nil)
            } else {
                // The login failed. Check error to see why.
            }
        }
    }
    @IBAction func restablecer(sender: AnyObject) {
        PFUser.requestPasswordResetForEmailInBackground(textfMail.text!)
    }
    
    @IBAction func registrarse(sender: AnyObject) {
        let user = PFUser()
        
        user.password = textfPassword.text
        user.email = textfMail.text
        user.username = textfMail.text
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                print(errorString)
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
                self.performSegueWithIdentifier("cerrarsesion", sender: nil)
            }
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
                
                self.performSegueWithIdentifier("cerrarsesion", sender: nil)
                
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        })
        
              
    }
    
    @IBAction func loginTwitter(sender: AnyObject) {
        
        PFTwitterUtils.logInWithBlock {
            (user: PFUser?, error: NSError?) -> Void in
            
            let user = user
            
            if (user != nil) {
                if user!.isNew {
                    print("User signed up and logged in with Twitter!")
                } else {
                    print("User logged in with Twitter! " )
                }
                
                self.performSegueWithIdentifier("cerrarsesion", sender: nil)
                
            } else {
                print("Uh oh. The user cancelled the Twitter login.")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate    <- mark + : do section
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //make something with the letters that being typed
    }
    
    
    
}

