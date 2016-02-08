//
//  ViralizacionTableViewController.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 21/11/15.
//  Copyright © 2015 sergio ivan lopez monzon. All rights reserved.
//

import UIKit

class ViralizacionTableViewController: UITableViewController {
    
    var popViewController : PopUpViewControllerViral!
    
    var tipoViralizacion: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.popViewController = storyboard!.instantiateViewControllerWithIdentifier("compartirpop") as! PopUpViewControllerViral
        self.popViewController.showInView( self.view, animated: true, scaleX: 0.72, scaleY: 0.72)
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
        return 6
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //self.performSegueWithIdentifier("viralizar", sender: nil)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ViralizacionTableCell
        
        if indexPath.row == 0 {
            cell.viralizacionImageView1.image = UIImage(named: "chatarra")
            
        } else if indexPath.row == 1{
            cell.viralizacionImageView1.image = UIImage(named: "arabe")
            
        }else if indexPath.row == 2{
            cell.viralizacionImageView1.image = UIImage(named: "chatarra")
            
        }else if indexPath.row == 3{
            cell.viralizacionImageView1.image = UIImage(named: "salchichas")
            
        }else if indexPath.row == 4{
            cell.viralizacionImageView1.image = UIImage(named: "carne")
            
        }else if indexPath.row == 5{
            cell.viralizacionImageView1.image = UIImage(named: "chatarra")
            
        }else{
            cell.viralizacionImageView1.image = UIImage(named: "arabe")
            
        }
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        
    }
    
    
}

