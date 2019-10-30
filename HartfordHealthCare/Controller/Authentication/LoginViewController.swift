//
//  LoginWithEmailViewController.swift
//  Hartford Healthcare
//
//  Created by Rameez Raja on 01/08/2019.
//  Copyright © 2019 Bradley Pickard. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var participantIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: Properties
    private var usersSyncSubscription: SyncSubscription<User>!
    private var subscriptionToken: NotificationToken?
    private var notificationToken: NotificationToken?
    
    
    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    // MARK: Action
    @IBAction func loginButtonTapped(_ sender: Any) {
        validateFields()
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        Router.shared.pushViewController(with: SignupViewController.identifier, navigationController: navigationController, storyboard: .authentication)
    }
    
    
    // MARK: Custom Methods
    private func setupViews() {
        
        view.addAppThemeGradient()
        UserDefaults.standard.setValue(OnBoardingScreen.none.rawValue, forKey: UserDefaultKeys.onBoardingProcessScreen)
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
                    
                    SyncUser.current?.logOut()
                    self.view.showSpinner(isUserInteractionEnabled: false, isForMediaPlayer: false)
                    CloudManager.shared.login(participantID: participantID, password: password, result: { (isSuccess, error) in
                        
                        if isSuccess {
                            
                            self.subscribeForUsersList(completion: { (error, users) in
                                
                                self.view.removeSpinner()
                                if error != nil {
                                    self.showBasicAlert(title: Strings.error, message: error!.localizedDescription)
                                } else {
                                    self.checkUserExistance(users: users!, participantID: participantID)
                                }
                                
                            })
                            
                        } else {
                            self.view.removeSpinner()
                            self.showBasicAlert(title: Strings.error, message: error ?? Strings.unExpectedResult)
                        }
                        
                    })
                    
                } else {
                    self.showBasicAlert(title: Strings.error, message: "Intenet connection is required to perform this action!")
                }
                
            }
            
        }

    }
    
    private func subscribeForUsersList(completion: @escaping (_ error: Error?, _ users: Results<User>?) -> Void) {
        
        let users = DBManager.shared().database.objects(User.self)
        usersSyncSubscription = users.subscribe()
        subscriptionToken = usersSyncSubscription.observe(\.state, options: .initial, { (state) in
            
            switch state {
            case .complete:
                completion(nil, users)
            case .error(let error):
                completion(error, nil)
            default:
                break
                
            }
            
        })
        
        notificationToken = users.observe { (changes) in
            
            switch changes {
            case .initial:
                print("observe: Initial")
            case .update(_, _, _, _):
                print("observe: Update")
            case .error(_):
                SyncUser.current?.logOut()
            }
            
        }

    }
    
    private func checkUserExistance(users: Results<User>, participantID: String) {
        
        if let user = users.first(where: { (userToCheck) -> Bool in
            if userToCheck.participantID == participantID {
                return true
            } else {
                return false
            }
        }) {

            UserDefaults.standard.setValue(user.participantID, forKey: UserDefaultKeys.participantID)
            Router.shared.pushViewController(with: IntroductoryMediationViewController.identifier, navigationController: self.navigationController, storyboard: .authentication)

        } else {
            
            SyncUser.current?.logOut()
            showBasicAlert(title: Strings.error, message: Strings.incorrectCredentials)
            
        }

    }

}


// MARK: UITextField Delegates
extension LoginViewController: UITextFieldDelegate {
    
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
