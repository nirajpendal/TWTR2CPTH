//
//  User.swift
//  TWTRCDPTH
//
//  Created by Niraj Pendal on 4/14/17.
//  Copyright © 2017 Niraj. All rights reserved.
//

import Foundation

let currentUserKey = "currentUser"

class User {
    
    var name: String?
    var tagLine: String?
    var profileURL: URL?
    var screenName: String?
    
    var tweets:[Tweet]?
    private static var _currentUser:User?
    
    static let userDidLogOutNotificationKey = "userDidLogOutNotification"
    
    var _dictionary:[String:AnyObject]?
    
    init(dictionary: [String:AnyObject]) {
        
        self._dictionary = dictionary
        
        name = dictionary ["name"] as? String
        tagLine = dictionary ["description"] as? String
        let profileString = dictionary ["profile_background_image_url_https"] as? String
        
        if let profileStringNotNil = profileString {
            profileURL = URL(string: profileStringNotNil)!
        }
        
        screenName =  dictionary ["screen_name"] as? String
        
    }
    
    class var currentUser:User? {
        get {
            
            if _currentUser == nil {
                
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: currentUserKey) as? Data
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String:AnyObject]
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
            return _currentUser
        }
        
        set(user) {
            
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                
                let data = try! JSONSerialization.data(withJSONObject: user._dictionary!, options: [])
                defaults.set(data, forKey: currentUserKey)
            } else {
                defaults.set(nil, forKey: currentUserKey)
            }
            
        }
    }
    
}
