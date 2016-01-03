//
//  PopUpViewControllerPagoTienda.swift
//  Pods
//
//  Created by sergio ivan lopez monzon on 01/01/16.
//
//


import UIKit
import QuartzCore
import Foundation
import Parse


@objc public class PopUpViewControllerPagoTienda : UIViewController {
    
    @IBOutlet weak var labelTexto: UILabel!
    var popViewController : PopUpViewControllerFormasPago!
    var popViewControllerWallet : PopUpViewControllerWallet!
    var tipoSuscripcion : Bool=false
    var desdeWallet : Bool = false
    var planID:String?
    var mainViewController :UIView!
    var boolBanderaExisteClienteAsociado:Bool = false
    var clientID:String!
    var precioProducto:Double!
    
    @IBOutlet weak var gActivity: UIActivityIndicatorView!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtNumero: UITextField!
    @IBOutlet weak var ivBarras: UIImageView!

    @IBOutlet weak var btnRegresar: UIButton!
    @IBOutlet weak var btnPagar: UIButton!
    
    //OpenPay variables
    let MERCHANT_ID:String =  "mom7qomx3rv93zcwv2vk"
    let API_KEY:String = "pk_f492b71637e247e4b5a314a1f9366ec9"
    
    var sessionId:String = ""
    var openpayAPI:Openpay!
    //*********************
    
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
    
    
    public func showInView(aView: UIView!, suscripcion:Bool,planID:String? ,animated: Bool, precio:Double, desdeWallet:Bool)
    {
        //Se llenan los campos si es que existe un cliente, si no se marca una bandera indicando que no hay un cliente asociado con esta cuenta
        buscarClientes()
        
        aView.addSubview(self.view)
        tipoSuscripcion = suscripcion
        self.planID = planID
        self.desdeWallet = desdeWallet
        mainViewController = aView
        if animated{
            self.showAnimate()
        }
        precioProducto = precio
        
        self.gActivity.hidden = true
        self.gActivity.stopAnimating()
        self.labelTexto.hidden = true
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
                    
                    if self.desdeWallet
                    {
                        self.popViewControllerWallet = PopUpViewControllerWallet(nibName: "PopUpViewControllerWallet"+strPantalla, bundle: bundle)
                        self.popViewControllerWallet.showInView(self.mainViewController, suscripcion: self.tipoSuscripcion,planID: self.planID ,animated: true, precio:   self.precioProducto)
                    }
                    else
                    {
                        self.popViewController = PopUpViewControllerFormasPago(nibName: "PopUpViewControllerFormasPago"+strPantalla, bundle: bundle)
                        self.popViewController.showInView(self.mainViewController, suscripcion: self.tipoSuscripcion,planID: self.planID ,animated: true, precio:   self.precioProducto)
                    }
                    
                }
        });
    }
    
    func crearClienteyPagar()
    {
        let headers = [
            "authorization": "Basic c2tfNzUwNmI4MTgzYmMzNGUwMzhlZTllODQ5ZTJlNTI5OTQ6Og==",
            "content-type": "application/json",
            "cache-control": "no-cache",
            "postman-token": "98984b68-00ab-2039-6ead-e5338c5cb696"
        ]
        
        let parameters = [
            "name" : self.txtNombre.text!,
            "phone_number" : self.txtNumero.text!,
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
                    clientes["numero"] = self.txtNumero.text!
                    
                    clientes.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The object has been saved.
                            self.pagarTienda()
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
                        self.txtNumero.text = (cliente["numero"] as? String)!
                        self.boolBanderaExisteClienteAsociado = true
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
    
    
    
    func pagarTienda()
    {
       
        
        if (self.clientID != "") {
            
            
            let headers = [
                "authorization": "Basic c2tfNzUwNmI4MTgzYmMzNGUwMzhlZTllODQ5ZTJlNTI5OTQ6Og==",
                "content-type": "application/json",
                "cache-control": "no-cache",
                "postman-token": "dc432aae-275d-63b4-1a2c-6256cc277dcf"
            ]
            
            let parameters = [
                "method": "store",
                "amount": self.precioProducto!,
                "description": "Cargo con tienda"
            ]
        
            do
            {
                let postData = try NSJSONSerialization.dataWithJSONObject(parameters, options: [])
            

                let request = NSMutableURLRequest(URL: NSURL(string: "https://sandbox-api.openpay.mx/v1/"+self.MERCHANT_ID+"/customers/"+clientID+"/charges")!,
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
                        do{
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? [String:AnyObject]
                            let pago = json!["payment_method"]
                            let barcode = pago!["barcode_url"] as? String!
                            let transaction_id = json!["id"] as? String!
                            self.load_image(barcode!, transaction_id_tienda: transaction_id!)
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
    }
    
    func load_image(urlString:String, transaction_id_tienda:String)
    {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    self.ivBarras.image = UIImage(data: data!)
                    self.gActivity.stopAnimating()
                    self.gActivity.hidden = true
                    self.labelTexto.hidden=false
                    
                    
                    let query = PFQuery(className: "Clientes")
                    query.whereKey("username", equalTo: PFUser.currentUser()!)
                    query.findObjectsInBackgroundWithBlock {
                        (clientes: [PFObject]?, error: NSError?) -> Void in
                        // comments now contains the comments for myPost
                        
                        if error == nil {
                            
                            //Si hay un cliente recupera su clientID y guarda el codigo de barras
                            if let _ = clientes as [PFObject]? {
                                for cliente in clientes! {

                                    let query = PFQuery(className:"Clientes")
                                    query.getObjectInBackgroundWithId(cliente.objectId!) {
                                        (clienteUpdate: PFObject?, error: NSError?) -> Void in
                                        if error != nil {
                                            print(error)
                                        } else if let clientUpdate = clienteUpdate {
                                            clientUpdate["codigobarras"] = urlString
                                            clientUpdate["transaction_id_tienda"] = transaction_id_tienda
                                            clientUpdate.saveInBackground()
                                            self.btnRegresar.hidden=true
                                            self.btnPagar.setTitle("Aceptar", forState: UIControlState.Normal)
                                        }
                                    }
                                }
                            }
                        }
                    }

                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }
    
    @IBAction func btnSiguiente(sender: AnyObject) {
        
        if self.btnPagar.titleLabel?.text == "Aceptar"{
            removeAnimate()
        }
        else
        {
            gActivity.hidden = false
            gActivity.startAnimating()
            ivBarras.image = nil
            self.labelTexto.hidden = true
        
            if (boolBanderaExisteClienteAsociado){
                self.pagarTienda()
            }
            else{
                self.crearClienteyPagar()
                }
        }
    }
    @IBAction func btnCancelar(sender: AnyObject) {
        self.regresar()
        
    }
}
