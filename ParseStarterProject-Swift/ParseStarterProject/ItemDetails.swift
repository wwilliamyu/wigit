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

class ItemDetails: UIViewController {
    
    @IBOutlet var displayName: UILabel!
    @IBOutlet var displayPrice: UILabel!
    @IBOutlet var displayTags: UILabel!
    @IBOutlet var displayCategory: UILabel!
    @IBOutlet var displayReturnDate: UILabel!
    @IBOutlet var displayLocation: UILabel!
    var item: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if item != nil{
            if item!.objectForKey("name") != nil
            {
                self.displayName.text = "\(item!["name"])"
            }
            if item!.objectForKey("rental_price_daily") != nil
            {
                if item!["rental_price_daily"] as! Int != 0
                {
                    displayPrice.text = "$\(item!["rental_price_daily"])/Day"
                }
            }
            if item!.objectForKey("rental_price_onetime") != nil
            {
                if item!["rental_price_onetime"] as! Int != 0
                {
                    displayPrice.text = "$\(item!["rental_price_onetime"])"
                }
            }
            if item!.objectForKey("tags") != nil
            {
                displayTags.text = "\(item!["tags"])"
            }
            if item!.objectForKey("category") != nil
            {
                displayCategory.text = "\(item!["category"])"
            }
            if item!.objectForKey("return_date") != nil
            {
                displayReturnDate.text = "\(item!["return_date"])"
            }
            if item!.objectForKey("pickup_location") != nil
            {
                displayLocation.text = "\(item!["pickup_location"])"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
