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

class ListItem: UIViewController {

    @IBOutlet var itemName: UITextField!
    @IBOutlet var priceSwitch: UISwitch!
    @IBOutlet var itemPrice: UITextField!
    
    @IBOutlet var itemTags: UITextField!
    @IBOutlet var itemCategory: UITextField!
    
    @IBOutlet var returnMonth: UITextField!
    @IBOutlet var returnDay: UITextField!
    @IBOutlet var returnYear: UITextField!
    
    @IBOutlet var pickupLocation: UITextField!
    
    @IBOutlet var itemDetails: UITextView!
    
    @IBOutlet var listItemButton: UIButton!
    
    func displayAlert(var title:String, var message:String, var action:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: action, style: .Default, handler: nil)
        //        { (action:UIAlertAction!) in
        //            println("you have pressed OK button");
        //        }
        alert.addAction(OKAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func listItem(sender: AnyObject) {
        if itemName.text == "" || itemPrice.text == "" || itemCategory.text == "" || returnMonth.text == "" || returnDay.text == "" || returnYear.text == "" || pickupLocation == "" {
            
            self.displayAlert("Error!", message: "Please fill out all fields.", action: "Okay")
            
        }
        
        func saveItem(alert: UIAlertAction!) {
            var rentedItem = PFObject(className:"RentedItem")
            rentedItem["name"] = itemName.text
            
            if priceSwitch.on {
                rentedItem["rental_price_onetime"] = itemPrice.text.toInt()!
                rentedItem["rental_price_daily"] = 0
            }
            else {
                rentedItem["rental_price_onetime"] = 0
                rentedItem["rental_price_daily"] = itemPrice.text.toInt()!
            }
            
            rentedItem["category"] = itemCategory.text
            
            rentedItem["tags"] = itemTags.text // future changes impending!!!
            
            // SET WHEN BUYING!!! ========================
            
            rentedItem["rental_time"] = 0
            rentedItem["renter"] = ""
            
            // ===========================================
            
            var currentUser = PFUser.currentUser()
            if currentUser != nil {
                // Do stuff with the user
                
                rentedItem["owner"] = (currentUser!["username"] as! String)
                
            } else {
                // Show the signup or login screen
                print("There is a problem with currentUser in ListItem.swift")
            }

            
            rentedItem["pickup_location"] = pickupLocation.text
            
            
            // SET WHEN BUYING!!! ========================
            
            rentedItem["start_date"] = ""
            
            // ===========================================
            
            rentedItem["return_date"] = returnMonth.text + "-" + returnDay.text + "-" + returnYear.text
            rentedItem["item_description"] = itemDetails.text
            
            
            rentedItem.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    func confirmedListing(alert: UIAlertAction!) {
                        self.performSegueWithIdentifier("ListedItem", sender: sender)
                    }
                    
                    let alert = UIAlertController(title: "Congratulations", message: "You have listed an item!", preferredStyle: .Alert)
                    
                    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: confirmedListing))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                } else {
                    // There was a problem, check error.description
                    self.displayAlert("Error!", message: "There was a problem with your listing.", action: "Well, fuck")
                }
            }
        }
        
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure these details are correct?", preferredStyle: .Alert)
    
        
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: saveItem))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        itemDetails.layer.cornerRadius = 5
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

