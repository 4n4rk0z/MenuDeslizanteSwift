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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllTags()
    }
    
    struct TableViewConstants {
        static let tableViewCellIdentifier = "Cell"
    }
    
    // MARK: Properties
   
    
    var allTags = [String:PFObject]()
    
    var allResults = [String]()
    
    
    
    
    lazy var visibleResults: [String] = self.allResults
    
    /// A `nil` / empty filter string means show all results. Otherwise, show only results containing the filter.
    var filterString: String? = nil {
        didSet {
            if filterString == nil || filterString!.isEmpty || self.allTags.count <= 0 {
                visibleResults = allResults
            }
            else {
                // Filter the results using a predicate based on the filter string.
                let filterPredicate = NSPredicate(format: "self contains[c] %@", argumentArray: [filterString!])
                visibleResults = allResults.filter { filterPredicate.evaluateWithObject($0) }
                
                
                
            }
            
            tableView.reloadData()
        }
    }
    
    func getAllTags(){
        let query = PFQuery(className: "Tags")
        query.includeKey("Receta")
        query.findObjectsInBackgroundWithBlock {
            (tags: [PFObject]?, error: NSError?) -> Void in
            // comments now contains the comments for myPost
            
            if error == nil {
                
                //Si hay un cliente recupera su clientID y sale del metodo
                if let _ = tags as [PFObject]? {

                    for tag in tags! {
                       self.allResults.append((tag["Tag"] as? String)!)
                       self.allTags[(tag["Tag"] as? String)!] = (tag.objectForKey("Receta") as? PFObject)
                       // sacamos la receta asociada a la busqueda
                        //self.crearImagenes(tag)
                    }
                }
            }
            else{
                    
                    
            }
        }
    

    }
    
    
    func crearImagenes(receta:PFObject, imageView:UIImageView){
        
        let objId = receta.objectId
        let urlImagen = receta["Url_Imagen"] as? String
        let imgURL: NSURL = NSURL(string: urlImagen!)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil){
                //let tagString = (tag["Tag"] as? String)!
                imageView.image =  UIImage(data: data!)
                
            }
        }
        task.resume()
        
    }

    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleResults.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(TableViewConstants.tableViewCellIdentifier, forIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if visibleResults.count >= 1{
            let keyString = self.visibleResults[indexPath.row]
            crearImagenes(self.allTags[keyString]!, imageView: cell.imageView!)
        }
        //cell.imageView?.image = self.allTags[self.visibleResults[indexPath.row]]
    }
}
