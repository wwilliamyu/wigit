/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import Bolts

class Home: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var introduction: UILabel!
    @IBOutlet var rentedItems: UITableView!
    @IBOutlet var lendedItems: UITableView!
    var rentedItemsList: [PFObject] = [PFObject]()
    var lentItemsList: [PFObject] = [PFObject]()
    let rentedIdentifier = "RentedItemCell"
    let lentIdentifier = "LentItemCell"
    let api: WigitAPI = WigitAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            // Do stuff with the user
            
            introduction.text = "Hi, " + (currentUser!["firstname"] as! String)
            
        } else {
            // Show the signup or login screen
            print("currentUser did not work in Home.swift")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        api.rentedItemsForUser({ (let objects) -> () in
            if objects.count != 0 {
                self.rentedItemsList = objects
                self.rentedItems.reloadData()
            }
            
            }, error: 0)
        api.lentItemsForUser({ (let objects) -> () in
            if objects.count != 0 {
                self.lentItemsList = objects
                self.lendedItems.reloadData()
            }
            }, error: 0)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.rentedItems
        {
            return rentedItemsList.count
        } else if tableView == self.lendedItems
        {
            return lentItemsList.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == rentedItems
        {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(rentedIdentifier, forIndexPath: indexPath)
            cell.tag = indexPath.row
            cell.textLabel!.text = rentedItemsList[indexPath.row]["name"] as? String
            return cell
        } else if tableView == lendedItems
        {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(lentIdentifier, forIndexPath: indexPath)
            cell.tag = indexPath.row
            cell.textLabel!.text = lentItemsList[indexPath.row]["name"] as? String
            return cell
        }
        let cell = UITableViewCell()
        cell.textLabel!.text = "NULL"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == rentedItems
        {
            let rentalView = self.storyboard?.instantiateViewControllerWithIdentifier("RenterDetailView") as! RenterDetailViewController
            rentalView.item = self.rentedItemsList[indexPath.row]
            self.presentViewController(rentalView, animated: true, completion: nil)
        } else if tableView == lendedItems
        {
            let lenderView = self.storyboard?.instantiateViewControllerWithIdentifier("LenderDetailView") as! LenderDetailViewController
            lenderView.item = self.lentItemsList[indexPath.row]
            self.presentViewController(lenderView, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
