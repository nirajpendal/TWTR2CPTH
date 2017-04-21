//
//  Tweet.swift
//  TWTRCDPTH
//
//  Created by Niraj Pendal on 4/14/17.
//  Copyright © 2017 Niraj. All rights reserved.
//

import Foundation

class Tweet {
    
    var profileUserName: String?
    var profileImageUrl: URL?
    var profileName: String?
    var createdAt: String?
    var text: String?
    var timeStamp: Date?
    var reTweetCount: Int = 0
    var favouriteCount: Int = 0
    
    init(dictionary: [String: AnyObject]) {
        
        text = dictionary["text"] as? String
        createdAt = dictionary["created_at"] as? String
        
        if let createdAt = createdAt {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.date(from: createdAt)
        }
        reTweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favouriteCount = (dictionary["favourites_count"] as? Int) ?? 0
        if let tweetUser = dictionary["user"] as? [String: Any] {
            if let profileImageUrlString = tweetUser["profile_image_url_https"] as? String {
                profileImageUrl = URL(string: profileImageUrlString)
            }
            
            profileName = tweetUser["name"] as? String
            profileUserName = tweetUser["screen_name"] as? String
        }
    }
    
    static func getTweets(dictionaries:[[String:AnyObject]]) -> [Tweet] {
        
        var tweets = [Tweet]()
        
        for dictionaruy in dictionaries {
            tweets.append(Tweet(dictionary: dictionaruy))
        }
        
        return tweets
        
    }
    
}
