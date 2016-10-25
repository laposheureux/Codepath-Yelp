//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Aaron on 10/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

struct FiltersState {
    var deals: Bool
    var distance: DistanceFilter
    var sort: YelpSortMode
    var categories: [String]
}

protocol FiltersDelegate: class {
    func filtersData(didChangeValue value: FiltersState)
}

enum DistanceFilter: Double, CustomStringConvertible {
    case auto = 0
    case threeTenthsMile = 0.3
    case oneMile = 1
    case fiveMiles = 5
    case twentyMiles = 20
    
    var description: String {
        switch self {
        case .auto:
            return "Auto"
        case .threeTenthsMile:
            return "0.3 miles"
        case .oneMile:
            return "1 mile"
        case .fiveMiles:
            return "5 miles"
        case .twentyMiles:
            return "20 miles"
        }
    }
}

extension YelpSortMode: CustomStringConvertible {
    var description: String {
        switch self {
        case .bestMatched:
            return "Best Matched"
        case .distance:
            return "Distance"
        case .highestRated:
            return "Highest Rated"
        }
    }
}

class FiltersViewController: UIViewController {
    let sectionTitles: [String] = ["Deals", "Distance", "Sort By", "Category"]
    let dealsData: String = "Offering a Deal"
    var dealsState: Bool!
    let distanceData: [DistanceFilter] = [.auto, .threeTenthsMile, .oneMile, .fiveMiles, .twentyMiles]
    var distanceState: Int!
    let sortData: [YelpSortMode] = [.bestMatched, .distance, .highestRated]
    var sortState: Int!
    let categoriesData: [[String: String]] = [["name" : "Afghan", "code": "afghani"],
                                              ["name" : "African", "code": "african"],
                                              ["name" : "American, New", "code": "newamerican"],
                                              ["name" : "American, Traditional", "code": "tradamerican"],
                                              ["name" : "Arabian", "code": "arabian"],
                                              ["name" : "Argentine", "code": "argentine"],
                                              ["name" : "Armenian", "code": "armenian"],
                                              ["name" : "Asian Fusion", "code": "asianfusion"],
                                              ["name" : "Asturian", "code": "asturian"],
                                              ["name" : "Australian", "code": "australian"],
                                              ["name" : "Austrian", "code": "austrian"],
                                              ["name" : "Baguettes", "code": "baguettes"],
                                              ["name" : "Bangladeshi", "code": "bangladeshi"],
                                              ["name" : "Barbeque", "code": "bbq"],
                                              ["name" : "Basque", "code": "basque"],
                                              ["name" : "Bavarian", "code": "bavarian"],
                                              ["name" : "Beer Garden", "code": "beergarden"],
                                              ["name" : "Beer Hall", "code": "beerhall"],
                                              ["name" : "Beisl", "code": "beisl"],
                                              ["name" : "Belgian", "code": "belgian"],
                                              ["name" : "Bistros", "code": "bistros"],
                                              ["name" : "Black Sea", "code": "blacksea"],
                                              ["name" : "Brasseries", "code": "brasseries"],
                                              ["name" : "Brazilian", "code": "brazilian"],
                                              ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                                              ["name" : "British", "code": "british"],
                                              ["name" : "Buffets", "code": "buffets"],
                                              ["name" : "Bulgarian", "code": "bulgarian"],
                                              ["name" : "Burgers", "code": "burgers"],
                                              ["name" : "Burmese", "code": "burmese"],
                                              ["name" : "Cafes", "code": "cafes"],
                                              ["name" : "Cafeteria", "code": "cafeteria"],
                                              ["name" : "Cajun/Creole", "code": "cajun"],
                                              ["name" : "Cambodian", "code": "cambodian"],
                                              ["name" : "Canadian", "code": "New)"],
                                              ["name" : "Canteen", "code": "canteen"],
                                              ["name" : "Caribbean", "code": "caribbean"],
                                              ["name" : "Catalan", "code": "catalan"],
                                              ["name" : "Chech", "code": "chech"],
                                              ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                                              ["name" : "Chicken Shop", "code": "chickenshop"],
                                              ["name" : "Chicken Wings", "code": "chicken_wings"],
                                              ["name" : "Chilean", "code": "chilean"],
                                              ["name" : "Chinese", "code": "chinese"],
                                              ["name" : "Comfort Food", "code": "comfortfood"],
                                              ["name" : "Corsican", "code": "corsican"],
                                              ["name" : "Creperies", "code": "creperies"],
                                              ["name" : "Cuban", "code": "cuban"],
                                              ["name" : "Curry Sausage", "code": "currysausage"],
                                              ["name" : "Cypriot", "code": "cypriot"],
                                              ["name" : "Czech", "code": "czech"],
                                              ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                                              ["name" : "Danish", "code": "danish"],
                                              ["name" : "Delis", "code": "delis"],
                                              ["name" : "Diners", "code": "diners"],
                                              ["name" : "Dumplings", "code": "dumplings"],
                                              ["name" : "Eastern European", "code": "eastern_european"],
                                              ["name" : "Ethiopian", "code": "ethiopian"],
                                              ["name" : "Fast Food", "code": "hotdogs"],
                                              ["name" : "Filipino", "code": "filipino"],
                                              ["name" : "Fish & Chips", "code": "fishnchips"],
                                              ["name" : "Fondue", "code": "fondue"],
                                              ["name" : "Food Court", "code": "food_court"],
                                              ["name" : "Food Stands", "code": "foodstands"],
                                              ["name" : "French", "code": "french"],
                                              ["name" : "French Southwest", "code": "sud_ouest"],
                                              ["name" : "Galician", "code": "galician"],
                                              ["name" : "Gastropubs", "code": "gastropubs"],
                                              ["name" : "Georgian", "code": "georgian"],
                                              ["name" : "German", "code": "german"],
                                              ["name" : "Giblets", "code": "giblets"],
                                              ["name" : "Gluten-Free", "code": "gluten_free"],
                                              ["name" : "Greek", "code": "greek"],
                                              ["name" : "Halal", "code": "halal"],
                                              ["name" : "Hawaiian", "code": "hawaiian"],
                                              ["name" : "Heuriger", "code": "heuriger"],
                                              ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                                              ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                                              ["name" : "Hot Dogs", "code": "hotdog"],
                                              ["name" : "Hot Pot", "code": "hotpot"],
                                              ["name" : "Hungarian", "code": "hungarian"],
                                              ["name" : "Iberian", "code": "iberian"],
                                              ["name" : "Indian", "code": "indpak"],
                                              ["name" : "Indonesian", "code": "indonesian"],
                                              ["name" : "International", "code": "international"],
                                              ["name" : "Irish", "code": "irish"],
                                              ["name" : "Island Pub", "code": "island_pub"],
                                              ["name" : "Israeli", "code": "israeli"],
                                              ["name" : "Italian", "code": "italian"],
                                              ["name" : "Japanese", "code": "japanese"],
                                              ["name" : "Jewish", "code": "jewish"],
                                              ["name" : "Kebab", "code": "kebab"],
                                              ["name" : "Korean", "code": "korean"],
                                              ["name" : "Kosher", "code": "kosher"],
                                              ["name" : "Kurdish", "code": "kurdish"],
                                              ["name" : "Laos", "code": "laos"],
                                              ["name" : "Laotian", "code": "laotian"],
                                              ["name" : "Latin American", "code": "latin"],
                                              ["name" : "Live/Raw Food", "code": "raw_food"],
                                              ["name" : "Lyonnais", "code": "lyonnais"],
                                              ["name" : "Malaysian", "code": "malaysian"],
                                              ["name" : "Meatballs", "code": "meatballs"],
                                              ["name" : "Mediterranean", "code": "mediterranean"],
                                              ["name" : "Mexican", "code": "mexican"],
                                              ["name" : "Middle Eastern", "code": "mideastern"],
                                              ["name" : "Milk Bars", "code": "milkbars"],
                                              ["name" : "Modern Australian", "code": "modern_australian"],
                                              ["name" : "Modern European", "code": "modern_european"],
                                              ["name" : "Mongolian", "code": "mongolian"],
                                              ["name" : "Moroccan", "code": "moroccan"],
                                              ["name" : "New Zealand", "code": "newzealand"],
                                              ["name" : "Night Food", "code": "nightfood"],
                                              ["name" : "Norcinerie", "code": "norcinerie"],
                                              ["name" : "Open Sandwiches", "code": "opensandwiches"],
                                              ["name" : "Oriental", "code": "oriental"],
                                              ["name" : "Pakistani", "code": "pakistani"],
                                              ["name" : "Parent Cafes", "code": "eltern_cafes"],
                                              ["name" : "Parma", "code": "parma"],
                                              ["name" : "Persian/Iranian", "code": "persian"],
                                              ["name" : "Peruvian", "code": "peruvian"],
                                              ["name" : "Pita", "code": "pita"],
                                              ["name" : "Pizza", "code": "pizza"],
                                              ["name" : "Polish", "code": "polish"],
                                              ["name" : "Portuguese", "code": "portuguese"],
                                              ["name" : "Potatoes", "code": "potatoes"],
                                              ["name" : "Poutineries", "code": "poutineries"],
                                              ["name" : "Pub Food", "code": "pubfood"],
                                              ["name" : "Rice", "code": "riceshop"],
                                              ["name" : "Romanian", "code": "romanian"],
                                              ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                                              ["name" : "Rumanian", "code": "rumanian"],
                                              ["name" : "Russian", "code": "russian"],
                                              ["name" : "Salad", "code": "salad"],
                                              ["name" : "Sandwiches", "code": "sandwiches"],
                                              ["name" : "Scandinavian", "code": "scandinavian"],
                                              ["name" : "Scottish", "code": "scottish"],
                                              ["name" : "Seafood", "code": "seafood"],
                                              ["name" : "Serbo Croatian", "code": "serbocroatian"],
                                              ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                                              ["name" : "Singaporean", "code": "singaporean"],
                                              ["name" : "Slovakian", "code": "slovakian"],
                                              ["name" : "Soul Food", "code": "soulfood"],
                                              ["name" : "Soup", "code": "soup"],
                                              ["name" : "Southern", "code": "southern"],
                                              ["name" : "Spanish", "code": "spanish"],
                                              ["name" : "Steakhouses", "code": "steak"],
                                              ["name" : "Sushi Bars", "code": "sushi"],
                                              ["name" : "Swabian", "code": "swabian"],
                                              ["name" : "Swedish", "code": "swedish"],
                                              ["name" : "Swiss Food", "code": "swissfood"],
                                              ["name" : "Tabernas", "code": "tabernas"],
                                              ["name" : "Taiwanese", "code": "taiwanese"],
                                              ["name" : "Tapas Bars", "code": "tapas"],
                                              ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                                              ["name" : "Tex-Mex", "code": "tex-mex"],
                                              ["name" : "Thai", "code": "thai"],
                                              ["name" : "Traditional Norwegian", "code": "norwegian"],
                                              ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                                              ["name" : "Trattorie", "code": "trattorie"],
                                              ["name" : "Turkish", "code": "turkish"],
                                              ["name" : "Ukrainian", "code": "ukrainian"],
                                              ["name" : "Uzbek", "code": "uzbek"],
                                              ["name" : "Vegan", "code": "vegan"],
                                              ["name" : "Vegetarian", "code": "vegetarian"],
                                              ["name" : "Venison", "code": "venison"],
                                              ["name" : "Vietnamese", "code": "vietnamese"],
                                              ["name" : "Wok", "code": "wok"],
                                              ["name" : "Wraps", "code": "wraps"],
                                              ["name" : "Yugoslav", "code": "yugoslav"]]
    var categoriesState: [Bool]!
    var existingFiltersState: FiltersState?
    var initiallySelectedIndexPaths: [IndexPath] = []
    
    weak var delegate: FiltersDelegate?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 46
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        
        // If we got existing state, process it, otherwise set defaults
        if let existingFiltersState = existingFiltersState {
            dealsState = existingFiltersState.deals
            distanceState = distanceData.index(of: existingFiltersState.distance)
            sortState = sortData.index(of: existingFiltersState.sort)
            var enabledCategories: [Bool] = []
            for category in categoriesData {
                if existingFiltersState.categories.index(of: category["code"]!) != nil {
                    enabledCategories.append(true)
                } else {
                    enabledCategories.append(false)
                }
            }
            categoriesState = enabledCategories
        } else  {
            dealsState = false
            distanceState = 0
            sortState = 0
            categoriesState = [Bool](repeating: false, count: categoriesData.count)
        }
        
        tableView.reloadData()
        
        (navigationItem.titleView as? UILabel)?.textColor = UIColor.white
    }
    
    @IBAction func onCancelFilter(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSearchFilter(_ sender: UIBarButtonItem) {
        var categories: [String] = []
        for index in 0..<categoriesState.count {
            if categoriesState[index] {
                categories.append(categoriesData[index]["code"]!)
            }
        }
        
        let filtersState = FiltersState(deals: dealsState, distance: distanceData[distanceState], sort: sortData[sortState], categories: categories)
        delegate?.filtersData(didChangeValue: filtersState)
        
        navigationController?.popViewController(animated: true)
    }
}

extension FiltersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return distanceData.count
        case 2:
            return sortData.count
        case 3:
            return categoriesData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterSwitchCell") as! FilterSwitchCell
        cell.delegate = self
        
        switch indexPath.section {
        case 0:
            cell.labelText = dealsData
            cell.isOn = dealsState
        case 1:
            cell.labelText = distanceData[indexPath.row].description
            cell.isOn = distanceState == indexPath.row
        case 2:
            cell.labelText = sortData[indexPath.row].description
            cell.isOn = sortState == indexPath.row
        case 3:
            cell.labelText = categoriesData[indexPath.row]["name"]
            cell.isOn = categoriesState[indexPath.row]
        default:
            break
        }
        
        return cell
    }
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            tableView.cellForRow(at: indexPath)?.isSelected = false
        case 1:
            distanceState = indexPath.row
        case 2:
            sortState = indexPath.row
        case 3:
            tableView.cellForRow(at: indexPath)?.isSelected = false
        default:
            break
        }
    }
}

extension FiltersViewController: FilterSwitchCellDelegate {
    func filterSwitchCell(filterSwitchCell: FilterSwitchCell, didChangeValue value: Bool) {
        let cellPath = tableView.indexPath(for: filterSwitchCell)!
        switch cellPath.section {
        case 0:
            dealsState = value
        case 1:
            distanceState = cellPath.row
            updateRowsInSection(section: cellPath.section)
        case 2:
            sortState = cellPath.row
            updateRowsInSection(section: cellPath.section)
        case 3:
            categoriesState[cellPath.row] = value
        default:
            break
        }
    }
    
    func updateRowsInSection(section: Int) {
        var rowsToUpdate: [IndexPath] = []
        for index in 0..<tableView.numberOfRows(inSection: section) {
            rowsToUpdate.append(IndexPath(row: index, section: section))
        }
        tableView.reloadRows(at: rowsToUpdate, with: .automatic)
    }
}
