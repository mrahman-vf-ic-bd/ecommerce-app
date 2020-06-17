//
//  RecentViewController.swift
//  App
//
//  Created by Siddiqur Rahmnan on 5/6/20.
//  Copyright © 2020 Siddiqur Rahmnan. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PropertyCollectionViewCellDelegate {
    
    // MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    var properties: [Property] = []
    var numberOfPropertiesTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load properties
        self.loadProperties(limitNumber: kRECENTPROPERTYLIMIT)
    }
    
    override func viewWillLayoutSubviews() {
        print("Called viewWillLayoutSubviews")
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: CollectionView Data Soruce
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return properties.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PropertyCollectionViewCell
        
        let property = properties[indexPath.row]
        cell.delegate = self
        cell.generateCell(property: property)
        
        return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(254))
    }
    
    //MARK: Load Properties
    
    func loadProperties(limitNumber: Int) {
        print("Called load property")
        Property.fetchRecentProperties(limitNumber: limitNumber) { (allProperties) in
            if allProperties.count != 0 {
                self.properties = allProperties as! [Property]
                self.collectionView.reloadData()
                print(self.properties[0].referenceCode)
            } else {
                print("No property")
            }
        }
    }
    
    // MARK: IBActions
    @IBAction func mixerButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Update", message: "Set the number of properties to display", preferredStyle: .alert)
        
        alertController.addTextField { (numberOfProperties) in
            numberOfProperties.placeholder = "Number of Properties"
            numberOfProperties.borderStyle = .roundedRect
            numberOfProperties.keyboardType = .numberPad
            self.numberOfPropertiesTextField = numberOfProperties
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        let updateAction = UIAlertAction(title: "Update", style: .default) { (action) in
            if self.numberOfPropertiesTextField!.text != "" && self.numberOfPropertiesTextField!.text != "0" {
                 ProgressHUD.show("Updating...")
                self.loadProperties(limitNumber: Int(self.numberOfPropertiesTextField.text!)!)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(updateAction)
        self.present(alertController, animated: true, completion: nil)
    }
    //MARK: - PropertyCollectionViewCellDelegate
    func didClickStarButton(property: Property) {
        // check if we have a user
        if FUser.currentUser() != nil {
            let user = FUser.currentUser()!
            //check if the property is in favorite
            if user.favariteProperties.contains(property.objectId!) {
                //Remove from favorite list
                let index = user.favariteProperties.index(of: property.objectId!)
                user.favariteProperties.remove(at: index!)
                
                updateCurrentUser(withValues: [kFAVORIT : user.favariteProperties]) { (success) in
                    if !success {
                        print("Error removing favorite")
                    } else {
                        self.collectionView.reloadData()
                        ProgressHUD.showSuccess("Removed from the list")
                    }
                }
            } else {
                // add to favorite list
                user.favariteProperties.append(property.objectId!)
                updateCurrentUser(withValues: [kFAVORIT : user.favariteProperties]) { (success) in
                    if !success {
                        print("Error adding favorite")
                    } else {
                        self.collectionView.reloadData()
                        ProgressHUD.showSuccess("Added to the list")
                    }
                }
            }
        } else {
            // show login/register screen
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
