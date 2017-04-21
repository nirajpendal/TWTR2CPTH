//
//  TweetsViewController.swift
//  TWTRCDPTH
//
//  Created by Niraj Pendal on 4/15/17.
//  Copyright © 2017 Niraj. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    @IBOutlet weak var tweetTableView: UITableView!
    var tweets = [Tweet]()
    var selectedTweet: Int?
    let client = TwitterClient.sharedInstance
    let refreshControl = UIRefreshControl()
    let activityIndicator = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
        self.tweetTableView.estimatedRowHeight = 120
        
        refreshControl.addTarget(self, action: #selector(fetchTweets), for: UIControlEvents.valueChanged)
        self.tweetTableView.refreshControl = refreshControl
        
        fetchTweets()
        
        let rightBarItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(rightButtonPressed))
        self.navigationItem.rightBarButtonItem = rightBarItem
        rightBarItem.tintColor = UIColor.white// titleTextAttributes(for: UIControlState.normal)
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        
        TwitterClient.sharedInstance.logOut()
        
    }
    func  displayError(message:String)  {
        let alertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }

    func rightButtonPressed(){
        print("bitton pressed")
        self.performSegue(withIdentifier: "NewTweetSegue", sender: nil)
    }
    
    func presentIndicator()  {
        self.activityIndicator.showActivityIndicator(uiView: (self.navigationController?.view)!)
        //self.activityIndicator.startAnimating()
    }
    
    func hideIndicator()  {
        self.activityIndicator.hideActivityIndicator(view: (self.navigationController?.view)!)
    }
    
    func fetchTweets()  {
        self.presentIndicator()
        client.getTweets(success: {[weak self] (tweets: [Tweet]) in
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        // Refetch tweets from client 
        self.selectedTweet = nil
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailTweetViewController =  segue.destination as? DetailTweetViewController {
            let selectedTweet = tweetTableView.indexPathForSelectedRow?.row
            if let selectedTweet = selectedTweet {
                detailTweetViewController.tweet = self.tweets[selectedTweet]
            }
        }
    }
    

}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count//2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = self.tweets[indexPath.row]
        //cell.textLable?.text = "123 45 5 6 7   3 2 4  5 6 7 4 3  3 5 6 7  4  3   3 5 6 7  7 65 4 3  4 56  7 8 7 65 4 3  4 5 6 7 8  76 54 3  4 56 7 8   76 54   5 67 8  7 65 4 3 e  5 6 7 65 4 3  45 67    8 7 65 4 3  4 56 7  65 43  4 56 7 8  Done"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     //self.selectedTweet = indexPath.row
        self.performSegue(withIdentifier: "DetailsSegue", sender: nil)
        
    }
    
}
