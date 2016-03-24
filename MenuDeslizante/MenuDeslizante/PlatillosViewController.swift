//
//  PlatillosViewController.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 06/12/15.
//  Copyright © 2015 sergio ivan lopez monzon. All rights reserved.
//


import UIKit
import Parse
import ParseTwitterUtils
import ParseFacebookUtilsV4

class PlatillosViewController: UIViewController{
    @IBOutlet weak var imageViewReceta: UIImageView!
    
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var textAreaReceta: UITextView!
    
    @IBOutlet weak var labelPorciones: UILabel!
    @IBOutlet weak var labelTiempo: UILabel!
    var objReceta:PFObject!
    var imagenReceta:UIImage!
    
    @IBOutlet weak var imagenDificultad: UIImageView!

    
    
    var popViewController: PopUpViewControllerCompartir!

    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let navBackgroundImage:UIImage! = UIImage(named: "bandasuperior")
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.whiteColor()
        nav!.setBackgroundImage(navBackgroundImage, forBarMetrics:.Default)
        
        activityLoader.hidden = false
        activityLoader.startAnimating()
        
        self.loadRecetaInformation()
        
      
    }

    override func viewWillDisappear(animated: Bool) {
        func display_image()
        {
                self.labelTitulo.text = ""
                self.imagenDificultad.image = nil
                self.labelPorciones.text = ""
                self.labelTiempo.text = ""
                self.textAreaReceta.text = ""
                self.textAreaReceta.text = ""
                self.imageViewReceta.image = nil
                self.imageViewReceta.alpha = 0.0
            
        }
        
        dispatch_async(dispatch_get_main_queue(), display_image)
        

    }


    func loadRecetaInformation()
    {
        func display_image()
        {
            
            if (self.imagenReceta == nil){
                cargarImagen(self.objReceta["Url_Imagen"] as! String)
            }
            else{
                self.imageViewReceta.image = self.imagenReceta
            }

            self.labelTitulo.text = (self.objReceta["Nombre"] as! String)
            let nivelRecetaStr = (self.objReceta["Nivel"] as! String)
            
            if (nivelRecetaStr.lowercaseString == "Principiante"){
                self.imagenDificultad.image = UIImage(named: "dificultadprincipiante")
            }else if(nivelRecetaStr.lowercaseString == "intermedio"){
                self.imagenDificultad.image = UIImage(named: "dificultadmedia")
            }
            else{
                self.imagenDificultad.image = UIImage(named: "dificultadavanzado")
            }
            
            
            
            self.labelPorciones.text = (self.objReceta["Porciones"] as! String)
            self.labelTiempo.text = (self.objReceta["Tiempo"] as! String)
            
            var text: String = "Ingredientes \n" + (self.objReceta["Ingredientes"] as! String)
            text = text + ("\n\nProcedimiento\n" + (self.objReceta["Procedimiento"] as! String))
            let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: text)
            
            let range1: Range<String.Index> = text.rangeOfString("Ingredientes")!
            let indexIngredientes: Int = text.startIndex.distanceTo(range1.startIndex)
            
            let range2: Range<String.Index> = text.rangeOfString("\n\nProcedimiento\n")!
            let indexProcedimiento: Int = text.startIndex.distanceTo(range2.startIndex)
            
            attributedText.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(24)], range: NSRange(location: indexIngredientes, length: 12))
            attributedText.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(24)], range: NSRange(location: indexProcedimiento, length: 16))
            
            self.textAreaReceta.attributedText = attributedText
            
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                
                self.imageViewReceta.alpha = 100
                
                
                }, completion: nil)
            
        }
        
        dispatch_async(dispatch_get_main_queue(), display_image)

        
        
       
    }
    
    func cargarImagen(url:String){
        
        let imgURL: NSURL = NSURL(string: url)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
        (data, response, error) -> Void in
        
        if (error == nil && data != nil)
        {
             self.imageViewReceta.image = UIImage(data: data!)
        }
        
        }
        
        task.resume()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bCompartir(sender: AnyObject) {
        abrirVentanaPop()
        
    }
    
    @IBAction func bLike(sender: AnyObject) {
        
        
        var usuario = false
        if PFUser.currentUser() != nil {
            
            if PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()!){
                usuario = true
            }
            else if PFTwitterUtils.isLinkedWithUser(PFUser.currentUser()!) {
                usuario = true
                
            }
            else if PFUser.currentUser() != nil{
                usuario = true
                
            }
        }
        
        
        if (usuario == false){
            
            let alertController = UIAlertController(title: "Iniciar sesión obligatorio",
                message: "Para poder añadir esta reseta a favoritos es necesario iniciar sesión",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default,
                handler: nil))
            // Display alert
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        else{
            let query = PFQuery(className: "Favoritos")
            query.cachePolicy = .CacheElseNetwork
            query.includeKey("Recetas")
            query.whereKey("username", equalTo: PFUser.currentUser()!)
            query.whereKey("Recetas", equalTo: self.objReceta)
            query.findObjectsInBackgroundWithBlock {
                (recetas: [PFObject]?, error: NSError?) -> Void in
                // comments now contains the comments for myPost
            
                if error == nil {
                
                    //Revisa si ese cliente tiene esa receta para mandar un mensaje de error al tratar de añadirla de nuevo
                    if recetas != nil && recetas?.count>0 {
                 
                        // The object has been saved.
                        let alertController = UIAlertController(title: "¡Esta receta ya fue añadida!",
                        message: "Tu receta ya esta en la seccion de favoritos",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                        alertController.addAction(UIAlertAction(title: "OK",
                        style: UIAlertActionStyle.Default,
                        handler: nil))
                        // Display alert
                        self.presentViewController(alertController, animated: true, completion: nil)
                }
                    //Añade la receta a favoritos
                else{
                 
                    let date = NSDate()
                    let calendar = NSCalendar.currentCalendar()
                    let components = calendar.components([.Day , .Month , .Year], fromDate: date)
                    
                    let year =  components.year
                    let month = components.month
                    let trimestre = Int(  (Double(month)/3) + 0.7)
                    
                    
                    let favorito = PFObject(className:"Favoritos")
                    favorito["username"] = PFUser.currentUser()
                    favorito["Anio"] = year
                    favorito["Mes"] = month
                    favorito["Trimestre"] = trimestre
                    favorito["Recetas"] = self.objReceta
                    
                    favorito.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The object has been saved.
                            let alertController = UIAlertController(title: "Añadido a favoritos",
                                message: "¡Tu receta ya esta disponible en la seccion de favoritos!",
                                preferredStyle: UIAlertControllerStyle.Alert)
                            
                                alertController.addAction(UIAlertAction(title: "OK",
                                style: UIAlertActionStyle.Default,
                                handler: nil))
                                // Display alert
                                self.presentViewController(alertController, animated: true, completion: nil)
                            } else {
                                // There was a problem, check error.description
                            }
                        }
                    }
                }
                else
                {
                    print(error)
                }
            }
        }
    }
    
    func abrirVentanaPop(){

        let bundle = NSBundle(forClass: PopUpViewControllerSwift.self)
        
        let strPantalla = pantallaSize()
        
        
        self.popViewController = PopUpViewControllerCompartir(nibName: "PopUpViewControllerCompartir"+strPantalla, bundle: bundle)
        self.popViewController.showInView(self.view, animated: true, receta: self.objReceta, imagenReceta: self.imageViewReceta.image!)
        
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
/*
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "viralizarUno"{
            
        }
        
    }
*/

    
    
    
}
