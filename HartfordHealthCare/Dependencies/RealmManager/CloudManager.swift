//
//  CloudManager.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 20/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import Foundation
import RealmSwift

struct CloudManager {
    
    // MARK: Properties
    static let shared = CloudManager()
    private let SERVER = "ssp-medical.us1a.cloud.realm.io"
    private var SERVER_URL: String
    public var REALM_URL: String

    
    // MARK: Initializer
    private init() {
        SERVER_URL = "https://\(SERVER)/"
        REALM_URL = "realms://\(SERVER)/HartfordHealthCare"
    }
    
    
    public func login(participantID: String, password: String, result: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        guard let authURL = URL(string: SERVER_URL) else {
            return
        }
        let credentials = SyncCredentials.usernamePassword(username: participantID, password: password)
        SyncUser.logIn(with: credentials, server: authURL) { (user, error) in
            
            if let error = error {
                result(false, error.localizedDescription)
            } else {
                result(true, nil)
            }
            
        }
        
    }
    
    public func signup(participantID: String, password: String, result: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        guard let authURL = URL(string: SERVER_URL) else {
            return
        }
        let credentials = SyncCredentials.usernamePassword(username: participantID, password: password, register: true)
        SyncUser.logIn(with: credentials, server: authURL) { (user, error) in
            
            if let error = error {
                result(false, error.localizedDescription)
            } else {
                result(true, nil)
            }
            
        }
        
    }
    
}
