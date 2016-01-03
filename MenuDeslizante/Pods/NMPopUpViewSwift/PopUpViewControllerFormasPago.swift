//
//  PopUpViewControllerFormasPago.swift
//  Pods
//
//  Created by sergio ivan lopez monzon on 01/01/16.
//
//


import UIKit
import QuartzCore

@objc public class PopUpViewControllerFormasPago : UIViewController {
    
    var popViewControllerPagoTienda : PopUpViewControllerPagoTienda!
    var popViewControllerTarjetas : PopUpViewControllerTarjetas!
    var mainViewController :UIView!
    var tipoSuscripcion :Bool = false
    var precioProducto: Double!
    var planID:String?
    @IBOutlet weak var popUpView: UIView!
    
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
    
    
    public func showInView(aView: UIView!, suscripcion:Bool, planID:String?,animated: Bool, precio:Double)
    {
        aView.addSubview(self.view)
        self.tipoSuscripcion = suscripcion
        self.planID = planID
        self.mainViewController = aView
        if animated{
            self.showAnimate()
        }
       self.precioProducto = precio
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
    
    func agregarTarjeta()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                    
                     let bundle = NSBundle(forClass: PopUpViewControllerTarjetas.self)
                    
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
                    
                    self.popViewControllerTarjetas = PopUpViewControllerTarjetas(nibName: "PopUpViewControllerTarjetas"+strPantalla, bundle: bundle)
                    
                
                    self.popViewControllerTarjetas.showInView(self.mainViewController, suscripcion: self.tipoSuscripcion,planID:self.planID ,animated: true, precio:  self.precioProducto)
                    
                }
        });
    }
    
    func pagarTienda()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                    
                    let bundle = NSBundle(forClass: PopUpViewControllerPagoTienda.self)
                    
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
                    
                    self.popViewControllerPagoTienda = PopUpViewControllerPagoTienda(nibName: "PopUpViewControllerPagoTienda"+strPantalla, bundle: bundle)
                    
                    self.popViewControllerPagoTienda.showInView(self.mainViewController, suscripcion: self.tipoSuscripcion,planID:self.planID, animated: true, precio:  self.precioProducto, desdeWallet: false)
                    
                }
        });
    }

    
    @IBAction func btnCancelar(sender: AnyObject) {
        self.removeAnimate();
        
    }
    
    @IBAction func btnAnadirTarjeta(sender: AnyObject) {
        agregarTarjeta()
    }
    
    @IBAction func btnPagarTienda(sender: AnyObject) {
        pagarTienda()
    }
    
}
