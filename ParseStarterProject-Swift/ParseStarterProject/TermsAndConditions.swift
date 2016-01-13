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

class TermsAndConditions: UIViewController {
    
    @IBOutlet var acceptTAC: UIButton!
    @IBOutlet var declineTAC: UIButton!
    
    @IBOutlet var tacView: UIWebView!
    
    @IBAction func acceptTACButton(sender: AnyObject) {
        
        var user = PFUser()
        var currentUser = PFUser.currentUser()

        user.username = currentUser!.username
        user.password = currentUser!.password
        
//        if currentUser != nil {
//            // Do stuff with the user
//            user.username = currentUser!.username
//        } else {
//            // Show the signup or login screen
//            print("There is a problem with currentUser in TermsAndConditions.swift")
//        }
        
        user["acceptTAC"] = true
        
        user.signUpInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                self.performSegueWithIdentifier("DoneTermsAndConditions", sender: sender)
                
            } else {
                // There was a problem, check error.description
            }
        }
        
    }
    
    @IBAction func declineTACButton(sender: AnyObject) {
        self.performSegueWithIdentifier("DeclineTAC", sender: sender)
        PFUser.logOut()
        
        // testing purposes
        var currentUser = PFUser.currentUser()
        print(currentUser?.username)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let pdf = NSBundle.mainBundle().URLForResource("mp3_fa15", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(URL: pdf)
            tacView.loadRequest(req)
            self.view.addSubview(tacView)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
