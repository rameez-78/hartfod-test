//
//  UIViewController+Extension.swift
//  Hartford Healthcare
//
//  Created by Rameez Raja on 01/08/2019.
//  Copyright © 2019 Bradley Pickard. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showBasicAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ok, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertForSettings(message: String) {
        
        let alert = UIAlertController(title: Strings.alert, message: message, preferredStyle: .alert)
        let settings = UIAlertAction(title: Strings.settings, style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
            
        }
        let cancel = UIAlertAction(title: Strings.cancel, style: .default, handler: nil)
        alert.addAction(cancel)
        alert.addAction(settings)
        present(alert, animated: true, completion: nil)
        
    }
    
}
