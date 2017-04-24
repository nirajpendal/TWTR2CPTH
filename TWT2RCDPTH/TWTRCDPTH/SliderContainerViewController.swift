//
//  SliderContainerViewController.swift
//  TWTRCDPTH
//
//  Created by Niraj Pendal on 4/20/17.
//  Copyright © 2017 Niraj. All rights reserved.
//

import UIKit

class SliderContainerViewController: UIViewController, MenuDelegate {

    @IBOutlet weak var mainContainerViewLeadingContraint: NSLayoutConstraint!
    
    var isMenuShown: Bool = false
    
    var originalLeftMargin: CGFloat!
    var menuContoller: MenuViewController?
    var tweetsViewController: UIViewController!
    var profileViewController: ProfileViewController!
    var accountsViewController: UIViewController!
    var mentionsViewController: TweetsViewController!
    var navController: UINavigationController!
    var viewControllers:[UIViewController]!
    
    fileprivate var visualEffectView: UIVisualEffectView?
    fileprivate var visualEffectViewWidthConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        tweetsViewController = storyBoard.instantiateViewController(withIdentifier: "TweetsViewController")
        profileViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        accountsViewController = storyBoard.instantiateViewController(withIdentifier: "AccountsViewController")
        
        mentionsViewController = storyBoard.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
        mentionsViewController.isMentions = true
        
        self.viewControllers = [profileViewController, tweetsViewController, accountsViewController, mentionsViewController]
        self.selectionChanged(selectedIndex: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "MenuSegue":
            self.menuContoller = segue.destination as? MenuViewController
            self.menuContoller?.delegate = self
        case "MainSegue":
            self.navController = segue.destination as? UINavigationController
            print("")
        default:
            print("")
        }
    }
    
    func selectionChanged(selectedIndex: Int) {
        print("selected \(selectedIndex)")
        self.navController.setViewControllers([self.viewControllers[selectedIndex]], animated: false)
        hideMenu()
    }
    
    func hideMenu(){
        
        if !isMenuShown {
            return
        }
        
        isMenuShown = false
        
        self.visualEffectViewWidthConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.visualEffectView?.removeFromSuperview()
            self.visualEffectView = nil
            self.mainContainerViewLeadingContraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func showMenu() {

        if isMenuShown {
            return
        }
        
        isMenuShown = true
        self.mainContainerViewLeadingContraint.constant = 300

        var frame = self.view.bounds
        frame.size.width = 0
        self.visualEffectView = UIVisualEffectView(frame: frame)
        self.visualEffectView?.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        self.visualEffectView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(self.visualEffectView!, aboveSubview: (self.menuContoller?.view)!)
        self.visualEffectView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.visualEffectView?.leadingAnchor.constraint(equalTo: self.menuContoller!.view.leadingAnchor, constant: 290 ).isActive = true
        self.visualEffectView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.visualEffectViewWidthConstraint = self.visualEffectView?.widthAnchor.constraint(equalToConstant: self.view.bounds.size.width)
        self.visualEffectViewWidthConstraint?.isActive = true
        //Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.visualEffectView?.addGestureRecognizer(tapGesture)
        
    }
    
    dynamic func handleTap() {
        self.hideMenu()
        
    }
//
//    func hideMenu() {
//        self.mainContainerViewLeadingContraint.constant = 0
//    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began:
            originalLeftMargin = mainContainerViewLeadingContraint.constant
            print("began")
        case .changed:
            if isMenuShown {
                return
            }
            
            if (originalLeftMargin + translation.x) > 0  && (originalLeftMargin + translation.x) < 300{
                mainContainerViewLeadingContraint.constant = originalLeftMargin + translation.x
            }
            
            print("changed")
        case .ended:
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                if velocity.x > 0 {
                    // left
                    self.showMenu()
                    
                } else {
                    self.hideMenu()
                    
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            
        //print("ended")
        case .cancelled:
            print("")
        default:
            print("")
        }
        
    }

}
