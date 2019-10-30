//
//  UserDefaults+Extension.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 17/09/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func setArray <T:Codable> (objects: [T], key: String) {
        
        let encodedArray = objects.map { try? JSONEncoder().encode($0) }
        set(encodedArray, forKey: key)

    }
    
    func getArray <T:Codable> (object: T.Type, key: String) -> [T]? {
        
        guard let encodedDataArray = value(forKey: key) as? [Data] else {
            return nil
        }
        return encodedDataArray.map { try! JSONDecoder().decode(object.self, from: $0) }
        
    }
    
}
