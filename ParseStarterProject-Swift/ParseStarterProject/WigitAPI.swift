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
    
    func allItems(completion: PFQueryArrayResultBlock, error: Int)
    {
        
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            let query = PFQuery(className: "RentedItem")
            query.limit = 100
            //Don't retrieve rented items.
            query.whereKey("rentalStatus", notEqualTo: "1")
            query.findObjectsInBackgroundWithBlock({ (let objects, let error) -> Void in
                if objects != nil {
                    completion(objects, error)
                } else {
                    completion(nil, error)
                }
            })
        }
    }
    
    func rentedItemsForUser(completion: ([PFObject])->(), error: Int)
    {
        let currentUser = PFUser.currentUser()
        if currentUser != nil
        {
            let query = PFQuery(className: "WigitRentalModel")
            query.limit = 100
            query.whereKey("renter", equalTo:currentUser!["username"] as! String)
            query.whereKey("itemStatus", notEqualTo: 5)
            query.findObjectsInBackgroundWithBlock({ (let objects, let error) -> Void in
                if objects != nil
                {
                    print("rented items: \(objects)")
                    var items = [PFObject]()
                    var i = 0
                    for rental in objects! as! [WigitRentalModel]
                    {
                        if let item = rental.rentedItem
                        {
                            let itemQuery = item.query()
                            itemQuery.findObjectsInBackgroundWithBlock({ (let objects, let error) in
                                if objects != nil {
                                    items.append(objects!.first!)
                                    i += 1
                                    print("on item #\(i)")
                                    if i >= objects!.count {
                                        completion(items)
                                    }
                                }
                            })
                        }
                    }
                    
                } else {
                    let items = [PFObject]()
                    completion(items)
                }
            })
        }
    }
    
    func lentItemsForUser(completion: ([PFObject])->(), error: Int)
    {
        let currentUser = PFUser.currentUser()
        if currentUser != nil
        {
            let query = PFQuery(className: "WigitRentalModel")
            query.limit = 100
            query.whereKey("lender", equalTo:currentUser!["username"] as! String)
            query.whereKey("itemStatus", notEqualTo: 5)
            query.findObjectsInBackgroundWithBlock({ (let objects, let error) -> Void in
                if objects != nil
                {
                    print("lent items: \(objects)")
                    var items = [PFObject]()
                    var i = 0
                    for rental in objects! as! [WigitRentalModel]
                    {
                        if let item = rental.rentedItem
                        {
                            let itemQuery = item.query()
                            itemQuery.findObjectsInBackgroundWithBlock({ (let objects, let error) in
                                if objects != nil {
                                    items.append(objects!.first!)
                                    i += 1
                                    print("on item #\(i)")
                                    if i >= objects!.count {
                                        completion(items)
                                    }
                                }
                            })
                        }
                    }
                    
                } else {
                    let items = [PFObject]()
                    completion(items)
                }

            })
        }
    }
    
}
