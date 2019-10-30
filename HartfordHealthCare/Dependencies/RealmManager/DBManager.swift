//
//  DBManager.swift
//  HartfordHealthCare
//
//  Created by Rameez Raja on 20/08/2019.
//  Copyright © 2019 NXB. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    
    // MARK:- Properties
    private static var dbManager: DBManager?
    public var database: Realm

    private var meditationSessionsSyncSubscription: SyncSubscription<MeditationSession>?
    private var meditationSessionsSubscriptionToken: NotificationToken?
    private var meditationSessionsNotificationToken: NotificationToken?
    public var myMeditationSessionsAreSubscribed: Bool = false

    private var linkSessionsSyncSubscription: SyncSubscription<LinkSession>?
    private var linkSessionsSubscriptionToken: NotificationToken?
    private var linkSessionsNotificationToken: NotificationToken?
    public var linkSessionsAreSubscribed: Bool = false

    
    // MARK:- Initializer & Deinitializer
    class func shared() -> DBManager {
        guard let manager = dbManager else {
            dbManager = DBManager()
            return dbManager!
        }
        return manager
    }
    
    private init() {
        
        let realmURL = URL(string: CloudManager.shared.REALM_URL)
        guard let user = SyncUser.current else {
            database = try! Realm()
            Router.shared.logOutAndSetAuthAsRootVC()
            return
        }
        let config = user.configuration(realmURL: realmURL)
        database = try! Realm(configuration: config)

    }
    
    class func destroy() {
        dbManager = nil
    }
    
    
    // DB Generic Operations
    public func add(object: Object, overwrite: Bool) {
        
        try! database.write {
            if overwrite {
                database.add(object, update: .all)
            } else {
                database.add(object)
            }
        }
        
    }
    
    public func delete(object: Object) {
        
        try! database.write {
            database.delete(object)
        }
        
    }
    
    
    // MARK:- DB Custom Operations
    public func getMeditationSessions() -> Results<MeditationSession> {
        
        let results = database.objects(MeditationSession.self)
        return results
        
    }

    public func getLinkSessions() -> Results<LinkSession> {
        
        let results = database.objects(LinkSession.self)
        return results
        
    }

    public func subscribeForAllObjects(completion: @escaping (_ error: Error?) -> Void) {
        
        subscribeForMyMeditationSessions { (meditationSubscriptionError) in
            
            if meditationSubscriptionError == nil {
                self.myMeditationSessionsAreSubscribed = true
                
                self.subscribeForLinkSessions { (linkSessionSubscriptionError) in
                    
                    if linkSessionSubscriptionError == nil {
                        self.linkSessionsAreSubscribed = true
                        completion(nil)
                    } else {
                        completion(linkSessionSubscriptionError)
                    }
                    
                }
                
            } else {
                completion(meditationSubscriptionError)
            }
            
        }
        
    }
    
}


// MARK:- Meditation Session Subscription
extension DBManager {
    
    private func subscribeForMyMeditationSessions(completion: @escaping (_ error: Error?) -> Void) {
        

        let sessions = getMeditationSessions()
        meditationSessionsSyncSubscription = sessions.subscribe()
        meditationSessionsSubscriptionToken = meditationSessionsSyncSubscription?.observe(\.state, options: .initial, { (state) in
            
            print("My Sessions State :\(state)")
            switch state {
                
            case .complete:
                NotificationCenter.default.post(name: .refreshMeditationSessionHistoryUI, object: nil)
                completion(nil)
            case .error(let error):
                completion(error)
                
            default: break
                
            }
            
        })
        
        meditationSessionsNotificationToken = sessions.observe { (changes) in
            
            switch changes {
                
            case .initial:
                print("Meditation Sessions Subscription Initial State")
                
            case .update(_, _, _, _):
                NotificationCenter.default.post(name: .refreshMeditationSessionHistoryUI, object: nil)
                print("Meditation Sessions Subscription Update State")

            case .error(let error):
                print("Meditation Sessions Subscription error :\(error)")

            }
            
        }
        
    }
    
}


// MARK:- Link Session Subscription
extension DBManager {
    
    private func subscribeForLinkSessions(completion: @escaping (_ error: Error?) -> Void) {
        

        let sessions = getLinkSessions()
        linkSessionsSyncSubscription = sessions.subscribe()
        linkSessionsSubscriptionToken = linkSessionsSyncSubscription?.observe(\.state, options: .initial, { (state) in
            
            print("Link Sessions State :\(state)")
            switch state {
                
            case .complete:
                completion(nil)
            case .error(let error):
                completion(error)
                
            default: break
                
            }
            
        })
        
        linkSessionsNotificationToken = sessions.observe { (changes) in
            
            switch changes {
                
            case .initial:
                print("Link Sessions Subscription Initial State")
                
            case .update(_, _, _, _):
                print("Link Sessions Subscription Update State")

            case .error(let error):
                print("Link Sessions Subscription error :\(error)")

            }
            
        }
        
    }
    
}
