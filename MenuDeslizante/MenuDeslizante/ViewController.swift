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

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textfMail: UITextField!
    @IBOutlet weak var textfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = PFUser.currentUser()

        if user != nil{
            self.performSegueWithIdentifier("Home", sender: nil)  
        }
        else
        {
            // Do any additional setup after loading the view, typically from a nib.
            textfMail.delegate = self
            textfPassword.delegate = self
        }
    }

    @IBAction func loginMail(sender: AnyObject) {
        
        
    }
    
    @IBAction func registrarse(sender: AnyObject) {
        
        
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
                
                self.performSegueWithIdentifier("Home", sender: nil)
                
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        })
       
/*// Request new Publish Permissions
PFFacebookUtils.linkUserInBackground(user, withPublishPermissions: ["publish_actions"], {
(succeeded: Bool?, error: NSError?) -> Void in
if succeeded {
print("User now has read and publish permissions!")
}
})*/

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
                
                self.performSegueWithIdentifier("Home", sender: nil)
                
            } else {
                print("Uh oh. The user cancelled the Twitter login.")
            }
        }

    }
    
    @IBAction func saltarLogin(sender: AnyObject) {
        self.performSegueWithIdentifier("Home", sender: nil)
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

