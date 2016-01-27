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
    
    @IBOutlet weak var imagenViewMenuSeleccionado: UIImageView!
    
    @IBOutlet weak var labelMenuSeleccionado: UILabel!
    var popViewController : PopUpViewControllerSwift!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.loadCellInformation(imagenViewMenuSeleccionado, urlString: menuSeleccionado["Url_Imagen"] as! String, tipoMenuLabel: labelMenuSeleccionado, nombreMenu: menuSeleccionado["NombreMenu"] as! String)
    }
    
    func consultarRecetasDeMenu()
    {
        let query = PFQuery(className:"Recetas")
        query.whereKey("Menu", equalTo:self.menuSeleccionado)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId)
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
        return 4
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("PlatilloCell") as UITableViewCell!
   let cell = tableView.dequeueReusableCellWithIdentifier("PlatilloCell", forIndexPath: indexPath) as! MenuPlatillosTableViewCell
   /*
        
        if indexPath.row == 0 {
            cell.imagePropia.image = UIImage(named: "arabe")
        } else if indexPath.row == 1{
            cell.imagePropia.image = UIImage(named: "images")
        }else if indexPath.row == 2{
            cell.imagePropia.image = UIImage(named: "arabe")
        }else {
            cell.imagePropia.image = UIImage(named: "arabe")
        }
*/
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.menuSeleccionado["TipoMenu"].lowercaseString == "pago"{
            
            self.abrirVentanaPop(5.0,suscripcion:  true, planId:  "prhhst3k5uucmunpl9fr")
        }
        else
        {
            self.performSegueWithIdentifier("PlatilloSegue", sender: nil)
        }
    }
    
    
    func loadCellInformation(imagenCell:UIImageView, urlString:String, tipoMenuLabel:UILabel, nombreMenu:String)
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
                    imagenCell.image = UIImage(data: data!)
                    tipoMenuLabel.text = nombreMenu
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }

    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
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
