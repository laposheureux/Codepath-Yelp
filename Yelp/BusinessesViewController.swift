//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import SVProgressHUD

class BusinessesViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var businesses: [Business] = []
    var filtersState: FiltersState?
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 98
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        
        let searchBar: UISearchBar = UISearchBar()
        searchBar.tintColor = UIColor.white
        searchBar.placeholder = "Restaurants"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        definesPresentationContext = true
    }
    
    func searchWithTerm(term: String) {
        SVProgressHUD.show()
        if let filtersState = filtersState {
            Business.searchWithTerm(term: term, sort: filtersState.sort, categories: filtersState.categories, deals: filtersState.deals, distance: filtersState.distance, completion: { [weak self] (businesses: [Business]?, error: Error?) -> Void in
                if let businesses = businesses {
                    SVProgressHUD.dismiss()
                    self?.businesses = businesses
                } else if let error = error {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    self?.businesses.removeAll()
                }
                
                self?.tableView.reloadData()
            })
        } else {
            Business.searchWithTerm(term: term, completion: { [weak self] (businesses: [Business]?, error: Error?) -> Void in
                if let businesses = businesses {
                    SVProgressHUD.dismiss()
                    self?.businesses = businesses
                } else if let error = error {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    self?.businesses.removeAll()
                }
                
                self?.tableView.reloadData()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let fvc = segue.destination as! FiltersViewController
        fvc.delegate = self
        
        if let filtersState = filtersState {
            fvc.existingFiltersState = filtersState
        }
    }
    
}

extension BusinessesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessTableViewCell") as! BusinessTableViewCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let term = searchBar.text {
            searchWithTerm(term: term)
            searchBar.resignFirstResponder()
        }
    }
}

extension BusinessesViewController: FiltersDelegate {
    func filtersData(didChangeValue value: FiltersState) {
        filtersState = value
        
        if let term = (navigationItem.titleView as? UISearchBar)?.text {
            searchWithTerm(term: term)
        }
    }
}
