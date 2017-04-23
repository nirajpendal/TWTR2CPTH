//
//  MentioensViewController.swift
//  TWTRCDPTH
//
//  Created by Niraj Pendal on 4/22/17.
//  Copyright © 2017 Niraj. All rights reserved.
//

import UIKit

class MentioensViewController: TweetsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func fetchTweets() {
        self.presentIndicator()
        client.getMentions(success: {[weak self] (tweets: [Tweet]) in
            
            guard let strognSelf = self else {
                return
            }
            
            strognSelf.tweets = tweets
            strognSelf.tweetTableView.reloadData()
            strognSelf.refreshControl.endRefreshing()
            
            self?.hideIndicator()
            
        }) { [weak self] (error:Error) in
            print(error.localizedDescription)
            self?.refreshControl.endRefreshing()
            
            self?.displayError(message: error.localizedDescription)
            
            self?.hideIndicator()
        }
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
