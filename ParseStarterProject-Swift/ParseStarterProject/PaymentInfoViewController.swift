//
//  PaymentInfoViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Derek Sanchez on 3/8/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Stripe

class PaymentInfoViewController: UIViewController, STPPaymentCardTextFieldDelegate {
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var nameField: UITextField!
    var paymentTextField = STPPaymentCardTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.hidden = true
        paymentTextField.frame = CGRectMake(15, 72, CGRectGetWidth(self.view.frame) - 30, 44)
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
    }
    
    @IBAction func dismiss(sender: AnyObject)
    {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        // Toggle navigation, for example
        saveButton.hidden = !textField.valid
    }
    
    @IBAction func save(sender: UIButton) {
        if nameField.text! != "" {
            let card = paymentTextField.cardParams
            STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
                if let error = error  {
                    print("Stripe error: \(error.localizedDescription)")
                }
                else if token != nil {
                    let api = WigitAPI()
                    api.updatePaymentToken(token!.tokenId)
                    print("updated token: \(token!.tokenId)")
                    STPAPIClient.sharedClient().createTokenWithCard(card, completion: { (token, error) in
                        if let error = error {
                            print ("Stripe error: \(error.localizedDescription)")
                        }
                        else if token != nil
                        {
                            print("new token: \(token!.tokenId)");
                            WigitAPI().updateRecipientToken(token!.tokenId, name: self.nameField.text!)
                        }
                    })
                }
            }
        } else
        {
            let nameAlert = UIAlertController(title: "Please enter your full legal name.", message: nil, preferredStyle: .Alert)
            nameAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(nameAlert, animated: true, completion: nil)
        }
    }
    

}
