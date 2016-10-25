//
//  FilterSwitchCell.swift
//  Yelp
//
//  Created by Aaron on 10/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterSwitchCellDelegate {
    @objc optional func filterSwitchCell(filterSwitchCell: FilterSwitchCell, didChangeValue value: Bool)
}

class FilterSwitchCell: UITableViewCell {
    @IBOutlet var cellLabel: UILabel!
    @IBOutlet var cellSwitch: UISwitch!
    
    weak var delegate: FilterSwitchCellDelegate?
    
    var labelText: String! {
        didSet {
            cellLabel.text = labelText
        }
    }
    
    var isOn: Bool! {
        didSet {
            cellSwitch.isOn = isOn
        }
    }
    
    override func awakeFromNib() {
        cellSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    func switchValueChanged() {
        delegate?.filterSwitchCell?(filterSwitchCell: self, didChangeValue: cellSwitch.isOn)
    }
}
