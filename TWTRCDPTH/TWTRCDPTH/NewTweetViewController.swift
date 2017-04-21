//
//  NewTweetViewController.swift
//  TWTRCDPTH
//
//  Created by Niraj Pendal on 4/16/17.
//  Copyright © 2017 Niraj. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {
    
    @IBOutlet weak var profileUserName: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    
    let activityIndicator = ActivityIndicator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Tweet"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        self.navigationItem.leftBarButtonItem = cancelButton
        cancelButton.tintColor = UIColor.white
        
        let postButton = UIBarButtonItem(title: "Tweet", style: .plain, target: self, action: #selector(tweetButtonPressed))
        self.navigationItem.rightBarButtonItems = [postButton]
        postButton.tintColor = UIColor.white
        
        if let user = User.currentUser {
            
            print(user.name!)
            if let profileURL = user.profileURL {
                self.profileImageView.setImageWith(profileURL, placeholderImage: UIImage(named: "dummy"))
            }
            self.profileNameLabel.text = user.name
            self.profileUserName.text = user.screenName
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func  displayError(message:String)  {
        let alertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func presentIndicator()  {
        self.activityIndicator.showActivityIndicator(uiView: (self.navigationController?.view)!)
        //self.activityIndicator.startAnimating()
    }
    
    func hideIndicator()  {
        self.activityIndicator.hideActivityIndicator(view: (self.navigationController?.view)!)
    }
    
    func tweetButtonPressed()  {
        
        self.presentIndicator()
        
        if tweetTextView.text == "" {
            displayError(message: "Tween Can't be empty")
        }
        
        print("Tweet Pressed")
        
        let client = TwitterClient.sharedInstance
        client.postTweet(text: tweetTextView.text) { [weak self] (response:Bool, error:Error?) in
            if error != nil {
                print("Error in Posting Tweet")
                self?.displayError(message: error!.localizedDescription)
            } else{
                print("Tweet posted.")
                self?.goBack()
            }
            
            self?.hideIndicator()
        }
    }
    
    func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func cancelButtonPressed() {
        print("cancel Presssed")
        goBack()
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
