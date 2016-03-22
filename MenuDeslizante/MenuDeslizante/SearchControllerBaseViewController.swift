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
    
    

    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //cell.imageView?.image = self.allTags[self.visibleResults[indexPath.row]]
     
    }
    
  
    
}
