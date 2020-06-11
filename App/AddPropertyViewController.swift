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
    @IBOutlet weak var roomsTextField: UITextField!
    @IBOutlet weak var bathroomsTextField: UITextField!
    @IBOutlet weak var propertySizeTextField: UITextField!
    @IBOutlet weak var balconySizeTextField: UITextField!
    @IBOutlet weak var parkingTextField: UITextField!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var advertismentTypeTextField: UITextField!
    @IBOutlet weak var availableFromTextField: UITextField!
    @IBOutlet weak var buildYearTextField: UITextField!
    @IBOutlet weak var propertyTypeTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    
    // Switch
    @IBOutlet weak var titleDeedSwitch: UISwitch!
    @IBOutlet weak var centralHeatingSwitch: UISwitch!
    @IBOutlet weak var solarWaterHeatingSwitch: UISwitch!
    @IBOutlet weak var storeRoomSwitch: UISwitch!
    @IBOutlet weak var airConditionerSwitch: UISwitch!
    @IBOutlet weak var furnishedSwitch: UISwitch!
    
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
    }
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
    }
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
    }
    @IBAction func pinMapButtonPressed(_ sender: UIButton) {
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
