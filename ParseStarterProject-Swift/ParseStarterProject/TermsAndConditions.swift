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
    
    @IBAction func acceptTACButton(sender: AnyObject) {
        
        var user = PFUser()
        var currentUser = PFUser.currentUser()
        
        user.username = currentUser!.username
        user["acceptTAC"] = true
        
        user.saveInBackgroundWithBlock {
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
