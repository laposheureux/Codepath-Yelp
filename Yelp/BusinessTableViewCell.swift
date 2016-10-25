//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Aaron on 10/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var ratingImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var reviewCountLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var categoriesLabel: UILabel!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            addressLabel.text = business.address
            categoriesLabel.text = business.categories
            distanceLabel.text = business.distance
            
            if let reviewCount = business.reviewCount {
                let reviewCountSuffix = reviewCount != 1 ? "s" : ""
                reviewCountLabel.text = "\(reviewCount) Review\(reviewCountSuffix)"
            } else {
                reviewCountLabel.text = "0 Reviews"
            }
            
            if let imageURL = business.imageURL {
                restaurantImageView.setImageWith(imageURL)
            }
            
            if let ratingImageURL = business.ratingImageURL {
                ratingImageView.setImageWith(ratingImageURL)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        restaurantImageView.layer.cornerRadius = 4
        restaurantImageView.clipsToBounds = true
    }
}
