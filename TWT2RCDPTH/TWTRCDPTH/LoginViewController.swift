//
//  LoginViewController.swift
//  TWTRCDPTH
//
//  Created by Niraj Pendal on 4/14/17.
//  Copyright © 2017 Niraj. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let consumerKey = "9j4pjidZUJqYhaYiFdbfWiZ5I"
let consumerSecret = "KJfSYMoP59Zl5S65HEowybiRXi1E4U4nA5Epsuta4czX6u6o1R"

let baseURL = "https://api.twitter.com"


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    @IBAction func onLogin(_ sender: Any) {

        let client = TwitterClient.sharedInstance
        
        client.login(success: {
            
            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            
        }) { (error:Error) in
            print(error.localizedDescription)
        }
        
       
    }

}
