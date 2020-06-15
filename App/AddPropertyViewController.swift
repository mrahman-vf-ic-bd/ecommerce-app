//
//  AddPropertyViewController.swift
//  App
//
//  Created by Siddiqur Rahmnan on 7/6/20.
//  Copyright © 2020 Siddiqur Rahmnan. All rights reserved.
//

import UIKit

class AddPropertyViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var referenceCodeTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var advertismentTypeTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var propertyTypeTextField: UITextField!
    @IBOutlet weak var balconySizeTextField: UITextField!
    @IBOutlet weak var roomsTextField: UITextField!
    @IBOutlet weak var bathroomsTextField: UITextField!
    @IBOutlet weak var propertySizeTextField: UITextField!

    @IBOutlet weak var parkingTextField: UITextField!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var availableFromTextField: UITextField!
    @IBOutlet weak var buildYearTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
 
    
    // Switch
    @IBOutlet weak var titleDeedSwitch: UISwitch!
    @IBOutlet weak var centralHeatingSwitch: UISwitch!
    @IBOutlet weak var solarWaterHeatingSwitch: UISwitch!
    @IBOutlet weak var storeRoomSwitch: UISwitch!
    @IBOutlet weak var airConditionerSwitch: UISwitch!
    @IBOutlet weak var furnishedSwitch: UISwitch!
    
    var user: FUser?
    var titleDeedSwitchValue = false
    var centralHeatingSwitchValue = false
    var solarWaterHeatingSwitchValue = false
    var storeRoomSwitchValue = false
    var airConditionerSwitchValue = false
    var furnishedSwitchValue = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: topView.frame.size.height)
        
    }
    
    // MARK: IBActions
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        user = FUser.currentUser()!
        if !user!.isAgent {
            // check if user can post
             save()
        } else {
            save()
        }
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
    }
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
    }
    @IBAction func pinMapButtonPressed(_ sender: UIButton) {
    }
    
    // MARK: Helper functions
    func save() {
        if titleTextField.text != "" && referenceCodeTextField.text != "" && advertismentTypeTextField.text != "" && propertyTypeTextField.text != "" && priceTextField.text != "" {
            //create property
            var newProperty = Property()
            newProperty.referenceCode = referenceCodeTextField.text!
            newProperty.ownerId = user!.objectId
            newProperty.title = titleTextField.text!
            newProperty.advertisementType = advertismentTypeTextField.text!
            newProperty.price = Int(priceTextField.text!)!
            newProperty.propertyType = propertyTypeTextField.text!
            
            if balconySizeTextField.text != "" {
                newProperty.balconySize = Double(balconySizeTextField.text!)!
            }
    
            if bathroomsTextField.text != "" {
                newProperty.numberofBathrooms = Int(bathroomsTextField.text!)!
            }
            
            if propertySizeTextField.text != "" {
                newProperty.size = Double(propertySizeTextField.text!)!
            }
            
            if parkingTextField.text != "" {
                newProperty.parking = Int(parkingTextField.text!)!
            }
            if floorTextField.text != "" {
                newProperty.floor = Int(floorTextField.text!)!
            }
            
            if addressTextField.text != "" {
                newProperty.address = addressTextField.text!
            }
            
            if cityTextField.text != "" {
                newProperty.city = cityTextField.text!
            }
            
            if countryTextField.text != "" {
                newProperty.country = countryTextField.text!
            }
            
            if availableFromTextField.text != "" {
                newProperty.availableForm = availableFromTextField.text!
            }
            
            if buildYearTextField.text != "" {
                newProperty.buildYear = buildYearTextField.text!
            }
            
            if descriptionTextView.text != "" && descriptionTextView.text != "Description"{
                newProperty.propertyDescription = descriptionTextView.text!
            }
            
            newProperty.titleDeeds = titleDeedSwitchValue
            newProperty.centralHeating = centralHeatingSwitchValue
            newProperty.solarWaterHeating = solarWaterHeatingSwitchValue
            newProperty.airConditioner = airConditionerSwitchValue
            newProperty.storeRoom = storeRoomSwitchValue
            newProperty.isFurnished = furnishedSwitchValue
            
            //Check for property images
            
            newProperty.saveProperty()
            ProgressHUD.showSuccess("Saved!")
        } else {
            ProgressHUD.showError("Error: Missing required fields")
        }
    }
    
    //Switches
    @IBAction func titleDeedSwitch(_ sender: UISwitch) {
        titleDeedSwitchValue = !titleDeedSwitchValue
    }
    @IBAction func centralHeatingSwitch(_ sender: UISwitch) {
        centralHeatingSwitchValue = !centralHeatingSwitchValue
    }
    @IBAction func solarWaterSwitch(_ sender: UISwitch) {
        solarWaterHeatingSwitchValue = !solarWaterHeatingSwitchValue
    }
    @IBAction func storeRoomSwitch(_ sender: UISwitch) {
        storeRoomSwitchValue = !storeRoomSwitchValue
    }
    @IBAction func airConditionerSwitch(_ sender: UISwitch) {
        airConditionerSwitchValue = !airConditionerSwitchValue
    }
    @IBAction func furnishedSwitch(_ sender: UISwitch) {
        furnishedSwitchValue = !furnishedSwitchValue
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
