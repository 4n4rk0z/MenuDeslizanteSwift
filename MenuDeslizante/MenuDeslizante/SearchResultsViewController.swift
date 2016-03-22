//
//  SearchResultsViewController.swift
//  BuscadorSwift
//
//  Created by sergio ivan lopez monzon on 17/02/16.
//  Copyright © 2016 devworms. All rights reserved.
//

import UIKit
import Parse

class SearchResultsViewController: SearchControllerBaseViewController, UISearchResultsUpdating {
    // MARK: Types
    
    var searchController: UISearchController!

    
    
    struct StoryboardConstants {
        /**
         The identifier string that corresponds to the `SearchResultsViewController`'s
         view controller defined in the main storyboard.
         */
        static let identifier = "SearchResultsViewControllerStoryboardIdentifier"
        
        
        
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        /*
        `updateSearchResultsForSearchController(_:)` is called when the controller is
        being dismissed to allow those who are using the controller they are search
        as the results controller a chance to reset their state. No need to update
        anything if we're being dismissed.
        */
        guard searchController.active else { return }
        self.searchController = searchController
         filterString = searchController.searchBar.text
         //busqueda = searchController.searchBar.text
        
        
    }
    
    
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
        self.imagenRecetaSeleccionada = self.imagenes[recetaSeleccionada]
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

                            self.parent.objBusqueda = self.recetaSeleccionada
                            self.parent.imagenBusqueda = self.imagenRecetaSeleccionada
                            self.searchController.active = false
                            self.parent.performSegueWithIdentifier("PlatilloSegueBuscador", sender: nil)
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
                            
                            
                            self.parent.objBusqueda = self.recetaSeleccionada
                            self.parent.imagenBusqueda = self.imagenRecetaSeleccionada
                            self.searchController.active = false
                            self.parent.performSegueWithIdentifier("PlatilloSegueBuscador", sender: nil)
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
    
    
    
    
    
    

    

 
    
    

}
