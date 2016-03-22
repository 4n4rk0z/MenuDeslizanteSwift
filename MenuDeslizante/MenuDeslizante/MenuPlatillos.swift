//
//  PlatillosView.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 21/11/15.
//  Copyright © 2015 sergio ivan lopez monzon. All rights reserved.
//
import UIKit
import Parse

class MenuPlatillos: UITableViewController {
    
    //Esta variable viene desde menu principal y hace referencia a los menus que deben de comprarse
    
    var menuSeleccionado:PFObject!
    var recetaSeleccionada:PFObject!
    var imagenRecetaSeleccionada:UIImage!
    var recetas = [PFObject]()
    var imagenes = [PFObject:UIImage]()
    var planId = "prhhst3k5uucmunpl9fr"
    var precioPlan = 5.0
    
    @IBOutlet weak var labelMenuSeleccionado: UILabel!
    var popViewController : PopUpViewControllerSwift!
    
    override func viewWillAppear(animated: Bool) {
        //Image Background Navigation Bar
        
        let navBackgroundImage:UIImage! = UIImage(named: "bandasuperior")
        
        let nav = self.navigationController?.navigationBar
        
        nav?.tintColor = UIColor.whiteColor()
        
        nav!.setBackgroundImage(navBackgroundImage, forBarMetrics:.Default)
        
        
    
        tableView.backgroundView = UIImageView(image: UIImage(named: "fondorecetario"))
        
        consultarRecetasDeMenu()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadMenuInformation(labelMenuSeleccionado, nombreMenu: menuSeleccionado["NombreMenu"] as! String)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func consultarRecetasDeMenu()
    {
        let query = PFQuery(className:"Recetas")
        query.whereKey("Menu", equalTo:self.menuSeleccionado)
        query.whereKey("Activada", equalTo:true)
        //query.cachePolicy = .CacheElseNetwork
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    
                    self.recetas = objects
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }

                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlatilloCell", forIndexPath: indexPath) as! MenuPlatillosTableViewCell
        
        let receta = self.recetas[indexPath.row]
        let num = self.imagenes.count
        let imgReceta = self.imagenes[receta]
        
            if (imgReceta == nil){
            self.loadCellInformation(cell.imagenRecetaView, urlString: receta["Url_Imagen"] as! String, nombreRecetaLabel: cell.nombreRecetaLabel, nombreRecetaStr: receta["Nombre"] as! String, nivelRecetaImagen: cell.imgDificultad, nivelRecetaStr:  receta["Nivel"] as! String, porcionesRecetaLabel: cell.porcionesRecetaLabel, porcionesRecetaStr: receta["Porciones"] as! String, tiempoRecetaLabel: cell.tiempoRecetaLabel, tiempoRecetaStr:receta["Tiempo"] as! String, objReceta:receta)
            }
            else{
                loadCellInformationCache(cell.imagenRecetaView, urlString: receta["Url_Imagen"] as! String, nombreRecetaLabel: cell.nombreRecetaLabel, nombreRecetaStr: receta["Nombre"] as! String, nivelRecetaImagen: cell.imgDificultad, nivelRecetaStr:  receta["Nivel"] as! String, porcionesRecetaLabel: cell.porcionesRecetaLabel, porcionesRecetaStr: receta["Porciones"] as! String, tiempoRecetaLabel: cell.tiempoRecetaLabel, tiempoRecetaStr:receta["Tiempo"] as! String, imgReceta:imgReceta!)
            }
        
        
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recetas.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlatilloCell", forIndexPath: indexPath) as! MenuPlatillosTableViewCell
        
        self.recetaSeleccionada = self.recetas[indexPath.row]
        imagenRecetaSeleccionada = imagenes[recetaSeleccionada];
        abrirReceta()
    }
    
    func abrirReceta(){
        
        if self.menuSeleccionado["TipoMenu"].lowercaseString == "pago"{
            
            consultarSuscripcion()
        }
        else
        {
            self.performSegueWithIdentifier("PlatilloSegue", sender: nil)
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
                            
                            self.performSegueWithIdentifier("PlatilloSegue", sender: nil)
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
    
    func consultarLaTienda()
    {
        
    }
    
    func loadCellInformationCache(imagenCell:UIImageView, urlString:String, nombreRecetaLabel:UILabel, nombreRecetaStr:String,  nivelRecetaImagen:UIImageView, nivelRecetaStr:String,  porcionesRecetaLabel:UILabel, porcionesRecetaStr:String,  tiempoRecetaLabel:UILabel, tiempoRecetaStr:String, imgReceta: UIImage)
    {
        
        
            func display_image()
                {
                    imagenCell.image = imgReceta
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
                        
                        imagenCell.alpha = 100
                        nombreRecetaLabel.alpha = 100
                        nivelRecetaImagen.alpha = 100
                        porcionesRecetaLabel.alpha = 100
                        tiempoRecetaLabel.alpha = 100
                        
                        
                        }, completion: nil)
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
        
    }
    
    func loadCellInformation(imagenCell:UIImageView, urlString:String, nombreRecetaLabel:UILabel, nombreRecetaStr:String,  nivelRecetaImagen:UIImageView, nivelRecetaStr:String,  porcionesRecetaLabel:UILabel, porcionesRecetaStr:String,  tiempoRecetaLabel:UILabel, tiempoRecetaStr:String, objReceta: PFObject)
    {
        
        func display_image()
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
        
        }
        
        dispatch_async(dispatch_get_main_queue(), display_image)

        
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                self.imagenes[objReceta] = UIImage(data: data!)

                func display_image()
                {
                    imagenCell.image = self.imagenes[objReceta]
                    
                    
                    UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        
                        imagenCell.alpha = 100
                        
                        
                        }, completion: nil)

                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }

    
    func loadMenuInformation(tipoMenuLabel:UILabel, nombreMenu:String)
    {
    
        tipoMenuLabel.text = nombreMenu
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        if segue.identifier == "PlatilloSegue"{
            let receta = segue.destinationViewController as!  PlatillosViewController
          
            receta.objReceta = self.recetaSeleccionada
            receta.imagenReceta = imagenes[self.recetaSeleccionada]
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
