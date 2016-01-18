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

class MyProfile: UIViewController {

    @IBOutlet var profUsername: UITextField!
    @IBOutlet var profPassword: UITextField!
    @IBOutlet var profFirstName: UITextField!
    @IBOutlet var profLastName: UITextField!
    @IBOutlet var profPhone: UITextField!
    @IBOutlet var profEmail: UITextField!
    
    @IBOutlet var currPassword: UITextField!
    
    var currentUser = PFUser.currentUser()
    
    @IBAction func submitChangeProfile(sender: AnyObject) {
        if currPassword.text == "" {
            let alert = UIAlertController(title: "Error!", message: "Please confirm your password.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        if profUsername.text == "" && profPassword.text == "" && profFirstName.text == "" && profLastName.text == "" && profPhone.text == "" && profEmail.text == "" {
            
            let alert = UIAlertController(title: "Error!", message: "You have not changed anything.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        //this part could be security problem?
        
        if currPassword.text != currentUser?.password {
            let alert = UIAlertController(title: "Error!", message: "You have not changed anything.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    
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