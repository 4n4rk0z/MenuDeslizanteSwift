//
//  SearchControllerBaseViewController.swift
//  BuscadorSwift
//
//  Created by sergio ivan lopez monzon on 17/02/16.
//  Copyright © 2016 devworms. All rights reserved.
//


import UIKit
import Parse

class SearchControllerBaseViewController: UITableViewController {
    // MARK: Types
    
    var allTags = [String:PFObject]()
    var allResults = [String]()
    var imagenes = [PFObject:UIImage]()
    var recetaSeleccionada:PFObject!
    var popViewController : PopUpViewControllerSwift!
    var planId = "prhhst3k5uucmunpl9fr"
    var precioPlan = 5.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "fondorecetario"))
        obtenerTags()
    }
    
    func obtenerTags(){
     
        let query = PFQuery(className: "Tags")
        query.includeKey("Receta")
        query.findObjectsInBackgroundWithBlock {
            (tags: [PFObject]?, error: NSError?) -> Void in
            // comments now contains the comments for myPost
            
            if error == nil {
                
                //Si hay un cliente recupera su clientID y sale del metodo
                if let _ = tags as [PFObject]? {
                    
                    for tag in tags! {
                        
                        let objReceta = (tag.objectForKey("Receta") as? PFObject)!
                        
                        self.allResults.append((tag["Tag"] as? String)!)
                        self.allTags[(tag["Tag"] as? String)!] = objReceta
                    }
                }
            }
                
            else{
                
                
            }
        }
        
    }

    
    
    
    struct TableViewConstants {
        static let tableViewCellIdentifier = "Cell"
    }
    
    // MARK: Properties
   
    
    
    
    lazy var visibleResults: [String] = self.allResults
    
    /// A `nil` / empty filter string means show all results. Otherwise, show only results containing the filter.
    var filterString: String? = nil {
        didSet {
            if filterString == nil || filterString!.isEmpty || self.allTags.count <= 0 {
                visibleResults = allResults
            }
            else {
                // Filter the results using a predicate based on the filter string.
                let filterPredicate = NSPredicate(format: "self contains[c] %@", argumentArray: [filterString!.lowercaseString])
                visibleResults = allResults.filter { filterPredicate.evaluateWithObject($0) }
                
            }
            
            tableView.reloadData()
        }
    }

    
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleResults.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MenuPlatillosTableViewCell
        
        if visibleResults.count >= 1{
            let keyString = self.visibleResults[indexPath.row]
            let objReceta = self.allTags[keyString]
            let imgReceta = self.imagenes[objReceta!]

            cell.imagenRecetaView.image = imgReceta
            cell.nombreRecetaLabel.text = objReceta!["Nombre"] as? String
            cell.porcionesRecetaLabel.text = objReceta!["Porciones"] as? String
            cell.tiempoRecetaLabel.text = objReceta!["Tiempo"] as? String
            let nivelRecetaStr = objReceta!["Nivel"] as! String
            
            if (nivelRecetaStr.lowercaseString == "Principiante"){
                cell.imgDificultad.image = UIImage(named: "dificultadprincipiante")
            }else if(nivelRecetaStr.lowercaseString == "intermedio"){
                cell.imgDificultad.image = UIImage(named: "dificultadmedia")
            }
            else{
                cell.imgDificultad.image = UIImage(named: "dificultadavanzado")
            }
            
            if(imgReceta == nil){
                cargarImagenes(objReceta!, imagenRecetaView:  cell.imagenRecetaView, nombreRecetaLabel:cell.nombreRecetaLabel,  porcionesRecetaLabel:cell.porcionesRecetaLabel, tiempoRecetaLabel:cell.tiempoRecetaLabel, imgDificultad:cell.imgDificultad)
            }else{
                display_image(cell.imagenRecetaView, nombreRecetaLabel:cell.nombreRecetaLabel,  porcionesRecetaLabel:cell.porcionesRecetaLabel, tiempoRecetaLabel:cell.tiempoRecetaLabel, imgDificultad:cell.imgDificultad)
            }
            
            
            
            print(keyString)
            
            
        }
        
        return cell
    }
    
    
    func cargarImagenes(receta:PFObject, imagenRecetaView: UIImageView, nombreRecetaLabel:UILabel,  porcionesRecetaLabel:UILabel, tiempoRecetaLabel:UILabel, imgDificultad:UIImageView){
        
        let urlImagen = receta["Url_Imagen"] as? String
        let imgURL: NSURL = NSURL(string: urlImagen!)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil){
                //let tagString = (tag["Tag"] as? String)!
                
  
                self.imagenes[receta] = UIImage(data: data!)
                imagenRecetaView.image = UIImage(data: data!)
                
                func display_image()
                {
                    
                    UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        
                        imagenRecetaView.alpha = 100
                        nombreRecetaLabel.alpha = 100
                        porcionesRecetaLabel.alpha = 100
                        tiempoRecetaLabel.alpha = 100
                        imgDificultad.alpha = 100
                        
                        
                        }, completion: nil)
                    
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
                
                
                
                
            }
        }
        task.resume()
        
    }
    
    func display_image(imagenRecetaView: UIImageView, nombreRecetaLabel:UILabel,  porcionesRecetaLabel:UILabel, tiempoRecetaLabel:UILabel, imgDificultad:UIImageView)
    {
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            imagenRecetaView.alpha = 100
            nombreRecetaLabel.alpha = 100
            porcionesRecetaLabel.alpha = 100
            tiempoRecetaLabel.alpha = 100
            imgDificultad.alpha = 100
            
            
            }, completion: nil)
        

    }
   
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let keyString = self.visibleResults[indexPath.row]
        let objReceta = self.allTags[keyString]
        self.recetaSeleccionada = objReceta

        abrirReceta(objReceta!)
    }
    
    func abrirReceta(objReceta:PFObject){
        
        let objMenu = (objReceta.objectForKey("Menu") as? PFObject)!
        let identificador = objMenu.objectId;
        let query = PFQuery(className: "Menus")
        
        query.whereKey("objectId", equalTo: identificador!)
        query.findObjectsInBackgroundWithBlock {
            (lstMenus: [PFObject]?, error: NSError?) -> Void in
            // comments now contains the comments for myPost
            
            if error == nil {
                
                //Si hay un cliente recupera su clientID y sale del metodo
                if let _ = lstMenus as [PFObject]? {
                    
                    for menu in lstMenus! {
        
                        if menu["TipoMenu"].lowercaseString == "pago"{
            
                            self.consultarSuscripcion()
                        }
                        else
                        {
                            self.performSegueWithIdentifier("PlatilloSegueBuscador", sender: nil)
                        }
                    
                    }
                }
            }
        }
    }
    
    func consultarSuscripcion(){
        let query = PFQuery(className: "Clientes")
        //query.cachePolicy = .CacheElseNetwork
        query.whereKey("username", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {
            (clientes: [PFObject]?, error: NSError?) -> Void in
            // comments now contains the comments for myPost
            
            if error == nil {
                
                //Si hay un cliente recupera su clientID y sale del metodo
                if let _ = clientes as [PFObject]? {
                    for cliente in clientes! {
                        // This does not require a network access.
                        if ((cliente["Suscrito"] as? Bool) != nil && (cliente["Suscrito"] as? Bool)==true){
                            
                            /* cliente["codigobarras"] = ""
                            cliente["referenciaentienda"] = ""
                            cliente.saveInBackground()
                            */
                            
                            self.performSegueWithIdentifier("PlatilloSegueBuscador", sender: nil)
                        }
                        else{
                            
                            //let sepagoEnTienda = cliente["codigobarras"] as? String
                            //if sepagoEnTienda != ""{
                            
                            self.abrirVentanaPop(self.precioPlan, suscripcion:  true, planId:  self.planId)
                            //}
                        }
                        
                        break
                    }
                    
                    if (clientes?.count==0)
                    {
                        //Si no se fue a la ventana que sigue quiere decir o que no esta suscrito
                        self.abrirVentanaPop(self.precioPlan, suscripcion:  true, planId:  self.planId)
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
    
    func abrirVentanaPop(precio:Double, suscripcion:Bool!, planId:String!){
        let precio = precio
        let bundle = NSBundle(forClass: PopUpViewControllerSwift.self)
        
        let strPantalla = pantallaSize()
        
        
        self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController"+strPantalla, bundle: bundle)
        self.popViewController.showInView(self.view, animated: true, precioProducto: precio,suscripcion:  suscripcion, planId: planId)
        
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
    
    

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PlatilloSegueBuscador"{
            
            /*let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let receta = destinationNavigationController.topViewController as!  PlatillosViewController
            */
            
            let receta = segue.destinationViewController as!  PlatillosViewController
            receta.objReceta = self.recetaSeleccionada
            
        }
        
    }
    
    



    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //cell.imageView?.image = self.allTags[self.visibleResults[indexPath.row]]
     
    }
    
  
    
}
