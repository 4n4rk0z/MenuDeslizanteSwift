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
    @IBOutlet weak var lEstatus: UILabel!
    @IBOutlet weak var imageViewBarCode: UIImageView!
    @IBOutlet weak var lNumeroReferencia: UILabel!
    @IBOutlet weak var loadingAction: UIActivityIndicatorView!
    
    @IBOutlet weak var lHolderName: UILabel!
    @IBOutlet weak var lBrandName: UILabel!
    
    @IBOutlet weak var lCardNumber: UILabel!
    @IBOutlet weak var lMensaje: UILabel!
    
    @IBOutlet weak var bEliminarTarjeta: UIButton!
    @IBOutlet weak var bTarjeta: UIImageView!
    
    @IBOutlet weak var bCerrarSesion: UIButton!
    @IBOutlet weak var bCancelarSuscripcion: UIButton!
    
    var merchantId = "mom7qomx3rv93zcwv2vk"
    var clientId:String!
    var suscripcion = "prhhst3k5uucmunpl9fr"
    var tarjetaObjeto:PFObject!
    var clienteObjeto:PFObject!
    
    var tarjetaSeleccionadaId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadingAction.startAnimating()
        self.loadingAction.hidden = false
        self.lMensaje.hidden = false
        self.bTarjeta.hidden = true
        self.bEliminarTarjeta.hidden = true
        self.bCancelarSuscripcion.hidden = true
        
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
                
                    self.consultarCliente()
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
                            self.bCerrarSesion.alpha = 100
                            
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
                    self.consultarCliente()
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
                        self.bCerrarSesion.alpha = 100
                        
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
                self.bCerrarSesion.alpha = 100
                self.lCorreoElectronico.alpha = 100
                self.consultarCliente()
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
    
    
    func consultarCliente(){
        let query = PFQuery(className: "Clientes")
        query.whereKey("username", equalTo: PFUser.currentUser()!)

        query.findObjectsInBackgroundWithBlock {
            (clientes: [PFObject]?, error: NSError?) -> Void in
            // comments now contains the comments for myPost
            
            if error == nil {
                
                //Si hay un cliente recupera su clientID y sale del metodo
                if let _ = clientes as [PFObject]? {
                    if clientes?.count > 0 {
                        for cliente in clientes! {
                           self.clienteObjeto = cliente
                            // This does not require a network access.
                            let EstatusInscrito =  (cliente["Suscrito"] as? Bool)!
                            self.clientId = (cliente["clientID"] as? String)!
                            
                            if EstatusInscrito {
                                self.lEstatus.text = "Suscrito"
                            }
                            else{
                                self.lEstatus.text = "Sin inscripción actual"
                            }
                            let codigo =  cliente["codigobarras"] as? String
                            if codigo == nil || codigo!.isEmpty{
                                self.imageViewBarCode.hidden = true
                                self.lNumeroReferencia.hidden = true
                            }
                            else{
                                self.imageViewBarCode.hidden = false
                                self.lNumeroReferencia.hidden = false
    
                                self.load_image(codigo!)
                            }
                            self.consultarWallet(cliente)
                            break
                        }
                    }
                    else{
                        self.lMensaje.hidden = true
                        self.loadingAction.stopAnimating()
                        self.loadingAction.hidden = true
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
    
    func load_image(urlString:String)
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
                    self.imageViewBarCode.image = UIImage(data: data!)
                    self.loadingAction.stopAnimating()
                    self.loadingAction.hidden = true
                    self.lMensaje.hidden=true
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }

    
    func consultarWallet(cliente: PFObject )
    {
        let query = PFQuery(className:"Tarjetas")
        query.whereKey("cliente", equalTo: cliente)
        query.findObjectsInBackgroundWithBlock {
            (results: [PFObject]?, error: NSError?) -> Void in
            self.lMensaje.hidden = true
            self.loadingAction.hidden = true
            self.loadingAction.stopAnimating()
            
            if error == nil {
                // results
                for card in results!{
                    self.tarjetaObjeto = card
                    self.lBrandName.text = card["brand"] as? String!
                    self.lHolderName.text = cliente["nombre"] as? String!
                    let referenciaN = cliente["referenciaentienda"] as? String!
                    if referenciaN != nil && referenciaN != "" {
                        self.lNumeroReferencia.text = referenciaN
                    }
                    self.lCardNumber.text = card["numero"] as? String!
                    self.tarjetaSeleccionadaId = card["tarjetaPrincipal"] as? String!
                    self.bEliminarTarjeta.hidden = false
                    self.bTarjeta.hidden = false
                    let EstatusInscrito =  (cliente["Suscrito"] as? Bool)!
                    if EstatusInscrito {
                        self.bCancelarSuscripcion.hidden = false
                    }
                    
                }
                
            }
        }
    }
    @IBAction func btnCancelarSuscripcion(sender: AnyObject) {
        
        let headers = [
            "content-type": "application/json",
            "authorization": "Basic c2tfNzUwNmI4MTgzYmMzNGUwMzhlZTllODQ5ZTJlNTI5OTQ6Og==",
            "cache-control": "no-cache",
            "postman-token": "be18bd94-8ab2-4c9f-03ac-c298ae52c8c5"
        ]
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://sandbox-api.openpay.mx/v1/"+self.merchantId+"/customers/"+self.clientId+"/subscriptions/"+self.suscripcion+"")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "DELETE"
        request.allHTTPHeaderFields = headers
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? NSHTTPURLResponse
                print(httpResponse)
                self.clienteObjeto["Suscrito"] = false
                self.clienteObjeto.saveInBackgroundWithBlock({ (sucess, error) -> Void in
                    self.consultarCliente()
                    self.bCancelarSuscripcion.hidden = true
                })

            }
        })
        
        dataTask.resume()
    }
    
    @IBAction func btnEliminarTarjeta(sender: AnyObject) {
        tarjetaObjeto.deleteInBackgroundWithBlock { (sucess, error) -> Void in
            self.consultarCliente()
            
            func refresh()
            {
            
                self.lHolderName.hidden = true
                self.lBrandName.hidden = true
                self.lCardNumber.hidden = true
                self.lMensaje.hidden = true
            
                self.bEliminarTarjeta.hidden = true
                self.bTarjeta.hidden = true
    
               
            
            
            }
            
            dispatch_async(dispatch_get_main_queue(), refresh)

        }
    }
    
    
}
