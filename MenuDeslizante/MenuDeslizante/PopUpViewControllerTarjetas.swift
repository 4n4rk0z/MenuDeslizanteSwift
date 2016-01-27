//
//  PopUpViewControllerTarjetas.swift
//  Pods
//
//  Created by sergio ivan lopez monzon on 01/01/16.
//
//

import UIKit
import QuartzCore
import Parse

@objc public class PopUpViewControllerTarjetas : UIViewController {
    
    var popViewController : PopUpViewControllerFormasPago!
    var popViewControllerWallet : PopUpViewControllerWallet!
    var tipoSuscripcion :Bool = false
    var planID:String?
    var precioProducto:Double!
    var mainViewController :UIView!
    var parseClient:PFObject!
    var boolBanderaExisteClienteAsociado:Bool = false
    
    var clientID:String!
 
    @IBOutlet weak var btnRegresar: UIButton!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var txtNumeroTarjeta: UITextField!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var txtMes: UITextField!
    @IBOutlet weak var txtAnio: UITextField!
    @IBOutlet weak var txtCvc: UITextField!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    
    @IBOutlet weak var txtMensajes: UILabel!
    
    //OpenPay variables
    let MERCHANT_ID:String =  "mom7qomx3rv93zcwv2vk"
    let API_KEY:String = "pk_f492b71637e247e4b5a314a1f9366ec9"
    
    var sessionId:String = ""
    var openpayAPI:Openpay!
    //*********************
    
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
        openpayAPI = Openpay(merchantId: MERCHANT_ID, apyKey: API_KEY, isProductionMode: false, isDebug: true)
        sessionId = openpayAPI.createDeviceSessionId()

    }
    
    
    public func showInView(aView: UIView!, suscripcion:Bool,planID:String?, animated: Bool, precio:Double)
    {
        //Se llenan los campos si es que existe un cliente, si no se marca una bandera indicando que no hay un cliente asociado con esta cuenta
        buscarClientes()
        self.planID = planID
        aView.addSubview(self.view)
        tipoSuscripcion = suscripcion
        mainViewController = aView
        if animated{
            self.showAnimate()
        }
        setActivityIndicatorEnabled(false)
        precioProducto = precio
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
    
    func guardar(token_id:String, device_session_id:String)
    {
       
        let headers = [
            "authorization": "Basic c2tfNzUwNmI4MTgzYmMzNGUwMzhlZTllODQ5ZTJlNTI5OTQ6Og==",
            "content-type": "application/json",
            "cache-control": "no-cache",
            "postman-token": "1a97edaa-a25c-2cea-7537-73fd24f5ff2f"
        ]
        let parameters = [
            "token_id": token_id,
            "device_session_id":device_session_id
        ]
        
        do
        {
            let postData = try NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://sandbox-api.openpay.mx/v1/"+self.MERCHANT_ID+"/customers/"+self.clientID+"/cards")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.HTTPBody = postData
        

        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            self.setActivityIndicatorEnabled(false)
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? NSHTTPURLResponse
                print(httpResponse)
                
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? [String:AnyObject]
                    
                    //Guardamos en parse para tener un acceso más rápido a esta información
                    let tarjetaId = json!["id"] as? String!
                    let brand = json!["brand"] as? String!
                    let numeroT = json!["card_number"] as? String!
                    let bank = json!["bank_name"] as? String!
                    
                    let tarjeta = PFObject(className:"Tarjetas")
                    tarjeta["cliente"] = self.parseClient
                    tarjeta["tarjetaPrincipal"] = tarjetaId
                    tarjeta["brand"] = brand
                    tarjeta["numero"] = numeroT
                    tarjeta["banco"] = bank

                    tarjeta.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The object has been saved.
                            self.abrirWallet()
                        } else {
                            // There was a problem, check error.description
                        }
                    }

                
                
                }
                    
                catch{
                    
                }
            }
        })
        
        dataTask.resume()
        }
        catch
        {
            
        }
    }
    
    func abrirWallet(){
        
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                    
                    let bundle = NSBundle(forClass: PopUpViewControllerWallet.self)
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
                    self.popViewControllerWallet = PopUpViewControllerWallet(nibName: "PopUpViewControllerWallet"+strPantalla, bundle: bundle)
                    
                    self.popViewControllerWallet.showInView(self.mainViewController, suscripcion: self.tipoSuscripcion, planID:self.planID,animated: true, precio: self.precioProducto)
                }
        });
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
                        // This does not require a network access.
                        self.clientID = (cliente["clientID"] as? String)!
                        self.txtNombre.text = (cliente["nombre"] as? String)!
                        self.txtEmail.text = (cliente["email"] as? String)!
                        self.txtTelefono.text = (cliente["numero"] as? String)!
                        self.boolBanderaExisteClienteAsociado = true
                        self.parseClient = cliente
                        break
                    }
                }
                else{
                    self.boolBanderaExisteClienteAsociado = false
                    
                }
            }
            else
            {
                print(error)
            }
        }
    }
    
    func regresar()
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
                    
                    
                    self.popViewController.showInView(self.mainViewController, suscripcion: self.tipoSuscripcion, planID:self.planID,animated: true, precio:self.precioProducto)
                    
                }
        });
    }
    
    func crearClienteyGuardar()
    {
        let headers = [
            "authorization": "Basic c2tfNzUwNmI4MTgzYmMzNGUwMzhlZTllODQ5ZTJlNTI5OTQ6Og==",
            "content-type": "application/json",
            "cache-control": "no-cache",
            "postman-token": "98984b68-00ab-2039-6ead-e5338c5cb696"
        ]
        
        let parameters = [
            "name" : self.txtNombre.text!,
            "phone_number" : self.txtTelefono.text!,
            "email" : self.txtEmail.text!,
            "requires_account" : "true"
        ]
        
        do
        {
            let postData =  try NSJSONSerialization.dataWithJSONObject(parameters, options: [])
            
            let request = NSMutableURLRequest(URL: NSURL(string: "https://sandbox-api.openpay.mx/v1/"+self.MERCHANT_ID+"/customers")!,
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
                    _ = httpResponse?.allHeaderFields
                    
                    self.clientID = httpResponse!.allHeaderFields["Resource-ID"] as! String!
                    
                    let clientes = PFObject(className:"Clientes")
                    clientes["username"] = PFUser.currentUser()
                    clientes["clientID"] = self.clientID!
                    clientes["nombre"] = self.txtNombre.text!
                    clientes["email"] = self.txtEmail.text!
                    clientes["numero"] = self.txtTelefono.text!
                    clientes["Suscrito"] = false
                    
                    clientes.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The object has been saved.
                            self.parseClient = clientes
                            self.submitCardInfo()
                            self.boolBanderaExisteClienteAsociado = true
                            
                        } else {
                            print(error)
                        }
                    }
                }
            })
            
            dataTask.resume()
            
        }
        catch
        {
            
        }
    }
    
    func setActivityIndicatorEnabled(enabled:Bool) {
        if (enabled){
            btnAction.hidden = true
            btnRegresar.hidden = true
            loadingIndicator.startAnimating()
            loadingIndicator.hidden = false
            txtMensajes.hidden = false
            self.txtMensajes.text = "Guardando tarjeta"
        }
        else {
            btnAction.hidden = false
            btnRegresar.hidden = false
            loadingIndicator.stopAnimating()
            loadingIndicator.hidden = true
            txtMensajes.hidden = true
            self.txtMensajes.text = "Guardando tarjeta"
        }
        
    }

    
    func submitCardInfo()
    {
        let card = OPCard();
        card.holderName = txtNombre.text
        card.number = txtNumeroTarjeta.text
        card.expirationMonth = txtMes.text
        card.expirationYear = txtAnio.text
        card.cvv2 = txtCvc.text
        
        
        openpayAPI.createTokenWithCard(card, success: { (token:OPToken! ) -> Void in
            
            var dictionary: [String:AnyObject] = Dictionary()
            dictionary["id"] = token.id
            dictionary["device_session_id"] = self.sessionId
            dictionary["card"] = token.card.asMutableDictionary()
            
            let mutableDictionary = NSMutableDictionary(dictionary: dictionary)
            
           print(mutableDictionary.description)
            
            self.guardar(token.id, device_session_id: self.sessionId)
          
            
            }, failure: { (error:NSError!) -> Void in
                self.setActivityIndicatorEnabled(false)
                var dictionary: [String:AnyObject] = Dictionary()
                dictionary["code"] = error.code
                dictionary["info"] = error.userInfo
                
                let mutableDictionary = NSMutableDictionary(dictionary: dictionary)
                print(mutableDictionary.description)
        })
    }

    
    
    @IBAction func btnGuardar(sender: AnyObject) {
        
        self.setActivityIndicatorEnabled(true)
        if (boolBanderaExisteClienteAsociado){
            
            self.submitCardInfo()
        }
        else{
            self.crearClienteyGuardar()
        }

    }
    @IBAction func btnCancelar(sender: AnyObject) {
        self.regresar()
        
    }
}
