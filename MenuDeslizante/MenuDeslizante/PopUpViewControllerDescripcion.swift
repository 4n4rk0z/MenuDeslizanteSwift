//
//  PopUpViewControllerDescripcion.swift
//  Pods
//
//  Created by sergio ivan lopez monzon on 01/01/16.
//
//

import UIKit
import QuartzCore

@objc public class PopUpViewControllerDescripcion : UIViewController {
    
    var popViewController : PopUpViewControllerFormasPago!
    var tipoSuscripcion :Bool = false
    var planId:String?
    var precioProducto :Double!
    var mainViewController :UIView!
    
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var txtPrecio: UILabel!
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
    
    
    public func showInView(aView: UIView!, suscripcion:Bool,planId:String?,  animated: Bool, precio:Double)
    {
        aView.addSubview(self.view)
        self.tipoSuscripcion = suscripcion
        self.planId = planId
        self.mainViewController = aView
        if animated{
            self.showAnimate()
        }
        precioProducto = precio
        let formatter = NSNumberFormatter()
        self.txtPrecio.text =  "$"+formatter.stringFromNumber(precio)!
        
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
                    self.view.removeFromSuperview()
                    
                    let bundle = NSBundle(forClass: PopUpViewControllerFormasPago.self)

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
                    
                    self.popViewController = PopUpViewControllerFormasPago(nibName: "PopUpViewControllerFormasPago"+strPantalla, bundle: bundle)

                    
                    self.popViewController.showInView(self.mainViewController, suscripcion: self.tipoSuscripcion,planID:self.planId ,animated: true, precio:self.precioProducto)
                    
                }
        });
    }
    
    
    @IBAction func btnSiguiente(sender: AnyObject) {
        self.seguir();
    }
    @IBAction func btnCancelar(sender: AnyObject) {
        self.removeAnimate();
        
    }
}
