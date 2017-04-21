//
//  MenuViewController.swift
//  TestMenuViewController
//
//  Created by Niraj Pendal on 4/20/17.
//  Copyright © 2017 Niraj. All rights reserved.
//

import UIKit

protocol MenuDelegate {
    func selectionChanged(selectedIndex: Int)
}

class MenuViewController: UITableViewController {

    var currentlySelectedIndex = 0
    var delegate:MenuDelegate?
    
    @IBOutlet weak var menuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.menuTableView.selectRow(at:IndexPath(row: currentlySelectedIndex, section: 1) , animated: true, scrollPosition: .top)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != currentlySelectedIndex {
            delegate?.selectionChanged(selectedIndex: indexPath.row)
            self.currentlySelectedIndex = indexPath.row
        }
        
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
