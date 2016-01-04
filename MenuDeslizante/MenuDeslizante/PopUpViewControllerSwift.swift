//
//  PopUpViewControllerSwift.swift
//  NMPopUpView
//
//  Created by Nikos Maounis on 13/9/14.
//  Copyright (c) 2014 Nikos Maounis. All rights reserved.
//

import UIKit
import QuartzCore
import Parse

@objc public class PopUpViewControllerSwift : UIViewController {
   
    var popViewController : PopUpViewControllerDescripcion!
    var popViewControllerWallet : PopUpViewControllerWallet!
    var precio:Double!

    var mainViewController :UIView!
    var clientID:String!

    
    let MERCHANT_ID:String =  "mom7qomx3rv93zcwv2vk"
    let API_KEY:String = "pk_f492b71637e247e4b5a314a1f9366ec9"
    
    var sessionId:String = ""
    var openpayAPI:Openpay!
    var isSuscripcion:Bool = false
    var planId:String?
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var imageViewOpenPay: UIImageView!
    @IBOutlet weak var lConsultando: UILabel!
    @IBOutlet weak var loadingAction: UIActivityIndicatorView!
    
    
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
    

    public func showInView(aView: UIView!, animated: Bool, precioProducto:Double, suscripcion:Bool, planId: String?)
    {
        aView.addSubview(self.view)
        
        buscarClientes()
        mainViewController = aView
        self.showAnimate()
        self.precio=precioProducto
        self.isSuscripcion = suscripcion
        self.planId = planId
    }
    
    func buscarClientes(){
        //Consultamos si hay un cliente asociado con esta cuenta
        let query = PFQuery(className: "Clientes")
        query.whereKey("username", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {
            (clientes: [PFObject]?, error: NSError?) -> Void in
            // comments now contains the comments for myPost
            if error == nil {
                //Si hay un cliente recupera su clientID y sale del metodo
                if let _ = clientes as [PFObject]? {
                    for cliente in clientes! {
                       
                        let query = PFQuery(className:"Tarjetas")
                        query.whereKey("cliente", equalTo:cliente)
                        query.findObjectsInBackgroundWithBlock {
                            
                            (objects: [PFObject]?, error: NSError?) -> Void in
                            
                            if error == nil {
                                // The find succeeded.
                                print("Successfully retrieved \(objects!.count) scores.")
                                // Do something with the found objects
                                if let objects = objects {
                                    for object in objects {
                                        print(object.objectId)
                                        self.abrirWallet()
                                        break;
                                    }
                                }
                            } else {
                                // Log details of the failure
                                print("Error: \(error!) \(error!.userInfo)")
                            }
                           
                        }

                        // This does not require a network access.
                        self.clientID = (cliente["clientID"] as? String)!
                        break
                    }
                    self.seguir();
                }
                else{
                    
                    
                }

            }
            else
            {
                print(error)
            }
        }
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
    
    func seguir()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    let bundle = NSBundle(forClass: PopUpViewControllerDescripcion.self)
                    let strPantalla = self.pantallaSize()
                    self.popViewController = PopUpViewControllerDescripcion(nibName: "PopUpViewControllerDescripcion"+strPantalla, bundle: bundle)
                    
                    self.popViewController.showInView(self.mainViewController, suscripcion: self.isSuscripcion,planId:self.planId ,animated: true, precio:  self.precio)
                    self.view.removeFromSuperview()
                }
        });
    }

   
    func abrirWallet()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                    let bundle = NSBundle(forClass: PopUpViewControllerWallet.self)
                    let strPantalla = self.pantallaSize()
                    self.popViewControllerWallet = PopUpViewControllerWallet(nibName:"PopUpViewControllerWallet"+strPantalla, bundle: bundle)
                    self.popViewControllerWallet.showInView(self.mainViewController, suscripcion: self.isSuscripcion, planID:  self.planId,animated: true, precio: self.precio)
                    
                }
        });
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
}
