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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
