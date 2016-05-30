//
//  NewsTableViewController.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 17/11/15.
//  Copyright © 2015 sergio ivan lopez monzon. All rights reserved.
//

import UIKit
import Parse

class PrincipalTableViewController: ModeloTableViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    //Para decirnos cual es la opcion que corresponde a cada posicion del menu
    var itemsMenu = [PFObject]()
    var imagesArray = [Int:UIImage]()
    var menuSeleccionado:PFObject!
    //Para almacenar el numero de recetas de ese menú
    var numeroDeRecetasPorMenu = [PFObject:Int]()
    
    // `searchController` cuando el boton de busqueda es presionado
    var searchController: UISearchController!

    var objBusqueda:PFObject!
    var imagenBusqueda:UIImage!
    
    var popViewController: PopUpViewControllerCompartir!
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        
        //Image Background Navigation Bar
        
        let img = UIImage(named: "fondoflores")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 15, 0, 15), resizingMode: UIImageResizingMode.Stretch)
        
        navigationController?.navigationBar.setBackgroundImage(img, forBarMetrics: .Default)
        
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        
        
        //Create the UIImage
        let image = UIImage(named: "fondo")
        
        //Create a container view that will take all of the tableView space and contain the imageView on top
        let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width , height: UIScreen.mainScreen().bounds.size.height))
        
        //Create the UIImageView that will be on top of our table
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width , height: UIScreen.mainScreen().bounds.size.height))
        
        //Set the image
        imageView.image = image
        
        //Clips to bounds so the image doesnt go over the image size
        imageView.clipsToBounds = true
        
        //Scale aspect fill so the image doesn't break the aspect ratio to fill in the header (it will zoom)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        containerView.addSubview(imageView)
        
        self.tableView.backgroundView = containerView
        
        
        
        
       
        // cargamos las imagenes
            let query = PFQuery(className: "Menus")
            query.whereKey("Activo", equalTo: true)
            //query.cachePolicy = .CacheElseNetwork
            query.orderByAscending("Orden")
            query.findObjectsInBackgroundWithBlock {
                (items: [PFObject]?, error: NSError?) -> Void in
                // comments now contains the comments for myPost
                
                if error == nil {
                    //Si hay un cliente recupera su clientID y sale del metodo
                    if let _ = items as [PFObject]? {
                        self.itemsMenu = items!
                        
                        for item in items! {
                            //Contar elementos de recetas en el menu principal
                            let queryReceta = PFQuery(className:"Recetas")
                            //queryReceta.cachePolicy = .CacheElseNetwork
                            queryReceta.whereKey("Menu", equalTo: item)
                            queryReceta.whereKey("Activada", equalTo: true)
                            queryReceta.countObjectsInBackgroundWithBlock {
                                (count: Int32, error: NSError?) -> Void in
                                if error == nil {
                                    self.numeroDeRecetasPorMenu[item]=Int(count)
                                    if self.numeroDeRecetasPorMenu.count == self.itemsMenu.count{
                                        dispatch_async(dispatch_get_main_queue()) {
                                            
                                            self.tableView.reloadData()
                                        }
                                    }
                                    
                                }
                            }
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
    
    override func viewDidLoad() {
     super.viewDidLoad()
     self.tableView.delegate = self
     
        self.tableView.dataSource = self
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            
            revealViewController().rightViewRevealWidth = 150
        //    extraButton.target = revealViewController()
        //    extraButton.action = "rightRevealToggle:"
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            
            
            
            
         
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.itemsMenu.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PrincipalTableViewCell
        
        self.menuSeleccionado = itemsMenu[indexPath.row]
        
        let goto=self.menuSeleccionado["TipoMenu"].lowercaseString

        if goto=="gratis" || goto=="pago"
        {
            self.performSegueWithIdentifier("recetarios", sender: nil)
        }
        else if goto=="viral" && imagesArray.count > 0
        {
            
           
            let imagen =   self.imagesArray[indexPath.row]
            abrirVentanaPop(self.menuSeleccionado, imageViewReceta: imagen)
            //   self.performSegueWithIdentifier("viralizacion", sender: nil)
            
        }
        
        
    }

    func abrirVentanaPop(objMenu:PFObject!, imageViewReceta: UIImage!){
        
        let bundle = NSBundle(forClass: PopUpViewControllerSwift.self)
        
        let strPantalla = pantallaSize()
        
        
        self.popViewController = PopUpViewControllerCompartir(nibName: "PopUpViewControllerCompartir"+strPantalla, bundle: bundle)
        
        let query = PFQuery(className:"Recetas")
        query.whereKey("Menu", equalTo:objMenu)
        query.findObjectsInBackgroundWithBlock {
            (objRecetas: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let _ = objRecetas {
                    for objReceta in objRecetas! {
                        self.popViewController.context = self
                        self.popViewController.opcion = "viral"
                        
                        let imagen = imageViewReceta
                        self.popViewController.showInView(self.view, animated: true, receta: objReceta, imagenReceta: imagen)
                        break
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        
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
    


    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PrincipalTableViewCell
        
        
        cell.lNumeroRecetas.transform = CGAffineTransformMakeRotation(CGFloat(-0.76))
        
        let item = self.itemsMenu[indexPath.row]
        //ocultamos si es tipo menu viral el icono de postit
        if ((item["TipoMenu"] as? String)?.lowercaseString) == "viral"{
            cell.lNumeroRecetas.hidden = true
            cell.imgCinta.hidden = true
            cell.imgPaquete.hidden = true
            cell.imgPagoGratis.hidden = true
            
        }
        //se carga la informacion del menu
        
        
        if(indexPath.row == 0){
            cell.imgBottomDevider.hidden = true;
        }
        
        if(indexPath.row == self.itemsMenu.count-1){
            cell.imgTopDevider.hidden = true;
        }
        
        let urlImagen = item["Url_Imagen"] as? String!
        let numeroRecetas = self.numeroDeRecetasPorMenu[item]!
        let nombre = (item["NombreMenu"] as? String)!
        
        self.loadCellInformation(cell.postImageView!, numeroLabelView:  cell.lNumeroRecetas, urlString:urlImagen!, numeroRedecetas: numeroRecetas , tipoMenuLabel: cell.nombreLabelMenu, nombreMenu: nombre, rowIndex:  indexPath.row)
        
      
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "recetarios"{
            let menu = segue.destinationViewController as!  MenuPlatillos
            menu.menuSeleccionado = self.menuSeleccionado
        }
        else if segue.identifier == "viralizacion"{
            let viral = segue.destinationViewController as!  ViralizacionTableViewController
            viral.viralizacionSeleccionada = self.menuSeleccionado
        }else if segue.identifier == "buscador"{
            
            
            // Create the search results view controller and use it for the `UISearchController`.
            //let destinationNavigationController = segue.destinationViewController as! UINavigationController
            //let searchResultsController = destinationNavigationController.topViewController as!  SearchResultsViewController
            
            let searchResultsController = segue.destinationViewController as!  SearchResultsViewController
            searchResultsController.parent = self
            // Create the search controller and make it perform the results updating.
            searchController = UISearchController(searchResultsController: searchResultsController)
            searchController.searchResultsUpdater = searchResultsController
            searchController.hidesNavigationBarDuringPresentation = false
            
            
            // Present the view controller.
            presentViewController(searchController, animated: true, completion: nil)

        }else if segue.identifier == "PlatilloSegueBuscador"{
            
            let receta = segue.destinationViewController as!  PlatillosViewController
            receta.imagenReceta = self.imagenBusqueda
            receta.objReceta = self.objBusqueda
            
          
        }
        
        
    }
    
    
    func loadCellInformation(imagenCell:UIImageView, numeroLabelView:UILabel, urlString:String, numeroRedecetas:Int, tipoMenuLabel:UILabel, nombreMenu:String, rowIndex:Int)
    {
        
        if self.imagesArray.count <= rowIndex {
            
            self.cargarImagenInternet(imagenCell, numeroLabelView: numeroLabelView, urlString:urlString, numeroRedecetas: numeroRedecetas , tipoMenuLabel: tipoMenuLabel, nombreMenu: nombreMenu, rowIndex:  rowIndex)
        }
        else{
        
            self.cargarImagenesMemoria(imagenCell, numeroLabelView: numeroLabelView, urlString:urlString, numeroRedecetas: numeroRedecetas , tipoMenuLabel: tipoMenuLabel, nombreMenu: nombreMenu, rowIndex:  rowIndex)
        }

        
    }
    
    func cargarImagenesMemoria(imagenCell:UIImageView, numeroLabelView:UILabel, urlString:String, numeroRedecetas:Int, tipoMenuLabel:UILabel, nombreMenu:String, rowIndex:Int){
        func display_image()
        {
            imagenCell.image = self.imagesArray[rowIndex]
            numeroLabelView.text = String(numeroRedecetas)+" recetas";
            tipoMenuLabel.text = nombreMenu
            
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                
                imagenCell.alpha = 100
                
                
                }, completion: nil)
            
            
        }
        
        dispatch_async(dispatch_get_main_queue(), display_image)

    }
    
    func cargarImagenInternet(imagenCell:UIImageView, numeroLabelView:UILabel, urlString:String, numeroRedecetas:Int, tipoMenuLabel:UILabel, nombreMenu:String, rowIndex:Int){
        
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
                    self.imagesArray[rowIndex]=imagenCell.image
                    numeroLabelView.text = String(numeroRedecetas)+" recetas";
                    tipoMenuLabel.text = nombreMenu
                    
                    UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        
                        imagenCell.alpha = 100
                        
                        
                        }, completion: nil)
                    
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
        }
        task.resume()

    }
    
    // para cuadrar las imagenes
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return pantallaSizeHeight();//Choose your custom row height
    }
    
    func pantallaSizeHeight()->CGFloat!
    {
        var strPantalla = CGFloat(224.0) //iphone 5
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        {
            strPantalla = UIScreen.mainScreen().bounds.size.height * CGFloat(0.47)
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
    
    
    // buscador
    
    
    
    func abrirBuscador(){
    
        self.performSegueWithIdentifier("buscador", sender: nil)
        
    }
    
    
    
    
    @IBAction func searchButtonClicked(button: UIBarButtonItem) {

        abrirBuscador()
    }

    

}

