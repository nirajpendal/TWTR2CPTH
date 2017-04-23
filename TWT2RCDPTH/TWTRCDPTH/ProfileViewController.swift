//
//  ProfileViewController.swift
//  TWTRCDPTH
//
//  Created by Niraj Pendal on 4/20/17.
//  Copyright © 2017 Niraj. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    fileprivate var user: User!
    
    var screenName: String?
    
    var userTimelines:[Tweet] = []
    
    @IBOutlet weak var profileTableView: UITableView!
    let refreshControl = UIRefreshControl()
    let activityIndicator = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.screenName == nil {
            //self.user = User.currentUser
            screenName = User.currentUser?.screenName
        }
            //self.loadViewDetails()
        //} else {
            TwitterClient.sharedInstance.userLookUp(userScreenName: screenName, success: { (user: User) in
                self.user = user
                self.loadViewDetails()
                
            }, failure: { (error: Error) in
                self.displayError(message: error.localizedDescription)
            })
        //}
        // Do any additional setup after loading the view.
    }
    
    func loadViewDetails ()  {
        profileTableView.register(UINib(nibName: "TweetCell", bundle: nil) , forCellReuseIdentifier: "TweetCell")
        profileTableView.register(UINib(nibName: "ProfileHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ProfileHeader")
        
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        self.profileTableView.rowHeight = UITableViewAutomaticDimension
        self.profileTableView.estimatedRowHeight = 120
        
        setTableHeaderBackgroundImage()
        
        refreshControl.addTarget(self, action: #selector(fetchUserTimelines), for: UIControlEvents.valueChanged)
        self.profileTableView.refreshControl = refreshControl
        
        fetchUserTimelines()

    }
    
    func setTableHeaderBackgroundImage() {
        profileTableView.layoutIfNeeded()
        
        let imageView = UIImageView(image: UIImage(named: "Red_Background_05"))
        
        if let profileBGUrl = user.profileBackGroundURL{
            imageView.setImageWith(profileBGUrl)
        }
        
//        let imageView = UIImageView(image: UIImage(named: "Red_Background_05"))
        imageView.frame = CGRect(x: 0, y: 0, width: profileTableView.bounds.width, height: 160)
        profileTableView.addParallax(with: imageView, andHeight: 160)
  
        
        
        let headerView = UINib(nibName: "ProfileHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ProfileHeader
        headerView.autoresizingMask = .flexibleWidth
        headerView.tintColor = UIColor.white
        headerView.translatesAutoresizingMaskIntoConstraints = true
        headerView.user = user
        self.profileTableView.tableHeaderView = headerView
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentIndicator()  {
        self.activityIndicator.showActivityIndicator(uiView: (self.navigationController?.view)!)
        //self.activityIndicator.startAnimating()
    }
    
    func hideIndicator()  {
        self.activityIndicator.hideActivityIndicator(view: (self.navigationController?.view)!)
    }
    
    func fetchUserTimelines(){
        self.presentIndicator()
        TwitterClient.sharedInstance.getUserTimeLine(userScreenName: self.user.screenName, success: {[weak
            self] (tweets:[Tweet]) in
            
            guard let strognSelf = self else {
                return
            }
            
            strognSelf.userTimelines = tweets
            strognSelf.profileTableView.reloadData()
           // strognSelf.reloadTable()
            strognSelf.refreshControl.endRefreshing()
            strognSelf.hideIndicator()
            
        }) { [weak self](error: Error) in
            
            self?.refreshControl.endRefreshing()
            
            self?.displayError(message: error.localizedDescription)
            
            self?.hideIndicator()
        }
    }
    
    func  displayError(message:String)  {
        let alertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userTimelines.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
//        view.tintColor = UIColor.red
//        view.backgroundColor = UIColor.white
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.textColor = UIColor.white
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProfileHeader") as! ProfileHeader
//        headerCell.user = User.currentUser
//        return headerCell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 100  // or whatever
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = self.userTimelines[indexPath.row]
        return cell
    }
    
}
