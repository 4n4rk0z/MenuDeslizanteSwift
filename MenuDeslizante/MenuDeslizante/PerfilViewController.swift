//
//  PerfilViewController.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 21/11/15.
//  Copyright © 2015 sergio ivan lopez monzon. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseTwitterUtils
import ParseFacebookUtilsV4
import TwitterKit

class PerfilViewController: UIViewController {

    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var lNombreUsuario: UILabel!
    @IBOutlet weak var lCorreoElectronico: UILabel!
    
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
            
            /*let user = PFUser.currentUser()
            
            if user == nil{
                self.performSegueWithIdentifier("login", sender: nil)
            }
            */
            
            if PFUser.currentUser() != nil {
                let inicioSesion = PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()!)
                if inicioSesion{
                    getFBUserData()
                }
                else{
                    getParseUserData()
                }
            }
            else {
                
                let sesion = Twitter.sharedInstance().session()
                if sesion != nil{
                  
                    if sesion != nil{
                        getTWUserData(sesion!)
                    }
                }
                else{
                    self.performSegueWithIdentifier("login", sender: nil)
                }
            }
            
        }
        
        
        
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! NSDictionary
                    print(result)
                    print(dict)
                    self.lNombreUsuario.text = dict.objectForKey("name") as? String
                    self.lCorreoElectronico.text = dict.objectForKey("email") as? String
                    self.loadFBProfileImage(dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String)
                }
            })
        }
    }
    
    func loadFBProfileImage(url:String){
            
            let imgURL: NSURL = NSURL(string: url)!
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request){
                (data, response, error) -> Void in
                
                if (error == nil && data != nil)
                {
                    func display_image()
                    {
                        self.imageViewProfile.image = UIImage(data: data!)
                       

                        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                            
                            self.imageViewProfile.alpha = 100
                            self.lNombreUsuario.alpha = 100
                            self.lCorreoElectronico.alpha = 100
                            
                            }, completion: nil)
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), display_image)
                }
                
            }
            
            task.resume()
    }
    
    func getTWUserData(sesion:TWTRSession){
       
        Twitter.sharedInstance().APIClient.loadUserWithID( sesion.userID )
            {
                (user, error) -> Void in
                
                if( user != nil )
                {
                    
                    print( user!.profileImageURL )
                    self.lNombreUsuario.text = user?.name
                    self.lCorreoElectronico.text = "@" + sesion.userName
                    self.loadTwProfileImage(user!.profileImageURL)
                }
        }

    }
    
    func loadTwProfileImage(url:String){
        
        let imgURL: NSURL = NSURL(string: url)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    self.imageViewProfile.image = UIImage(data: data!)
                    
                    
                    UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        
                        self.imageViewProfile.alpha = 100
                        self.lNombreUsuario.alpha = 100
                        self.lCorreoElectronico.alpha = 100
                        
                        }, completion: nil)
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
        
        
    }
    
    func getParseUserData(){
        
        //self.lNombreUsuario.text = PFUser.currentUser()?.username
        self.lCorreoElectronico.text = PFUser.currentUser()?.email
        self.imageViewProfile.image = UIImage(named: ("photo"))
        
        
        func display_image()
        {
            
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                
                self.imageViewProfile.alpha = 100
               // self.lNombreUsuario.alpha = 100
                self.lCorreoElectronico.alpha = 100
                
                }, completion: nil)
            
        }
        
        dispatch_async(dispatch_get_main_queue(), display_image)
        
        
    }
    
    
    
    @IBAction func cerrarSesion(sender: AnyObject) {
        
        let sesion = Twitter.sharedInstance().session()
        
        if sesion == nil{
            
            PFUser.logOutInBackgroundWithBlock { (error:NSError?) -> Void in
                //self.presentViewController(vc, animated: true, completion: nil)
            self.performSegueWithIdentifier("login", sender: nil)
            }
            
        }
        
        else{
            let sessionStore = Twitter.sharedInstance().sessionStore
            sessionStore.logOutUserID(sesion!.userID)
            self.performSegueWithIdentifier("login", sender: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
