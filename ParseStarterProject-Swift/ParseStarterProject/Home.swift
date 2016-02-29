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

class Home: UIViewController {
    
    @IBOutlet var introduction: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            // Do stuff with the user
            
            introduction.text = "Hi, " + (currentUser!["firstname"] as! String)
            
        } else {
            // Show the signup or login screen
            print("currentUser did not work in Home.swift")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
