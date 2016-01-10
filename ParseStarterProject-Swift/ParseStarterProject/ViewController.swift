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

class ViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    
    @IBOutlet var rememberSwitch: UISwitch!
    @IBOutlet weak var login: UIButton!
    func displayAlert(var title:String, var message:String) {
        let alert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Okay")
        alert.show()
    }
    @IBAction func login(sender: AnyObject) {
        if username.text == "" || password.text == "" {
            displayAlert("You fucked up!", message: "Username and password are required.")
        }
        if username.text != "wyu13" {
            displayAlert("User not detected!", message: "Please fuck off.")
        }
        
        PFUser.logInWithUsernameInBackground("myname", password:"mypass") {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
            } else {
                self.displayAlert("COME ON, NIGGA", message: "Invalid login credentials.")
            }
        }

    }
    
    @IBAction func signup(sender: AnyObject) {
        
    }
    
    @IBAction func `switch`(sender: AnyObject) {
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
