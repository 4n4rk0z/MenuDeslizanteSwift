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
    var recetaSeleccionada:PFObject!
    var imagenRecetaSeleccionada: UIImage!
    var popViewController : PopUpViewControllerSwift!
    var planId = "prhhst3k5uucmunpl9fr"
    var precioPlan = 5.0
    var parent: PrincipalTableViewController!
    
    
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
    
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //cell.imageView?.image = self.allTags[self.visibleResults[indexPath.row]]
     
    }
    
  
    
}
