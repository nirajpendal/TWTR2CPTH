//
//  ProfileHeader.swift
//  TWTRCDPTH
//
//  Created by Niraj Pendal on 4/21/17.
//  Copyright © 2017 Niraj. All rights reserved.
//

import UIKit

class ProfileHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var profileImageVIew: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileUserNameLabel: UILabel!
    @IBOutlet weak var numOfTweetsLable: UILabel!
    @IBOutlet weak var numOfFollowingLabel: UILabel!
    @IBOutlet weak var numOfFollowersLabel: UILabel!
    
    var user:User! {
        didSet{
            if let profileUrl = user.profileURL{
                self.profileImageVIew.setImageWith(profileUrl)
            }
            self.profileNameLabel.text = user.name
            self.profileUserNameLabel.text = "@\(user.screenName!)"
        }
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
