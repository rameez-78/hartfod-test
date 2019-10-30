//
//  SignupViewController.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 20/09/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var participantIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: Properties
    
    
    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    // MARK: Action
    @IBAction func loginButtonTapped(_ sender: Any) {
        validateFields()
    }
    
    
    // MARK: Custom Methods
    private func setupViews() {
        
        view.addAppThemeGradient()
        participantIDTextField.delegate = self
        passwordTextField.delegate = self
        participantIDTextField.addLeftViewWithIcon(icon: UserIcon(frame: CGRect(x: 0, y: 0, width: 23, height: participantIDTextField.frame.size.height)))
        passwordTextField.addLeftViewWithIcon(icon: LockIcon(frame: CGRect(x: 0, y: 0, width: 23, height: passwordTextField.frame.size.height)))
        
    }
    
    private func validateFields() {
        
        DispatchQueue.main.async {
            let participantID = self.participantIDTextField.text!
            let password = self.passwordTextField.text!
            if participantID.isEmpty {
                self.showBasicAlert(title: Strings.error, message: Strings.emptyParticipantID)
            } else if password.isEmpty {
                self.showBasicAlert(title: Strings.error, message: Strings.emptyPassword)
            } else {
                
                if Network.isAvailable() {
                    self.view.showSpinner(isUserInteractionEnabled: false, isForMediaPlayer: false)
                    CloudManager.shared.signup(participantID: participantID, password: password, result: { (isSuccess, error) in

                        self.view.removeSpinner()
                        if isSuccess {
                            
                            // Save User
                            let user = User()
                            user.participantID = participantID
                            DBManager.shared().add(object: user, overwrite: false)
                            
                            UserDefaults.standard.setValue(participantID, forKey: UserDefaultKeys.participantID)
                            Router.shared.pushViewController(with: IntroductoryMediationViewController.identifier, navigationController: self.navigationController, storyboard: .authentication)
                            
                        } else {
                            self.showBasicAlert(title: Strings.error, message: error ?? Strings.unExpectedResult)
                        }
                        
                    })
                } else {
                    self.showBasicAlert(title: Strings.error, message: "Intenet connection is required to perform this action!")
                }
                
            }
            
        }
        
    }
    
}


// MARK: UITextField Delegates
extension SignupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == participantIDTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            validateFields()
        }
        return true
        
    }
    
}
