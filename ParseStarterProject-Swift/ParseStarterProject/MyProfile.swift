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
    
    func displayAlert(var title:String, var message:String, var action:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: action, style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitChangeProfile(sender: AnyObject) {
        if currPassword.text == "" {
            
            displayAlert("Error!", message: "Please enter your current password!", action: "Okay")
        }
        
        if profUsername.text == "" && profPassword.text == "" && profFirstName.text == "" && profLastName.text == "" && profPhone.text == "" && profEmail.text == "" {
        
            displayAlert("Error!", message: "You have not changed anything.", action: "Okay")
        }
        //this part could be security problem?
        
        if currPassword.text != currentUser?.password {
            
            displayAlert("Error!", message: "Your password is incorrect.", action: "Okay")
        }
        
        // write modification code
        if profUsername.text != "" {
            currentUser!.username = profUsername.text
        }
        
        if profPassword.text != "" {
            currentUser!.password = profPassword.text
        }
    
        if profFirstName.text != "" {
            currentUser!["firstname"] = profFirstName.text
        }
        
        if profLastName.text != "" {
            currentUser!["lastname"] = profLastName.text
        }
        
        if profPhone.text != "" {
            currentUser!["phone"] = profPhone.text
        }
        
        if profEmail.text != "" {
            currentUser!.email = profEmail.text
        }
        
        currentUser!.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                self.displayAlert("Complete", message: "Your profile has been changed.", action: "Okay")

                
            } else {
                // There was a problem, check error.description
                print("BOB ROSS' HAPPY LITTLE ACCIDENTS")
            }
        }
        
    }
    
    @IBAction func ProfileLogoff(sender: AnyObject) {
        PFUser.logOut()
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
