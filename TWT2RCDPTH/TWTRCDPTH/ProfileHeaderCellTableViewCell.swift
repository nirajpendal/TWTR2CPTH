//
//  ProfileHeaderCellTableViewCell.swift
//  TWTRCDPTH
//
//  Created by Niraj Pendal on 4/21/17.
//  Copyright © 2017 Niraj. All rights reserved.
//

import UIKit

class ProfileHeaderCellTableViewCell: UITableViewHeaderFooterView {

    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    
    var user: User! {
        didSet {
            if let profileBgUrl = user.profileBackGroundURL {
                self.profileBackgroundImageView.setImageWith(profileBgUrl)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
