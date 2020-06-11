//
//  PropertyCollectionViewCell.swift
//  App
//
//  Created by Siddiqur Rahmnan on 6/6/20.
//  Copyright © 2020 Siddiqur Rahmnan. All rights reserved.
//

import UIKit

class PropertyCollectionViewCell: UICollectionViewCell {
    //MARK: Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var bathroomLabel: UILabel!
    @IBOutlet weak var parkingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var topAdImageView: UIImageView!
    @IBOutlet weak var soldImageView: UIImageView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    
    func generateCell(property: Property) {
        titleLabel.text = property.title
        roomLabel.text = "\(property.numberOfRooms)"
        bathroomLabel.text = "\(property.numberofBathrooms)"
        parkingLabel.text = "\(property.parking)"
        priceLabel.text = "\(property.price)"
        priceLabel.sizeToFit()
    }
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
    }
}
