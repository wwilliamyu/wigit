//
//  RenterDetailViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Derek Sanchez on 3/8/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class RenterDetailViewController: UIViewController {
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var lenderLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var paymentButton: UIButton!
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
                    self.lenderLabel.text = self.rental!.lenderName!
                    self.dueDateLabel.text = self.rental!.dueDate!
                    self.paymentButton.hidden = true
                    switch self.rental!.itemStatus!
                    {
                    case 1:
                        self.statusLabel.text = "Pickup requested"
                    case 2:
                        self.statusLabel.text = "Picked up by you"
                    case 3:
                        self.statusLabel.text = "Returned to lender"
                        self.paymentButton.hidden = false
                    case 4:
                        self.statusLabel.text = "Payment requested from you"
                        self.paymentButton.hidden = false
                    case 5:
                        self.statusLabel.text = "Paid by you. All done!"
                    default:
                        self.statusLabel.text = "Unknown"
                    }
                })
            })
        }
    }
    
    /*@IBAction func updateLenderStatus(sender: AnyObject)
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
    */
    
    @IBAction func payForRental(sender: AnyObject)
    {
      let paymentAlert = UIAlertController(title: "Rental Payment", message: "Do you want to pay $\(self.rentalAmount()) for \(self.item!["name"] as! String)?", preferredStyle: .Alert)
      paymentAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        let payAction = UIAlertAction(title: "Pay", style: .Default) { (let action) in
            self.processPayment()
        }
        paymentAlert.addAction(payAction)
        self.presentViewController(paymentAlert, animated: true, completion: nil)
    }
    
    func rentalAmount() -> Double
    {
        var amount = 0.0
        if self.item!.objectForKey("rental_price_onetime") != nil && self.item!["rental_price_onetime"] as! Double > 0.0
        {
            amount = self.item!["rental_price_onetime"] as! Double
        }
        else if self.item!.objectForKey("rental_price_daily") != nil && self.item!["rental_price_daily"] as! Double > 0.0
        {
            amount = self.item!["rental_price_daily"] as! Double
        }
        return amount
    }
    
    func processPayment()
    {
        if api.tokenForUser() != nil && api.tokenForUser() != "NONE"
        {
            print("should be processing payment here.")
                api.makeStripePayment(api.tokenForUser()!, amount: Int(self.rentalAmount() * 100), rental: self.rental!, completion: { Void in
                self.api.updateRentalStatus(self.rental!, newStatus: 5)
                    if self.item!.objectForKey("deposit") != nil && self.item!["deposit"] as! Int != 0
                    {
                        self.api.ownerForItem(self.item!, completion: { (let owner) in
                            if owner != nil
                            {
                                self.api.reverseStripeDeposit(self.rental!, lender: owner!, amount: Int((self.item!["deposit"] as! Int) * 100), completion: {
                                    
                                })
                            }
                        })
                        
                    }
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
