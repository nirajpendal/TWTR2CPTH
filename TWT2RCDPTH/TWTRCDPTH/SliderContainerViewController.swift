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
    
    var originalLeftMargin: CGFloat!
    var menuContoller: MenuViewController?
    var tweetsViewController: UIViewController!
    var profileViewController: UIViewController!
    var accountsViewController: UIViewController!
    var navController: UINavigationController!
    var viewControllers:[UIViewController]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        tweetsViewController = storyBoard.instantiateViewController(withIdentifier: "TweetsViewController")
        profileViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController")
        accountsViewController = storyBoard.instantiateViewController(withIdentifier: "AccountsViewController")
        
        self.viewControllers = [tweetsViewController, profileViewController, accountsViewController]
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
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            
            self.mainContainerViewLeadingContraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began:
            originalLeftMargin = mainContainerViewLeadingContraint.constant
            print("began")
        case .changed:
            if (originalLeftMargin + translation.x) > 0  && (originalLeftMargin + translation.x) < 300{
                mainContainerViewLeadingContraint.constant = originalLeftMargin + translation.x
            }
            
            print("changed")
        case .ended:
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                if velocity.x > 0 {
                    // left
                    self.mainContainerViewLeadingContraint.constant = 300
                } else {
                    self.mainContainerViewLeadingContraint.constant = 0
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
