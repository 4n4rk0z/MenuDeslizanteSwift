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
import TwitterKit

class TuCuentaView: UIViewController, UITextFieldDelegate {
    
    var popViewController:PopUpViewControllerRegistro!
    var popViewControllerRecuperar:PopUpViewControllerRecuperar!
    
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
        if  (textfMail.text == nil || textfMail.text == "") || (textfPassword.text == nil || textfPassword.text == "") {
            // User needs to verify email address before continuing
            let alertController = UIAlertController(title: "Favor de ingresar correo y contraseña",
                message: "Ingrese sus datos para poder ingresar\nSi aun no estas registrado selecciona el boton de nuevo usuario",
                preferredStyle: UIAlertControllerStyle.Alert)
    
            alertController.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default,
                handler: nil))
            // Display alert
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
    
            self.logueoMail()
        }
}


func logueoMail(){
    
    let mail = textfMail.text?.lowercaseString
    let pass = textfPassword.text
    
    
    PFUser.logInWithUsernameInBackground(mail!, password:pass!) {
        (user: PFUser?, error: NSError?) -> Void in
        if user != nil {
            
            dispatch_async(dispatch_get_main_queue()) {
                // Do stuff after successful login.
                self.performSegueWithIdentifier("cerrarsesion", sender: nil)
                
            }
            
        } else {
            // The login failed. Check error to see why.
            
            let alertController = UIAlertController(title: "Error al iniciar sesión",
                message: "correo o usuario incorrectos",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default,
                handler: nil))
            // Display alert
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    
}



    func processSignOut() {
        
        // // Sign out
        PFUser.logOut()
        
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
/*//nativa
        
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName)");
                
                // Swift
                let store = Twitter.sharedInstance().sessionStore
                self.performSegueWithIdentifier("cerrarsesion", sender: nil)
                
            } else {
                print("error: \(error!.localizedDescription)");
            }
        }
  */
        
        
    }
    
    
    
    @IBAction func registrarse(sender: AnyObject) {
        self.abrirVentanaPopRegistro()
    }
    
    func abrirVentanaPopRegistro(){
        
        let bundle = NSBundle(forClass: PopUpViewControllerRegistro.self)
        self.popViewController = PopUpViewControllerRegistro(nibName: "PopUpViewControllerRegistro"+pantallaSize(), bundle: bundle)
        self.popViewController.showInView(self.view, animated: true)
        
    }
    
    func pantallaSize()->String!
    {
        var strPantalla = ""
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        {
            strPantalla = "_iPad"
        }
        else
        {
            
            if UIScreen.mainScreen().bounds.size.width > 320 {
                if UIScreen.mainScreen().scale == 3 {
                    strPantalla = "_iPhone6Plus"
                }
                else{
                    strPantalla = "_iPhone6"
                }
            }
        }
        return strPantalla
    }
    
    func abrirVentanaPopRecupera(){
        
        let bundle = NSBundle(forClass: PopUpViewControllerRecuperar.self)
        self.popViewControllerRecuperar = PopUpViewControllerRecuperar(nibName: "PopUpViewControllerRecuperar"+pantallaSize(), bundle: bundle)
        self.popViewControllerRecuperar.showInView(self.view, animated: true)
        
    }
    
    
    @IBAction func restablecer(sender: AnyObject) {
        self.abrirVentanaPopRecupera()
        
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

