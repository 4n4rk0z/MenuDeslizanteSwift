//
//  SearchResultsViewController.swift
//  BuscadorSwift
//
//  Created by sergio ivan lopez monzon on 17/02/16.
//  Copyright © 2016 devworms. All rights reserved.
//

import UIKit

class SearchResultsViewController: SearchControllerBaseViewController, UISearchResultsUpdating {
    // MARK: Types
    
    struct StoryboardConstants {
        /**
         The identifier string that corresponds to the `SearchResultsViewController`'s
         view controller defined in the main storyboard.
         */
        static let identifier = "SearchResultsViewControllerStoryboardIdentifier"
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        /*
        `updateSearchResultsForSearchController(_:)` is called when the controller is
        being dismissed to allow those who are using the controller they are search
        as the results controller a chance to reset their state. No need to update
        anything if we're being dismissed.
        */
        guard searchController.active else { return }
        
        filterString = searchController.searchBar.text
    }
}
