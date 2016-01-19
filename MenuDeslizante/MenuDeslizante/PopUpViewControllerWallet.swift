//
//  PopUpViewControllerWallet.swift
//  Pods
//
//  Created by sergio ivan lopez monzon on 02/01/16.
//
//

import UIKit
import QuartzCore
import Parse

@objc public class PopUpViewControllerWallet : UIViewController {

    var popViewController : PopUpViewControllerFormasPago!
    var popViewControllerPagoTienda : PopUpViewControllerPagoTienda!
    var ventanaMenuPlatillos : MenuPlatillos!
    var tipoSuscripcion : Bool = false
    var mainViewController :UIView!
    var clientID:String!
    var tarjetaSeleccionadaId:String!
    var planId:String?
    var precioProducto:Double!
    
    @IBOutlet weak var lEmail: UILabel!
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var lBrandName: UILabel!
    @IBOutlet weak var lHolderName: UILabel!
    @IBOutlet weak var lCardNumber: UILabel!
    
    @IBOutlet weak var lmensaje: UILabel!
    @IBOutlet weak var loadingAction: UIActivityIndicatorView!
    @IBOutlet weak var btnPagar: UIButton!
    @IBOutlet weak var btnCancelar: UIButton!
    @IBOutlet weak var imageViewCard: UIImageView!
    
    @IBOutlet weak var txtPrecio: UILabel!
    
    let MERCHANT_ID:String =  "mom7qomx3rv93zcwv2vk"
    let API_KEY:String = "pk_f492b71637e247e4b5a314a1f9366ec9"
    
    var sessionId:String = ""
    var openpayAPI:Openpay!
    
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
    
    
    public func showInView(aView: UIView!, suscripcion:Bool,planID:String?, animated: Bool,precio:Double)
    {
        aView.addSubview(self.view)
        tipoSuscripcion = suscripcion
        mainViewController = aView
        if animated{
            self.showAnimate()
        }

        self.precioProducto = precio
        self.planId = planID
        let formatter = NSNumberFormatter()
        self.txtPrecio.text = "$"+formatter.stringFromNumber(precio)!
        self.imageViewCard.hidden = true
        self.loadingAction.hidden = false
        self.lmensaje.hidden = false
        self.lmensaje.text = "Recuperando información"
        self.btnCancelar.hidden = true
        self.btnPagar.hidden = true
        self.loadingAction.startAnimating()
        
        
        cargarInformacion()
        
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
 
    func setCharge()
    {
        let headers = [
            "content-type": "application/json",
            "authorization": "Basic c2tfNzUwNmI4MTgzYmMzNGUwMzhlZTllODQ5ZTJlNTI5OTQ6Og==",
            "cache-control": "no-cache",
            "postman-token": "802401e1-77ef-e336-8632-93fe300fe929"
        ]
               
        let parameters = [
            "source_id": self.tarjetaSeleccionadaId!,
            "method": "card",
            "amount": self.precioProducto!,
            "currency": "MXN",
            "description": "Compra de producto",
            "device_session_id": self.sessionId
        ]
        
        do
        {
            let postData = try NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        
            let request = NSMutableURLRequest(URL: NSURL(string: "https://sandbox-api.openpay.mx/v1/"+self.MERCHANT_ID+"/customers/"+self.clientID+"/charges")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
            request.HTTPMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.HTTPBody = postData
        
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    let httpResponse = response as? NSHTTPURLResponse
                    print(httpResponse)
                    
                    func actualizarPantalla()
                    {
                        self.btnPagar.setTitle("Aceptar", forState: UIControlState.Normal)
                        self.btnCancelar.hidden = true
                        self.loadingAction.hidden = true
                        self.loadingAction.stopAnimating()
                        self.btnPagar.hidden = false
                        self.lmensaje.text = "¡Felicidades por su compra!"
                    }//Actualiza mas rapido los elementos
                    dispatch_async(dispatch_get_main_queue(), actualizarPantalla)
                    
                }
            })
        
            dataTask.resume()
        
        }
        catch{
        }
    }
    
    func subscribeToPlan()
    {
        
        let headers = [
            "authorization": "Basic c2tfNzUwNmI4MTgzYmMzNGUwMzhlZTllODQ5ZTJlNTI5OTQ6Og==",
            "content-type": "application/json",
            "cache-control": "no-cache",
            "postman-token": "08ffcb1e-7d5d-83d7-92df-3a17684a1bc7"
        ]
        
        
        let parameters = [
            "source_id": self.tarjetaSeleccionadaId,
            "plan_id": self.planId
        ]
        
        do
        {
            let postData = try NSJSONSerialization.dataWithJSONObject(parameters, options: [])
            
            let request = NSMutableURLRequest(URL: NSURL(string: "https://sandbox-api.openpay.mx/v1/"+self.MERCHANT_ID+"/customers/"+self.clientID+"/subscriptions")!,
                cachePolicy: .UseProtocolCachePolicy,
                timeoutInterval: 10.0)
            request.HTTPMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.HTTPBody = postData
            
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    let httpResponse = response as? NSHTTPURLResponse
                    print(httpResponse)
                    
                    
                    func actualizarPantalla()
                    {
                    
                        self.btnPagar.setTitle("Aceptar", forState: UIControlState.Normal)
                        self.btnCancelar.hidden = true
                        self.loadingAction.hidden = true
                        self.loadingAction.stopAnimating()
                        self.btnPagar.hidden = false
                        self.lmensaje.text = "¡Te has suscrito!"
                    }//Actualiza mas rapido los elementos
                    dispatch_async(dispatch_get_main_queue(), actualizarPantalla)
                }
            })
            
            dataTask.resume()
        }
        catch
        {
            
        }
    }
    
    
    
    func pagar()
    {
        if tipoSuscripcion{
            subscribeToPlan()
        }
        else{
            //Es un pago comun y corriente
            setCharge()
        }
            
        
    }
    
    func cargarInformacion(){
        
        openpayAPI = Openpay(merchantId: MERCHANT_ID, apyKey: API_KEY, isProductionMode: false, isDebug: true)
        sessionId = openpayAPI.createDeviceSessionId()
        
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
                        // This does not require a network access.
                        self.clientID = (cliente["clientID"] as? String)!
                        //Se recuperan las tarjetas del cliente
                        self.lEmail.text = (cliente["email"] as? String)!
                        //Se recuperan las tarjetas del cliente
                        self.consultarWallet(cliente)
                        break
                    }
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
    
    func consultarWallet(cliente: PFObject )
    {
        let query = PFQuery(className:"Tarjetas")
        query.whereKey("cliente", equalTo: cliente)
        query.findObjectsInBackgroundWithBlock {
            (results: [PFObject]?, error: NSError?) -> Void in
            self.imageViewCard.hidden = false
            self.loadingAction.hidden = true
            self.loadingAction.stopAnimating()

            if error == nil {
                // results 
                for card in results!{
                    self.lBrandName.text = card["brand"] as? String!
                    self.lHolderName.text = cliente["nombre"] as? String!
                    self.lCardNumber.text = card["numero"] as? String!
                    self.tarjetaSeleccionadaId = card["tarjetaPrincipal"] as? String!
                    self.lmensaje.hidden = true
                    self.btnCancelar.hidden = false
                    self.btnPagar.hidden = false
                    
                }
                
            }
        }
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
                    
                    self.popViewControllerPagoTienda.showInView(self.mainViewController, suscripcion: self.tipoSuscripcion,planID:self.planId, animated: true, precio:  self.precioProducto, desdeWallet:  true)
                    
                }
        });
    }

    
    @IBAction func btnPagar(sender: AnyObject) {
        if self.btnPagar.titleLabel?.text == "Aceptar"{
            
            
            
          
            
        }
        else
        {
            loadingAction.hidden = false
            loadingAction.startAnimating()
            lmensaje.hidden = false
            lmensaje.text = "Procesando pago"
            btnPagar.hidden = true
            btnCancelar.hidden = true
            self.pagar();
        }
    }
    @IBAction func btnCancelar(sender: AnyObject) {
        self.removeAnimate();
        
    }
    
    @IBAction func btnPagarEnTienda(sender: AnyObject) {
        self.pagarTienda()
    }
    
}
