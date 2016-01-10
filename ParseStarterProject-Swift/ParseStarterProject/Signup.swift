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

class Signup: UIViewController {
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var firstname: UITextField!
    @IBOutlet var lastname: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var email: UITextField!
    
    @IBOutlet var signupButton: UIButton!
    
    func displayAlert(var title:String, var message:String, var action:String, var view:UIViewController)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.Default, handler: nil))
        view.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func signup(sender: AnyObject) {
        if username.text == "" || password.text == "" || firstname.text == "" || lastname.text == "" || phone.text == "" || email.text == "" {
            displayAlert("Error!", message: "Please fill out all fields.", action: "Okay.", view: Signup())
            
        }
        else {
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            user["firstname"] = firstname.text
            user["lastname"] = lastname.text
            user["phone"] = phone.text
            user.email = email.text
            // other fields can be set just like with PFObject
            //user["phone"] = "415-392-0202"
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo?["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                    self.displayAlert("Error", message: "BIIIG PROBLEMO", action: "Sorry, my bad.", view: Signup())
                } else {
                    // Hooray! Let them use the app now.
                    self.displayAlert("Congratulations!", message: "You have signed up!", action: "Continue.", view: Signup())
                }
            }

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
