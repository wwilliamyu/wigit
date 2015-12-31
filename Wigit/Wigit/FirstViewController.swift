//
//  FirstViewController.swift
//  Wigit
//
//  Created by Jason Holtkamp on 12/26/15.
//  Copyright © 2015 Wigit, inc. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    
    @IBAction func login(sender: AnyObject) {
        if  (username.text == "" || password.text == "") {
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }


    @IBAction func signup(sender: AnyObject) {
        if  (username.text == "" || password.text == "") {
            
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

