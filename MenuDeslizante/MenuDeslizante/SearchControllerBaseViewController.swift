//
//  SearchControllerBaseViewController.swift
//  BuscadorSwift
//
//  Created by sergio ivan lopez monzon on 17/02/16.
//  Copyright © 2016 devworms. All rights reserved.
//


import UIKit

class SearchControllerBaseViewController: UITableViewController {
    // MARK: Types
    
    struct TableViewConstants {
        static let tableViewCellIdentifier = "Cell"
    }
    
    // MARK: Properties
    
    /*let allResults = ["Here's", "to", "the", "crazy", "ones.", "The", "misfits.", "The", "rebels.", "The", "troublemakers.", "The", "round", "pegs", "in", "the", "square", "holes.", "The", "ones", "who", "see", "things", "differently.", "They're", "not", "fond", "of", "rules.", "And", "they", "have", "no", "respect", "for", "the", "status", "quo.", "You", "can", "quote", "them,", "disagree", "with", "them,", "glorify", "or", "vilify", "them.", "About", "the", "only", "thing", "you", "can't", "do", "is", "ignore", "them.", "Because", "they", "change", "things.", "They", "push", "the", "human", "race", "forward.", "And", "while", "some", "may", "see", "them", "as", "the", "crazy", "ones,", "we", "see", "genius.", "Because", "the", "people", "who", "are", "crazy", "enough", "to", "think", "they", "can", "change", "the", "world,", "are", "the", "ones", "who", "do."]
    
    lazy var visibleResults: [String] = self.allResults
    */
    /// A `nil` / empty filter string means show all results. Otherwise, show only results containing the filter.
    /*var filterString: String? = nil {
      /*  didSet {
            if filterString == nil || filterString!.isEmpty {
                visibleResults = allResults
            }
            else {
                // Filter the results using a predicate based on the filter string.
                let filterPredicate = NSPredicate(format: "self contains[c] %@", argumentArray: [filterString!])
                
                visibleResults = allResults.filter { filterPredicate.evaluateWithObject($0) }
            }
            
            tableView.reloadData()
        }*/
    }*/
    
    // MARK: UITableViewDataSource
    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleResults.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(TableViewConstants.tableViewCellIdentifier, forIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.textLabel!.text = visibleResults[indexPath.row]
    }*/
}
