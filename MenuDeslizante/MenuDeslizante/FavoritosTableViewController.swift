//
//  FavoritosTableViewController.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 21/11/15.
//  Copyright © 2015 sergio ivan lopez monzon. All rights reserved.
//

import UIKit
import Parse
import ParseTwitterUtils
import ParseFacebookUtilsV4


class FavoritosTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    var favoritos = [PFObject]()
    var recetaSeleccionada:PFObject!
    var imagenReceta:UIImage!
    var imagenes = [PFObject:UIImage]()
    var nombreTabla:String = "Favoritos"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
       // self.tableView.editing = true

        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            
            revealViewController().rightViewRevealWidth = 150
            //    extraButton.target = revealViewController()
            //    extraButton.action = "rightRevealToggle:"
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            
            //Si no se fue a la ventana que sigue quiere decir o que no esta suscrito
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
                
                let alertController = UIAlertController(title: "Debe iniciar sesión",
                    message: "Para poder acceder a tu sección de favoritos debe iniciar sesión",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(UIAlertAction(title: "OK",
                    style: UIAlertActionStyle.Default,
                    handler: nil))
                // Display alert
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }

            else{
                consultarFavoritos()
            }
            
            
        }
        
        
        let navBackgroundImage:UIImage! = UIImage(named: "bandasuperior")
        
        let nav = self.navigationController?.navigationBar
        
        nav?.tintColor = UIColor.whiteColor()
        
        nav!.setBackgroundImage(navBackgroundImage, forBarMetrics:.Default)
        
        
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "fondorecetario"))
        
    }
    
    func consultarFavoritos(){
        let query = PFQuery(className: nombreTabla)
    //    query.cachePolicy = .CacheElseNetwork
        query.whereKey("username", equalTo: PFUser.currentUser()!)
        query.includeKey("Recetas")
        query.findObjectsInBackgroundWithBlock {
            (favoritos: [PFObject]?, error: NSError?) -> Void in
            // comments now contains the comments for myPost
            
            if error == nil {
                
                //Si hay un cliente recupera su clientID y sale del metodo
                if let _ = favoritos as [PFObject]? {
                    self.favoritos = favoritos!
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            self.favoritos[indexPath.row].deleteInBackground()
            consultarFavoritos()
            // The object has been saved.
            let alertController = UIAlertController(title: "Receta Borrada",
                message: "¡Esta receta ya no forma parte de tus " + nombreTabla.lowercaseString,
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default,
                handler: nil))
        }
    }
    
    override func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return true
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.favoritos.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.recetaSeleccionada = self.favoritos[indexPath.row].objectForKey("Recetas") as! PFObject
        self.imagenReceta = self.imagenes[self.recetaSeleccionada]
        
        self.performSegueWithIdentifier("PlatilloSegueFavoritos", sender: nil)
        
    }
    
    // para cuadrar las imagenes
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return pantallaSizeHeight();//Choose your custom row height
    }
    
    func pantallaSizeHeight()->CGFloat!
    {
        var strPantalla = 224.0 //iphone 5
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        {
            strPantalla = 500.0
        }
        else
        {
            
            if UIScreen.mainScreen().bounds.size.width > 320 {
                if UIScreen.mainScreen().scale == 3 { //iphone 6 plus
                    strPantalla = 286.0
                }
                else{
                    strPantalla = 266.0 //iphone 6
                }
            }
        }
        return CGFloat(strPantalla)
    }

    
    func loadCellInformation(imagenCell:UIImageView, urlString:String, nombreRecetaLabel:UILabel, nombreRecetaStr:String,  nivelRecetaImagen:UIImageView, nivelRecetaStr:String,  porcionesRecetaLabel:UILabel, porcionesRecetaStr:String,  tiempoRecetaLabel:UILabel, tiempoRecetaStr:String, receta:PFObject)
    {
        
        nombreRecetaLabel.text = nombreRecetaStr
        if (nivelRecetaStr.lowercaseString == "Principiante"){
            nivelRecetaImagen.image = UIImage(named: "dificultadprincipiante")
        }else if(nivelRecetaStr.lowercaseString == "intermedio"){
            nivelRecetaImagen.image = UIImage(named: "dificultadmedia")
        }
        else{
            nivelRecetaImagen.image = UIImage(named: "dificultadavanzado")
        }
        
        porcionesRecetaLabel.text = porcionesRecetaStr
        tiempoRecetaLabel.text = tiempoRecetaStr
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            nombreRecetaLabel.alpha = 100
            nivelRecetaImagen.alpha = 100
            porcionesRecetaLabel.alpha = 100
            tiempoRecetaLabel.alpha = 100
            
            
            }, completion: nil)
        

        if(self.imagenes[receta] == nil) {
        
            let imgURL: NSURL = NSURL(string: urlString)!
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request){
                (data, response, error) -> Void in
            
                if (error == nil && data != nil)
                {
                    func display_image()
                    {
                        imagenCell.image = UIImage(data: data!)
                    
                        self.imagenes[receta] = UIImage(data: data!)
                    
                        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        
                        imagenCell.alpha = 100
                        
                        
                        }, completion: nil)

                    }
                
                    dispatch_async(dispatch_get_main_queue(), display_image)
                }
            
            }
        
            task.resume()
        
        }
        else{
            imagenCell.image = self.imagenes[receta]
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MenuPlatillosTableViewCell
        
        let receta =  self.favoritos[indexPath.row].objectForKey("Recetas") as! PFObject
        
        self.loadCellInformation(cell.imagenRecetaView, urlString: receta["Url_Imagen"] as! String, nombreRecetaLabel: cell.nombreRecetaLabel, nombreRecetaStr: receta["Nombre"] as! String, nivelRecetaImagen: cell.imgDificultad, nivelRecetaStr:  receta["Nivel"] as! String, porcionesRecetaLabel: cell.porcionesRecetaLabel, porcionesRecetaStr: receta["Porciones"] as! String, tiempoRecetaLabel: cell.tiempoRecetaLabel, tiempoRecetaStr:receta["Tiempo"] as! String, receta: receta)
        
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "PlatilloSegueFavoritos"{
            let receta = segue.destinationViewController as!  PlatillosViewController
            receta.objReceta = self.recetaSeleccionada
        }

        
    }
    
    
}

