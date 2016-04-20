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
import ParseUI
import Bolts

class ItemDetails: UIViewController, UINavigationBarDelegate {
    
    @IBOutlet var displayName: UILabel!
    @IBOutlet var displayPrice: UILabel!
    @IBOutlet var displayTags: UILabel!
    @IBOutlet var displayCategory: UILabel!
    @IBOutlet var displayReturnDate: UILabel!
    @IBOutlet var displayLocation: UILabel!
    @IBOutlet var thumbnail: PFImageView!
    var api = WigitAPI()
    var item: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if item != nil{
            if item!.objectForKey("name") != nil
            {
                self.displayName.text = "\(item!["name"])"
            }
            if item!.objectForKey("rental_price_daily") != nil
            {
                if item!["rental_price_daily"] as! Int != 0
                {
                    displayPrice.text = "$\(item!["rental_price_daily"])/Day"
                }
            }
            if item!.objectForKey("rental_price_onetime") != nil
            {
                if item!["rental_price_onetime"] as! Int != 0
                {
                    displayPrice.text = "$\(item!["rental_price_onetime"])"
                }
            }
            if item!.objectForKey("tags") != nil
            {
                displayTags.text = "\(item!["tags"])"
            }
            if item!.objectForKey("category") != nil
            {
                displayCategory.text = "\(item!["category"])"
            }
            if item!.objectForKey("return_date") != nil
            {
                displayReturnDate.text = "\(item!["return_date"])"
            }
            if item!.objectForKey("pickup_location") != nil
            {
                displayLocation.text = "\(item!["pickup_location"])"
            }
            if item!.objectForKey("thumbnail") != nil
            {
                thumbnail.file = item!["thumbnail"] as? PFFile
                thumbnail.loadInBackground()
            }
        }
    }
    
    @IBAction func requestRental()
    {
        if item != nil
        {
            var message = "Do you want to rent this item?"
            if item!.objectForKey("deposit") != nil && item!["deposit"] as! Int != 0
            {
                message = "Do you want to rent this item and pay a deposit of $\(item!["deposit"])?"
            }
            let rentalAlert = UIAlertController(title: "Rent Item", message: message, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let rentAction = UIAlertAction(title: "Rent", style: .Default, handler: { (let action) -> Void in
                dispatch_async(dispatch_get_main_queue(), { 
                    self.initiateRental()
                })
            })
            rentalAlert.addAction(cancelAction)
            rentalAlert.addAction(rentAction)
            self.presentViewController(rentalAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func dismiss(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initiateRental()
    {
        //Create a new WigitRentalModel
        let rental = WigitRentalModel()
        
        //Define the item, renter and lender properly
        rental.rentedItem?.addObject(item!)
        api.ownerForItem(item!) { (let user) in
            if user != nil
            {
                rental.lender?.addObject(user!)
                rental.lenderName = user!.username!
                print("rental now has lender of: \(rental.lenderName!)")
                rental.renter = PFUser.currentUser()!.username!
                rental.renterUser?.addObject(PFUser.currentUser()!)
                rental.dueDate = self.item!["return_date"] as? String
                //set the status to 1
                rental.itemStatus = 1
                rental.saveEventually()
                //Add rentalStatus of 1 to the item itself
                print("itemID: \(self.item!.objectId!)")
                let updatedItem = PFObject(withoutDataWithClassName: "RentedItem", objectId: self.item!.objectId!)
                updatedItem.setObject("1", forKey: "rentalStatus")
                updatedItem.saveEventually()
                if self.item!.objectForKey("deposit") != nil && self.item!["deposit"] as! Int! != 0
                {
                    self.processPayment((self.item!["deposit"] as? Int)!, payee: (self.item!["owner"] as? String)!)
                } else if self.api.tokenForUser() == nil || self.api.tokenForUser() == "NONE" {
                    let paymentInfoView = self.storyboard!.instantiateViewControllerWithIdentifier("PaymentInfo") as! PaymentInfoViewController
                    self.presentViewController(paymentInfoView, animated: true, completion: nil)
                }

            }
        }
    }
    
    func processPayment(deposit: Int, payee: String)
    {
        print("processing payent for user.")
        if api.tokenForUser() != nil && api.tokenForUser() != "NONE"
        {
            print("should be processing payment here.")
            api.makeStripeDeposit(api.tokenForUser()!, amount: Int(deposit * 100), payee:payee, completion: { Void in
                let successAlert = UIAlertController(title: "Payment Successful!", message: nil, preferredStyle: .Alert)
                successAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:
                    { Void in self.dismiss(self) })
                )
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(successAlert, animated: true, completion: nil)
                })
                
            })
        } else {
            //first time payment
            let paymentInfoView = self.storyboard!.instantiateViewControllerWithIdentifier("PaymentInfo") as! PaymentInfoViewController
            self.presentViewController(paymentInfoView, animated: true, completion: nil)
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
