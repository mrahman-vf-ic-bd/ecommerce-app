//
//  Property.swift
//  App
//
//  Created by Siddiqur Rahmnan on 6/6/20.
//  Copyright © 2020 Siddiqur Rahmnan. All rights reserved.
//

import Foundation

@objcMembers
class Property: NSObject {
    var objectId: String?
    var referenceCode: String?
    var ownerId: String?
    var title: String?
    var numberOfRooms: Int = 0 // Backendless need default value for Int, Double type
    var numberofBathrooms: Int = 0
    var size: Double = 0.0
    var balconySize: Double = 0.0
    var parking: Int = 0
    var floor: Int = 0
    var address: String?
    var city: String?
    var country: String?
    var propertyDescription: String?
    var latitude: Double = 0.0
    var longitutde: Double = 0.0
    var advertisementType: String?
    var availableForm: String?
    var imageLinks: String? // should be text in the backendless, string is too short
    var buildYear: String?
    var price: Int = 0
    var propertyType: String?
    var titleDeeds: Bool = false
    var centralHeating: Bool = false
    var solarWaterHeating: Bool = false
    var airConditioner: Bool = false
    var storeRoom: Bool = false
    var isFurnished: Bool = false
    var isSold: Bool = false
    var inTopUntil: Date?
    
    
    //MARK: Save functions
    func saveProperty() {
        let datastore = backendless?.data.of(Property().ofClass())
        datastore!.save(self)
    }
    
    func saveProperty(completion: @escaping (_ value: String) -> Void) {
        let datastore = backendless?.data.of(Property().ofClass())
        datastore!.save(self, response: { (result) in
            completion("Success")
        }) { (fault: Fault?) in
            completion(fault!.message)
        }
    }
    
    //MARK: Delete functions
    func deleteProperty(property: Property) {
        let datastore = backendless?.data.of(Property().ofClass())
        datastore!.remove(property)
    }
    
    func deleteProperty(property: Property, completion: @escaping (_ value: String) -> Void) {
        let datastore = backendless?.data.of(Property().ofClass())
        datastore!.remove(property, response: { (result) in
            completion("Success")
        }) { (fault: Fault?) in
            completion(fault!.message)
        }
    }
    
    // MARK: Fetch data
    class func fetchRecentProperties(limitNumber: Int, completion: @escaping (_ properties: [Property?]) -> Void) {
        
        let queryBuilder = DataQueryBuilder()
        queryBuilder!.setSortBy(["inTopUntil DESC"])
        queryBuilder!.setPageSize(Int32(limitNumber))
        queryBuilder!.setOffset(0)
        
        let datastore = backendless?.data.of(Property().ofClass())
        datastore!.find(queryBuilder!, response: { (result) in
            completion(result as! [Property])
        }) { (falut: Fault?) in
            print("Error, couldn't get recent properties \(String(describing: falut!.message))")
            completion([])
        }
    }
    
    class func fetchAllProperties(completion: @escaping (_ properties: [Property?]) -> Void) {
         
         let datastore = backendless?.data.of(Property().ofClass())
         datastore!.find({ (result) in
             completion(result as! [Property])
         }) { (falut: Fault?) in
             print("Error, couldn't get recent properties \(String(describing: falut!.message))")
             completion([])
         }
     }
    
    class func fetchPropertiesWith(whereClause: String, completion: @escaping (_ properties: [Property?]) -> Void) {
         
         let queryBuilder = DataQueryBuilder()
         queryBuilder!.setSortBy(["inTopUntil DESC"])
         queryBuilder!.setWhereClause(whereClause)
         
         let datastore = backendless?.data.of(Property().ofClass())
         datastore!.find(queryBuilder!, response: { (result) in
             completion(result as! [Property])
         }) { (falut: Fault?) in
             print("Error, couldn't get recent properties \(String(describing: falut!.message))")
             completion([])
         }
     }
}
