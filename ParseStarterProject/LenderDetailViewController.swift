//
//  LenderDetailViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Derek Sanchez on 3/8/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class LenderDetailViewController: UIViewController {
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var renterLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    var rental: WigitRentalModel?
    let  api = WigitAPI()
    var item: PFObject?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if item != nil{
            api.rentalForItem(item!, completion: { (let rentalModel) in
                self.rental = rentalModel
                dispatch_async(dispatch_get_main_queue(), { 
                    self.itemNameLabel.text = self.item!["name"] as? String
                    self.renterLabel.text = self.rental!.renter!
                    switch self.rental!.itemStatus!
                    {
                    case 1:
                        self.statusLabel.text = "Rental requested"
                    case 2:
                        self.statusLabel.text = "Picked up by renter"
                    case 3:
                        self.statusLabel.text = "Returned to you"
                    case 4:
                        self.statusLabel.text = "Payment requested from renter"
                    case 5:
                        self.statusLabel.text = "Paid by renter. All done!"
                    default:
                        self.statusLabel.text = "Unknown"
                    }
                })
            })
        }
    }
    
    @IBAction func updateLenderStatus(sender: AnyObject)
    {
        if rental != nil
        {
            let statusAlert = UIAlertController(title: "Update Item Status", message: nil, preferredStyle: .ActionSheet)
            switch rental!.itemStatus!
            {
            case 1:
                let pickupAction = UIAlertAction(title: "Item has been picked up", style: .Default, handler: { (let action) in
                    self.api.updateRentalStatus(self.rental!, newStatus: 2)
                    self.alert("Status updated")
                })
                statusAlert.addAction(pickupAction)
            case 2:
                let returnAction = UIAlertAction(title: "Item has been returned on time", style: .Default, handler: { (let action) in
                    self.api.updateRentalStatus(self.rental!, newStatus: 3)
                    self.alert("Status updated")
                })
                statusAlert.addAction(returnAction)
            default:
                print("invalid status!")
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            statusAlert.addAction(cancelAction)
            self.presentViewController(statusAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func dismiss(sender: AnyObject)
    {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func alert(message: String)
    {
        let confirmation = UIAlertController(title: message, message: nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        confirmation.addAction(cancelAction)
        self.presentViewController(confirmation, animated: true, completion: nil)
    }
    
}
