//
//  WigitAPI.swift
//  ParseStarterProject-Swift
//
//  Created by Derek Sanchez on 3/1/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import Parse
import Bolts

class WigitAPI: NSObject
{
    func itemsForCurrentUser() -> [PFObject]
    {
        let currentUser = PFUser.currentUser()
        var retval = [PFObject]()
        if currentUser != nil {
            let query = PFQuery(className: "RentedItem")
            query.whereKey("owner", equalTo: currentUser!["username"] as! String)
            query.findObjectsInBackgroundWithBlock({ (let objects, let error) -> Void in
                if objects != nil
                {
                    retval = objects!;
                }
            })
        }
        return retval
    }
    
    func allItems(completion: PFQueryArrayResultBlock?, error: Int)
    {
        
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            let query = PFQuery(className: "RentedItem")
            query.limit = 100
            query.findObjectsInBackgroundWithBlock({ (let objects, let error) -> Void in
                if objects != nil {
                    completion!(objects, error)
                } else {
                    completion!(nil, error)
                }
            })
        }
    }
    
}
