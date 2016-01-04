//
//  NewsTableViewController.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 17/11/15.
//  Copyright © 2015 sergio ivan lopez monzon. All rights reserved.
//

import UIKit

class PrincipalTableViewController: UITableViewController {
    var popViewController : PopUpViewControllerSwift!
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    //Para decirnos cual es la opcion que corresponde a cada posicion del menu, es un pseudo tag
    var menu = [String]();
    
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
        return 5
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let goto=menu[indexPath.row]

        if goto=="gratis"
        {
            self.performSegueWithIdentifier("gratis", sender: nil)

        }
        else if goto=="pago"
        {
            self.abrirVentanaPop(5.0,suscripcion:  true, planId:  "prhhst3k5uucmunpl9fr")
//            self.performSegueWithIdentifier("pago", sender: nil)
        }
        else if goto=="viralizacion"
        {
            self.performSegueWithIdentifier("viralizacion", sender: nil)
        }

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PrincipalTableViewCell
        
        
        if indexPath.row == 0 {
            cell.postImageView.image = UIImage(named: "comidag")
            menu.append("gratis")
            cell.numeroImageView.image = UIImage(named: "diez")
        } else if indexPath.row == 1{
            cell.postImageView.image = UIImage(named: "comidar")
            menu.append("pago");
            cell.numeroImageView.image = UIImage(named: "diez")
        }else if indexPath.row == 2{
            cell.postImageView.image = UIImage(named: "comidar")
            menu.append("pago");
            cell.numeroImageView.image = UIImage(named: "diez")
        }else if indexPath.row == 3{
            cell.postImageView.image = UIImage(named: "comidav")
            menu.append("viralizacion")
            cell.numeroImageView.image = UIImage(named: "diez")
        
        }else{
            cell.postImageView.image = UIImage(named: "comidar")
            menu.append("pago")
            cell.numeroImageView.image = UIImage(named: "diez")
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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

