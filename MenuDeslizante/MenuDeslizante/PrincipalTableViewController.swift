//
//  NewsTableViewController.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 17/11/15.
//  Copyright © 2015 sergio ivan lopez monzon. All rights reserved.
//

import UIKit
import Parse

class PrincipalTableViewController: UITableViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    //Para decirnos cual es la opcion que corresponde a cada posicion del menu
    var itemsMenu = [PFObject]()
    var imagesArray = [Int:UIImage]()
    var menuSeleccionado:PFObject!
    //Para almacenar el numero de recetas de ese menú
    var numeroDeRecetasPorMenu = [PFObject:Int]()
    
    // `searchController` cuando el boton de busqueda es presionado
    var searchController: UISearchController!

    
    
    
    override func viewWillAppear(animated: Bool) {
        
        
        //Image Background Navigation Bar
        
        let navBackgroundImage:UIImage! = UIImage(named: "fondonav")
        
        let nav = self.navigationController?.navigationBar
        
        nav?.tintColor = UIColor.grayColor()
        
        nav!.setBackgroundImage(navBackgroundImage, forBarMetrics:.Default)
        
        
        let font = UIFont(name: "Avenir Next Demi Bold", size: 12)
        if let font = font {
            nav!.titleTextAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName:UIColor.redColor()]
        }
        
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "fondo"))
        

        
        
       
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

        self.menuSeleccionado = itemsMenu[indexPath.row]
        
        let goto=self.menuSeleccionado["TipoMenu"].lowercaseString

        if goto=="gratis" || goto=="pago"
        {
            self.performSegueWithIdentifier("recetarios", sender: nil)
        }
        else if goto=="viral"
        {
            self.performSegueWithIdentifier("viralizacion", sender: nil)
        }

    }

    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PrincipalTableViewCell
        
        
        cell.lNumeroRecetas.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2*0.44))
        
        let item = self.itemsMenu[indexPath.row]
        //ocultamos si es tipo menu viral el icono de postit
        if ((item["TipoMenu"] as? String)?.lowercaseString) == "viral"{
            cell.lNumeroRecetas.hidden = true
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
        var strPantalla = 224.0
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        {
            strPantalla = 500.0
        }
        else
        {
            
            if UIScreen.mainScreen().bounds.size.width > 320 {
                if UIScreen.mainScreen().scale == 3 {
                    strPantalla = 286.0
                }
                else{
                    strPantalla = 266.0
                }
            }
        }
        return CGFloat(strPantalla)
    }
    
    
    // buscador
    
    
    
    func abrirBuscador(){
        // Create the search results view controller and use it for the `UISearchController`.
        let searchResultsController = storyboard!.instantiateViewControllerWithIdentifier(SearchResultsViewController.StoryboardConstants.identifier) as! SearchResultsViewController
        
        // Create the search controller and make it perform the results updating.
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Present the view controller.
        presentViewController(searchController, animated: true, completion: nil)

    }
    
    
    
    
    @IBAction func searchButtonClicked(button: UIBarButtonItem) {

        abrirBuscador()
    }

    

}

