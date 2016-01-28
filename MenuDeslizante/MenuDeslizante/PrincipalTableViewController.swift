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
    var menuSeleccionado:PFObject!
    //Para almacenar el numero de recetas de ese menú
    var numeroDeRecetasPorMenu = [PFObject:Int]()
    
    
    
    
    override func viewWillAppear(animated: Bool) {
       
        // cargamos las imagenes
            let query = PFQuery(className: "Menus")
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
       
       /* else if goto=="viralizacion"
        {
            self.performSegueWithIdentifier("viralizacion", sender: nil)
        }*/

    }

    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PrincipalTableViewCell

        let item = self.itemsMenu[indexPath.row]
        self.loadCellInformation(cell.postImageView!, numeroBtnView: cell.numeroBtnView, urlString: (item["Url_Imagen"] as? String)!, numeroRedecetas:  self.numeroDeRecetasPorMenu[item]!, tipoMenuLabel: cell.nombreLabelMenu, nombreMenu: (item["NombreMenu"] as? String)!)
        
      
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "recetarios"{
            let menu = segue.destinationViewController as!  MenuPlatillos
            menu.menuSeleccionado = self.menuSeleccionado
        }
    }
    
    
    func loadCellInformation(imagenCell:UIImageView, numeroBtnView:UIButton, urlString:String, numeroRedecetas:Int, tipoMenuLabel:UILabel, nombreMenu:String)
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
                    numeroBtnView.setTitle(String(numeroRedecetas), forState: UIControlState.Normal)
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
    
        

}

