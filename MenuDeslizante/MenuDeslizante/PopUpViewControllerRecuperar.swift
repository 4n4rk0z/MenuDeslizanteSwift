//
//  PopUpViewControllerRecuperar.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 24/01/16.
//  Copyright © 2016 sergio ivan lopez monzon. All rights reserved.
//

import UIKit
import QuartzCore
import Parse

@objc public class PopUpViewControllerRecuperar : UIViewController {
    
    var mainViewController: UIView!
    @IBOutlet weak var popUpView: UIView!
    
    
    @IBOutlet weak var textfMail: UITextField!
    
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
        
        if (self.textfMail.text?.isEmpty == nil || self.textfMail.text?.isEmpty  == true ) {
            // User needs to verify email address before continuing
            let alertController = UIAlertController(title: "Error",
                message: "Ingrese su correo electronico",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default,
                handler: nil))
            // Display alert
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            PFUser.requestPasswordResetForEmailInBackground(textfMail.text!, block: { (sucess, error) -> Void in
                if error == nil{
                    // User needs to verify email address before continuing
                    let alertController = UIAlertController(title: "Reestablecer cuenta",
                        message: "Le hemos mandado un correo electronico",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertController.addAction(UIAlertAction(title: "OK",
                        style: UIAlertActionStyle.Default,
                        handler: { alertController in self.processSignOut()}))
                    // Display alert
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                else{
                    
                    var mensaje = ""
                    if (error?.code == 125){
                        mensaje = "Correo inválido"
                    }else{
                        mensaje = "Ha ocurrido un error, revise sus datos o su conexión a internet"
                    }
                    
                    // User needs to verify email address before continuing
                    let alertController = UIAlertController(title: "Reestablecer cuenta",
                        message: mensaje,
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertController.addAction(UIAlertAction(title: "OK",
                        style: UIAlertActionStyle.Default,
                        handler: { alertController in self.processSignOut()}))
                    // Display alert
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
            })
            
        }
        
    }
    
    
    @IBAction func btnCancelar(sender: AnyObject) {
        self.removeAnimate()
    }
    
    func processSignOut() {
                
        self.removeAnimate()
    }
    
}
