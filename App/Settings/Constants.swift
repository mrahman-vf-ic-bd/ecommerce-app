//
//  Constants.swift
//  App
//
//  Created by Siddiqur Rahmnan on 31/5/20.
//  Copyright © 2020 Siddiqur Rahmnan. All rights reserved.
//

import Foundation
import Firebase

var backendless = Backendless.sharedInstance()
var firebase = Database.database().reference()

// IDS and Keys
public let kONESIGNALAPPID = "98a5b201-66cb-4036-8cf8-7cae0a32011a"



// FUser
public let kOBJECTID = "objectId"
public let kUSER = "User"
public let kCREATEDAT = "createdAt"
public let kUPDATEDAT = "updatedAt"
public let kCOMPANY = "company"
public let kPHONE = "phone"
public let kADDPHONE = "addPhone"

public let kCONS = "coins"
public let kPUSHID = "pushId"
public let kFIRSTNAME = "firstname"
public let kLASTNAME = "lastname"
public let kFULLNAME = "fullname"
public let kAVATAR = "avatar"
public let kCURRENTUSER = "currentUser"
public let kISONLINE = "isOnline"
public let kVARIFICATIONCODE = "firebase_verification"
public let kISAGENT = "isAgent"
public let kFAVORIT = "favariteProperties"

// Property
public let kMAXIMUMIMAGENUMBER = 10
public let kRECENTPROPERTYLIMIT = 20

