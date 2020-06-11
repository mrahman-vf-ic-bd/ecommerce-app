//
//  ViewController.swift
//  App
//
//  Created by Siddiqur Rahmnan on 31/5/20.
//  Copyright © 2020 Siddiqur Rahmnan. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var requestButtonOutlet: UIButton!
    
    // Email Registration
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - IBActions
    @IBAction func requestButtonPressed(_ sender: UIButton) {
        if phoneNumberTextField.text != "" {
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberTextField.text!, uiDelegate: nil) {
                (verificationId, error) in
                
                if error != nil {
                    print("Error phone number \(error?.localizedDescription)")
                    return
                }
                
                let phoneNumber = self.phoneNumberTextField.text!
                self.phoneNumberTextField.text = ""
                self.phoneNumberTextField.placeholder = phoneNumber
                
                self.phoneNumberTextField.isEnabled = false
                self.codeTextField.isHidden = false
                self.requestButtonOutlet.setTitle("Register", for: .normal)
                
                UserDefaults.standard.setValue(verificationId, forKey: kVARIFICATIONCODE)
                UserDefaults.standard.synchronize()
            }
        }
        
        if codeTextField.text != "" {
            FUser.registerUserWith(phoneNumber: self.phoneNumberTextField.placeholder!, verificationCode: codeTextField.text!) {
                (error, shouldLogin) in
                if error != nil {
                    print("error \(error?.localizedDescription)")
                    return
                }
                
                if shouldLogin {
                    // go to main view
                    print("go to main view")
                } else {
                    // go to finish register view
                    print("got to finish reg view")
                }
            }
        }
    }
    
    @IBAction func emailRegisterButtonPressed(_ sender: UIButton) {
        if !(emailTextField.text!.isEmpty) &&
            !(nameTextField.text!.isEmpty) &&
            !(lastNameTextField.text!.isEmpty) &&
            !(passwordTextField.text!.isEmpty) {
            
            FUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!, firstName: nameTextField.text!, lastName: lastNameTextField.text!) {
                (error) in
                if (error != nil) {
                    print("Error registering user with email: \(error?.localizedDescription)")
                    return
                }
                self.goToApp()
            }
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.goToApp()
    }
    
    // MARK: Helper function
    
    func goToApp() -> Void {
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC")
        self.present(mainView, animated: true, completion: nil)
    }
}

