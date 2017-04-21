//
//  TwitterClient.swift
//  TWTRCDPTH
//
//  Created by Niraj Pendal on 4/14/17.
//  Copyright © 2017 Niraj. All rights reserved.
//

import Foundation
import BDBOAuth1Manager



class TwitterClient:BDBOAuth1SessionManager {
    static let consumerKey = "9j4pjidZUJqYhaYiFdbfWiZ5I"
    static let consumerSecret = "KJfSYMoP59Zl5S65HEowybiRXi1E4U4nA5Epsuta4czX6u6o1R"
    
    static let baseURL = "https://api.twitter.com"
    //MARK: Shared Instance
    
    static let sharedInstance: TwitterClient = TwitterClient(baseURL: URL(string: baseURL) , consumerKey: consumerKey, consumerSecret: consumerSecret)
    
    private var loginSuccessClousure:(()->())?
    private var loginFailureClousure:((Error)->())?
    
    
    func login(success: @escaping ()->(), failure: @escaping (Error)->()) {
        
        loginSuccessClousure = success
        loginFailureClousure = failure
        
        self.deauthorize()
        self.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"twitterDemo://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential?) in
            
            let authorizeURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(authorizeURL, options: [:], completionHandler: nil)
            
            
        }, failure: { (error:Error?) in
            print(error!.localizedDescription)
        })
        
    }
    
    func logOut(){
        
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogOutNotificationKey), object: nil)
        
    }
    
    func handleOpenUrl(url: URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        
        self.fetchAccessToken(withPath: TwitterClient.baseURL+"/oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.currentUser(success: { (user:User) in
                
                self.loginSuccessClousure?()
                
            }, failure: { (error:Error) in
                print(error.localizedDescription)
                self.loginFailureClousure?(error)
            })
            
        }, failure: { (error: Error?) in
            print(error!.localizedDescription)
            self.loginFailureClousure?(error!)
        })
        
    }
    
    func currentUser(success: @escaping (User) -> (), failure: @escaping (Error) -> ()){
        
        self.get(TwitterClient.baseURL+"/1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (taks:URLSessionDataTask, response:Any?) in
            
            let responseDict = response as! [String:AnyObject]
            let user  = User(dictionary: responseDict)
            
            User.currentUser = user
            success(user)
            
            
        }, failure: { (task:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            failure(error)
        })
    }
    
    func getTweets(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()){
        
        self.get(TwitterClient.baseURL+"/1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (taks:URLSessionDataTask, response:Any?) in
            
            let responseDictionaries = response as! [[String:AnyObject]]
            
            let tweets = Tweet.getTweets(dictionaries: responseDictionaries)
            success(tweets)
            
            
        }, failure: { (task:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            failure(error)
        })
        
        
        
    }
    
    func postTweet(text: String, completionHandler:@escaping (Bool, Error?)->()) {
        
        let paramter = ["status":text]
        
        self.post(TwitterClient.baseURL+"/1.1/statuses/update.json", parameters: paramter, progress: nil, success: { (task:URLSessionDataTask, response: Any) in
            print("Success")
            completionHandler(true, nil)
        }) { (task:URLSessionDataTask?, error:Error) in
            print("Posting failed")
            completionHandler(false, error)
        }
        
    }
    
    
}
