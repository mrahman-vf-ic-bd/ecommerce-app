//
//  AddPropertyViewController.swift
//  App
//
//  Created by Siddiqur Rahmnan on 7/6/20.
//  Copyright © 2020 Siddiqur Rahmnan. All rights reserved.
//

import UIKit
import ImagePicker

class AddPropertyViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, ImagePickerDelegate {

    var yearArray: [Int] = []
    var datePicker = UIDatePicker()
    var propertyTypePicker = UIPickerView()
    var advertisementTypePicker = UIPickerView()
    var yearPicker = UIPickerView()
    var locationManager: CLLocationManager?
    var locationCoordinates: CLLocationCoordinate2D?
    
    var activeField: UITextField?
    
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
    
    var propertyImages: [UIImage] = []
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManagerStop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupYearArray()
        self.setupPickers()
        datePicker.addTarget(self, action: #selector(self.dataChanged(_:)), for: .valueChanged)
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
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = kMAXIMUMIMAGENUMBER
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        locationMangerManagerStart()
    }
    @IBAction func pinMapButtonPressed(_ sender: UIButton) {
        // show map so the user can pic a location
    }
    
    // MARK: Helper functions
    
    func setupYearArray() {
        for i in 1980...2030 {
            self.yearArray.append(i)
        }
        self.yearArray.reverse()
    }
    
    func save() {
        if titleTextField.text != "" && referenceCodeTextField.text != "" && advertismentTypeTextField.text != "" && propertyTypeTextField.text != "" && priceTextField.text != "" {
            
            ProgressHUD.show("Saving...")
            
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
            
             if roomsTextField.text != "" {
                 newProperty.numberOfRooms = Int(roomsTextField.text!)!
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
            
            if let currentCoordinate = locationCoordinates {
                newProperty.latitude = currentCoordinate.latitude
                newProperty.longitutde = currentCoordinate.longitude
            }
            
            newProperty.titleDeeds = titleDeedSwitchValue
            newProperty.centralHeating = centralHeatingSwitchValue
            newProperty.solarWaterHeating = solarWaterHeatingSwitchValue
            newProperty.airConditioner = airConditionerSwitchValue
            newProperty.storeRoom = storeRoomSwitchValue
            newProperty.isFurnished = furnishedSwitchValue
            
            //Check for property images
            if propertyImages.count != 0 {
                // upload image to firebase
                uploadImages(images: propertyImages, userId: user!.objectId, referenceNumber: newProperty.referenceCode!) { (linkString) in
                    newProperty.imageLinks = linkString
                    print("inside save-> " + linkString)
                    newProperty.saveProperty()
                    ProgressHUD.showSuccess("Saved!")
                    self.dismissView()
                }
            } else {
                newProperty.saveProperty()
                ProgressHUD.showSuccess("Saved!")
                self.dismissView()
            }

        } else {
            ProgressHUD.showError("Error: Missing required fields")
        }
    }

    func dismissView() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainVC") as! UITabBarController
        vc.modalPresentationStyle = .currentContext
        self.present(vc, animated: true, completion: nil)
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
    
    
    //MARK: ImagePickerDelegate
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("Wrapper")
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
         print("Done")
        self.propertyImages = images
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
         print("Cancel")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: PickerView
    @objc func dataChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: sender.date)
        
        self.availableFromTextField.text = "\(components.day!)/\(components.month!)/\(components.year!)"
    }
    
    func setupPickers() {
        yearPicker.delegate = self
        propertyTypePicker.delegate = self
        advertisementTypePicker.delegate = self
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let fexibalebar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonPressed))
        
        toolbar.setItems([fexibalebar, doneButton], animated: true)
        buildYearTextField.inputAccessoryView = toolbar
        buildYearTextField.inputView = yearPicker
        
        availableFromTextField.inputAccessoryView = toolbar
        availableFromTextField.inputView = datePicker
        
        propertyTypeTextField.inputAccessoryView = toolbar
        propertyTypeTextField.inputView = propertyTypePicker
        
        advertismentTypeTextField.inputAccessoryView = toolbar
        advertismentTypeTextField.inputView = advertisementTypePicker
        
    }
    
    @objc func doneButtonPressed() {
        self.view.endEditing(true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == propertyTypePicker {
            return propertyTypes.count
        }
        if pickerView == advertisementTypePicker {
            return advertismentTypes.count
        }
        if pickerView == yearPicker {
            return yearArray.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == propertyTypePicker {
            return propertyTypes[row]
        }
        if pickerView == advertisementTypePicker {
            return advertismentTypes[row]
        }
        if pickerView == yearPicker {
            return "\(yearArray[row])"
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var rowValue = row
        
        if pickerView == propertyTypePicker {
            if rowValue == 0 {
                rowValue = 1
            }
            propertyTypeTextField.text = propertyTypes[rowValue]
        }
        if pickerView == advertisementTypePicker {
            if rowValue == 0 {
                rowValue = 1
            }
            advertismentTypeTextField.text = advertismentTypes[rowValue]
        }
        if pickerView == yearPicker {
            buildYearTextField.text = "\(yearArray[row])"
        }
        
    }

    //MARK: Location Manager
    func locationMangerManagerStart() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.requestWhenInUseAuthorization()
        }
        locationManager?.startUpdatingLocation()
    }
    
    func locationManagerStop() {
        if locationManager != nil {
            locationManager?.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get the location")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .restricted:
            // case like partial control
            break
        case .denied:
            self.locationManager = nil
            ProgressHUD.showError("Please enable location from the settings")
            print("Location denied")
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("(\(locations.last!.coordinate.latitude), \(locations.last!.coordinate.longitude))")
        self.locationCoordinates = locations.last!.coordinate
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
