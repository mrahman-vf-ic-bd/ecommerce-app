//
//  FUser.swift
//  App
//
//  Created by Siddiqur Rahmnan on 31/5/20.
//  Copyright © 2020 Siddiqur Rahmnan. All rights reserved.
//

import Foundation
import Firebase

class FUser {
    let objectId: String
    var pushId: String?
    
    let createdAt: Date
    var updatedAt: Date
    
    var coins: Int
    var company: String
    var firstName: String
    var lastName: String
    var fullName: String
    var avatar: String
    var phoneNumber: String
    var additionalPhoneNumber: String
    var isAgent: Bool
    var favariteProperties: [String]
    
    init(objectId: String, pushId: String?, createdAt: Date, updatedDate: Date, firstName: String, lastName: String, avatar: String = "", phoneNumber: String = "") {
        self.objectId = objectId
        self.pushId = pushId
        self.createdAt = createdAt
        self.updatedAt = updatedDate
        self.firstName = firstName
        self.lastName = lastName
        self.avatar = avatar
        self.phoneNumber = phoneNumber
        self.coins = 10
        self.fullName = "\(firstName) \(lastName)"
        self.isAgent = false
        self.company = ""
        self.favariteProperties = []
        self.additionalPhoneNumber = ""
    }
    
    init(dictionary: NSDictionary) {
        self.objectId = dictionary[kOBJECTID] as! String
        self.pushId = dictionary[kPUSHID] as? String
        
        if let created = dictionary[kCREATEDAT] as? String {
            self.createdAt = dateFormatter().date(from: created) ?? Date()
        } else {
            self.createdAt = Date()
        }
        if let updated = dictionary[kUPDATEDAT] as? String {
            self.updatedAt = dateFormatter().date(from: updated) ?? Date()
        } else {
            self.updatedAt = Date()
        }
        
        if let coins = dictionary[kCONS] as? Int {
            self.coins = coins
        } else {
            coins = 0
        }
        
        if let comp = dictionary[kCOMPANY] as? String {
            self.company = comp
        } else {
            company = ""
        }
        
        if let firstName = dictionary[kFIRSTNAME] as? String {
            self.firstName = firstName
        } else {
            self.firstName = ""
        }
        
        if let lastName = dictionary[kLASTNAME] as? String {
            self.lastName = lastName
        } else {
            self.lastName = ""
        }
        fullName = "\(firstName) \(lastName)"
        if let avat = dictionary[kAVATAR] as? String {
            self.avatar = avat
        } else {
            self.avatar = ""
        }
        
        if let isAgent = dictionary[kISAGENT] as? Bool {
            self.isAgent = isAgent
        } else {
            self.isAgent = false
        }
        
        
        if let phone = dictionary[kPHONE] as? String {
            self.phoneNumber = phone
        } else {
            self.phoneNumber = ""
        }
        
        if let addphone = dictionary[kADDPHONE] as? String {
            self.additionalPhoneNumber = addphone
        } else {
            self.additionalPhoneNumber = ""
        }
        
        if let favProp = dictionary[kFAVORIT] as? [String] {
            self.favariteProperties = favProp
        } else {
            self.favariteProperties = []
        }
    }
    
    class func currentId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> FUser? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) as? NSDictionary {
                return FUser.init(dictionary: dictionary)
            }
        }
        
        return nil
    }
    
    class func registerUserWith(email: String, password: String, firstName: String, lastName: String, completion: @escaping(_ error: Error?)-> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) {
            (firUser, error) in
            print("\(error?.localizedDescription ?? " ")")
            if error != nil {
                completion(error)
                return
            }
        
            let firebaseUser = firUser!.user
            
            let fUser = FUser(objectId: firebaseUser.uid, pushId: "", createdAt: Date(), updatedDate: Date(), firstName: firstName, lastName: lastName)
            
            // Save to user defaults
            saveUserLocally(fUser: fUser)
            // Save user to firebase
            saveUserInBackground(fUser: fUser)
            
            completion(error)
        }
        
    }
    
    class func registerUserWith(phoneNumber: String, verificationCode: String, completion: @escaping (_ error: Error?, _ shouldLogin: Bool) -> Void) {
        let verificationID = UserDefaults.standard.value(forKey: kVARIFICATIONCODE)
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationID as! String, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credentials) {
            (firUser, error) in
            if error != nil {
                completion(error, false)
                return
            }
            let firebaseUser = firUser!.user
            
            // Check if user is logged in else register
            fetchUserWith(userId: firebaseUser.uid) { (user) in
                if user != nil && user!.firstName != "" {
                    // we have a user, login
                    saveUserLocally(fUser: user!)
                    completion(error, true)
                } else {
                    //we have no user, register user
                    let fUser = FUser(objectId: firebaseUser.uid, pushId: "", createdAt: Date(), updatedDate: Date(), firstName: "", lastName: "", phoneNumber: firebaseUser.phoneNumber!)
                    saveUserLocally(fUser: fUser)
                    saveUserInBackground(fUser: fUser)
                    completion(error, false)
                
                }
            }
        }
    }
    
}

//MARK: Saving user
func saveUserInBackground(fUser: FUser) {
    let ref = firebase.child(kUSER).child(fUser.objectId)
    ref.setValue(userDictionaryForm(user: fUser))
    print("Saved in Database")
}

func saveUserLocally(fUser: FUser) {
    UserDefaults.standard.setValue(userDictionaryForm(user: fUser), forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}

// MARK: Helper function

func fetchUserWith(userId: String, completion: @escaping (_ user: FUser?) -> Void) {
    firebase.child(kUSER).queryOrdered(byChild: kOBJECTID).queryEqual(toValue: userId).observeSingleEvent(of: .value) {
        (snapshot) in
        
        if snapshot.exists() {
            let userDictionary = ((snapshot.value as! NSDictionary).allValues as NSArray).firstObject! as! NSDictionary
            
            let user = FUser(dictionary: userDictionary)
            completion(user)
        } else {
            completion(nil)
        }
    }
}

func userDictionaryForm(user: FUser) -> NSDictionary {
    let createdAt = dateFormatter().string(from: user.createdAt)
    let updatedAt = dateFormatter().string(from: user.updatedAt)
    
    return NSDictionary(objects: [user.objectId, createdAt, updatedAt, user.company, user.pushId!, user.firstName, user.lastName, user.fullName, user.avatar, user.phoneNumber, user.additionalPhoneNumber, user.isAgent, user.coins, user.favariteProperties],
        
    forKeys: [kOBJECTID as NSCopying, kCREATEDAT as NSCopying, kUPDATEDAT as NSCopying, kCOMPANY as NSCopying, kPUSHID as NSCopying, kFIRSTNAME as NSCopying, kLASTNAME as NSCopying,
    kFULLNAME as NSCopying, kAVATAR as NSCopying, kPHONE as NSCopying, kADDPHONE as NSCopying, kISAGENT as NSCopying, kCONS as NSCopying, kFAVORIT as NSCopying])
}

func updateCurrentUser(withValues: [String: Any], withBlock: @escaping (_ success: Bool) -> Void) {
    if UserDefaults.standard.object(forKey: kCURRENTUSER) != nil {
        let currentUser = FUser.currentUser()!
        let userObject = userDictionaryForm(user: currentUser).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(withValues)
        
        let ref = firebase.child(kUSER).child(currentUser.objectId)
        ref.updateChildValues(withValues) { (error, ref) in
            if error != nil {
                withBlock(false)
                return
            }
            
            UserDefaults.standard.setValue(userObject, forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            withBlock(true)
        }
    }
}


//MARK: OneSignal

func updateOneSignalId() {
    if FUser.currentUser() != nil {
        if let pushId = UserDefaults.standard.string(forKey: "OneSignalId") {
            //set one signal id
            setOneSignalId(pushId: pushId)
        } else {
            // Remove one signal id
            removeOneSignalId()
        }
    }
}


func setOneSignalId(pushId: String) {
    updateCurrentUserOneSignalId(newId: pushId)
}

func removeOneSignalId() {
    updateCurrentUserOneSignalId(newId: "")
}

func updateCurrentUserOneSignalId(newId: String) {
    updateCurrentUser(withValues: [kPUSHID: newId, kUPDATEDAT: dateFormatter().string(from: Date())]) { (success) in
        print("One Signal ID was updated - \(success)")
    }
}
