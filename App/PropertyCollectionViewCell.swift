//
//  PropertyCollectionViewCell.swift
//  App
//
//  Created by Siddiqur Rahmnan on 6/6/20.
//  Copyright © 2020 Siddiqur Rahmnan. All rights reserved.
//

import UIKit

@objc protocol PropertyCollectionViewCellDelegate {
    @objc optional func didClickStarButton(property: Property)
    @objc optional func didClickMenuButton(property: Property)
}

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
    
    var delegate: PropertyCollectionViewCellDelegate?
    
    var property: Property!
    
    func generateCell(property: Property) {
        titleLabel.text = property.title
        roomLabel.text = "\(property.numberOfRooms)"
        bathroomLabel.text = "\(property.numberofBathrooms)"
        parkingLabel.text = "\(property.parking)"
        priceLabel.text = "\(property.price)"
        priceLabel.sizeToFit()
        
        self.property = property
        
        if property.isSold {
            self.soldImageView.isHidden = false
        } else {
            self.soldImageView.isHidden = true
        }
        
        if property.inTopUntil != nil && property.inTopUntil! > Date() {
            self.topAdImageView.isHidden = false
        } else {
            self.topAdImageView.isHidden = true
        }
        
        if self.likeButtonOutlet != nil {
            if FUser.currentUser() != nil && FUser.currentUser()!.favariteProperties.contains(property.objectId!) {
                self.likeButtonOutlet.setImage(UIImage(named: "starFilled"), for: .normal)
            } else {
                self.likeButtonOutlet.setImage(UIImage(named: "star"), for: .normal)
            }
        }
        
        if property.imageLinks != "" && property.imageLinks != nil {
            // Download image
        } else {
            self.imageView.image = UIImage(named: "propertyPlaceholder")
            self.loadingIndicatorView.stopAnimating()
            self.loadingIndicatorView.isHidden = true
        }
    }
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        delegate!.didClickStarButton?(property: self.property)
    }
}
