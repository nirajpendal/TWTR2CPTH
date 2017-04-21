//
//  DetailTweetViewController.swift
//  TWTRCDPTH
//
//  Created by Niraj Pendal on 4/16/17.
//  Copyright © 2017 Niraj. All rights reserved.
//

import UIKit

class DetailTweetViewController: UIViewController {

    @IBOutlet weak var numberOfFavLabel: UILabel!
    @IBOutlet weak var numberOfReTweetLabel: UILabel!
    @IBOutlet weak var tweetCreatedTimeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var profileUsernameLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var tweet:Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if tweet != nil {
            print(tweet!.text!)
        }
        self.title = "Tweet"
        
        if let profileURL = tweet?.profileImageUrl {
            self.profileImageView.setImageWith(profileURL, placeholderImage: UIImage(named: "dummy")) //) (profileURL
        }
        self.numberOfFavLabel.text = "\(tweet?.favouriteCount ?? 0)"
        self.numberOfReTweetLabel.text = "\(tweet?.reTweetCount ?? 0)"
        self.tweetCreatedTimeLabel.text = tweet?.createdAt
        self.tweetTextLabel.text = tweet?.text
        self.profileNameLabel.text = tweet?.profileName
        self.profileUsernameLabel.text = tweet.profileUserName
        
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        let rightBarButton = UIBarButtonItem(title: "Reply", style: .plain, target: self, action: #selector(replyButtonPressed))
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.tintColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }
    
    func  replyButtonPressed()  {
        print("Reply Tapped")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
