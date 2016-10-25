//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var businesses: [Business] = []
    var filteredBusinesses: [Business] = []
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 98
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        
        definesPresentationContext = true
        
        Business.searchWithTerm(term: "Thai", completion: { [weak self] (businesses: [Business]?, error: Error?) -> Void in
            if let businesses = businesses {
                self?.businesses = businesses
                self?.filteredBusinesses = businesses
                
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            } else {
                self?.businesses.removeAll()
            }
            
            self?.tableView.reloadData()
        })
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension BusinessesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBusinesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessTableViewCell") as! BusinessTableViewCell
        
        cell.business = filteredBusinesses[indexPath.row]
        
        return cell
    }
}

extension BusinessesViewController: UITableViewDelegate {
    
}

extension BusinessesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredBusinesses = searchText.isEmpty ? businesses : businesses.filter({(business: Business) -> Bool in
                guard let businessName = business.name else { return false }
                
                return businessName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            
            tableView.reloadData()
        }
    }
}
