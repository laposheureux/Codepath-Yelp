//
//  FilterSelectableCell.swift
//  Yelp
//
//  Created by Aaron on 10/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class FilterSelectableCell: UITableViewCell {
    @IBOutlet var cellLabel: UILabel!
    
    var labelText: String! {
        didSet {
            cellLabel.text = labelText
        }
    }
}
