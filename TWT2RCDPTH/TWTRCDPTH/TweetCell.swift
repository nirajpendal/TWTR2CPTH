//
//  TweetCell.swift
//  TWTRCDPTH
//
//  Created by Niraj Pendal on 4/16/17.
//  Copyright © 2017 Niraj. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var textLable: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    var tweet:Tweet!{
        
        didSet{
            if let profileURL = tweet.profileImageUrl {
                self.profileImageView.setImageWith(profileURL, placeholderImage: UIImage(named: "dummy"))
            }
            self.textLable.text = tweet.text
            if let profileUserName = tweet.profileUserName{
                self.userLabel.text = "@"+profileUserName
            }
            
            self.userNameLable.text = tweet.profileName
            
            if let timeStamp = tweet.timeStamp {
                
                let timeDiffernce = Date().timeIntervalSinceNow - timeStamp.timeIntervalSinceNow
                

                
                if( timeDiffernce < 24 * 60 * 60) {
                    print("Tweet is within 24 hr")
                    
                    if (timeDiffernce < 60 * 60) {
                        let differenceInMin = Int(timeDiffernce / (60))
                        hourLabel.text = "\(differenceInMin)mins"
                    } else {
                        let differenceInHour = Int(timeDiffernce / (60 * 60))
                        print(differenceInHour)
                        hourLabel.text = "\(differenceInHour)h"
                    }
                    
                } else {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "mm/dd/yyyy"
                    hourLabel.text = formatter.string(from: timeStamp)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.cornerRadius = 3
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
