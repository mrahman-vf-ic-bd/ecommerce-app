//
//  RecentViewController.swift
//  App
//
//  Created by Siddiqur Rahmnan on 5/6/20.
//  Copyright © 2020 Siddiqur Rahmnan. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    var properties: [Property] = []
    
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
        return 1 //properties.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PropertyCollectionViewCell
        
//        let property = properties[indexPath.row]
//        cell.generateCell(property: property)
        
        return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(254))
    }
    
    //MARK: Load Properties
    
    func loadProperties(limitNumber: Int) {
        Property.fetchRecentProperties(limitNumber: limitNumber) { (allProperties) in
            if allProperties.count != 0 {
                self.properties = allProperties as! [Property]
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: IBActions
    @IBAction func mixerButtonPressed(_ sender: UIButton) {
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
