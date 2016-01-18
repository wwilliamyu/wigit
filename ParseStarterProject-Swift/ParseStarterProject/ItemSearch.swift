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

class ItemSearch: UIViewController {
    
    @IBOutlet var itemName: UITextField!
    
    // ============== OPTIONAL ===============================
    
    @IBOutlet var itemCategory: UITextField!
    @IBOutlet var itemTags: UITextField!
    @IBOutlet var itemRentalTime: UITextField!
    @IBOutlet var itemMinPrice: UITextField!
    @IBOutlet var itemMaxPrice: UITextField!
    @IBOutlet var priceSwitch: UISwitch!
    
    // =======================================================
    
    @IBAction func searchItemButton(sender: AnyObject) {
        
        if itemName.text == "" && itemCategory.text == "" {
            let alert = UIAlertController(title: "The fuck, man?!", message: "Fill in the motherfuckin fields!", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "Yes, master", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        self.performSegueWithIdentifier("SearchItem", sender: sender)
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
