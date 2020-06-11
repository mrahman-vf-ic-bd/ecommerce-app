//
//  AppDelegate.swift
//  App
//
//  Created by Siddiqur Rahmnan on 31/5/20.
//  Copyright © 2020 Siddiqur Rahmnan. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let APP_ID = "EB864036-7587-7950-FF25-48ED62951A00"
    let API_KEY = "A5B3572C-FD12-49E5-9079-AEA4C11E74B0"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        backendless?.initApp(APP_ID, apiKey: API_KEY)
        
        // For one signal
        OneSignal.initWithLaunchOptions(launchOptions, appId: kONESIGNALAPPID, handleNotificationReceived: nil, handleNotificationAction: nil, settings: nil)
        
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                if UserDefaults.standard.object(forKey: kCURRENTUSER) != nil {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: ["userId": FUser.currentId()])
                    }
                }
            }
        }
        
        func onUserDidLogin(userId: String) {
            //Strt oneSignal
            self.startOneSignal()
        }
        
        NotificationCenter.default.addObserver(forName:NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, queue: nil) { (note) in
            let userId = note.userInfo!["userId"] as! String
            UserDefaults.standard.setValue(userId, forKey: "userId")
            UserDefaults.standard.synchronize()
            
            onUserDidLogin(userId: userId)
        }
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert, .sound]) {
                (granted, error) in
                
            }
            
            application.registerForRemoteNotifications()
        } else {
            
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for user notifications")
    }
    
    // MARK: OneSignal
    
    func startOneSignal() {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let userId = status.subscriptionStatus.userId
        let pushToken = status.subscriptionStatus.pushToken
        
        if pushToken != nil {
            if let playerId = userId {
                UserDefaults.standard.setValue(playerId, forKey: "OneSignalId")
            } else {
                UserDefaults.standard.removeObject(forKey: "OneSignalId")
            }
        }
        
        
        // Save to our user object
        
        updateOneSignalId()
        
    }
}

