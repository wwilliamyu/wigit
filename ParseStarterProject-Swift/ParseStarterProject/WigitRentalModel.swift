//
//  WigitRentalModel.swift
//  ParseStarterProject-Swift
//
//  Created by Derek Sanchez on 3/7/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import Parse

class WigitRentalModel: PFObject, PFSubclassing
{
    class func parseClassName() -> String {
        return "WigitRentalModel"
    }
    
    //rentedItem (relation)
    var rentedItem: PFRelation? {
        get {
            return self.relationForKey("rentedItem") as? PFRelation
        }
        set {
            self["rentedItem"] = newValue!
        }
    }
    
    //renterUser (relation)
    var renterUser: PFRelation? {
        get {
            return self.relationForKey("renterUser") as? PFRelation
        }
        set {
            self["rentarUser"] = newValue!
        }
    }
    
    //Lender (relation)
    var lender: PFRelation? {
        get {
            return self.relationForKey("lender") as? PFRelation
        }
        set {
            self["lender"] = newValue!
        }
    }
    
    //lenderName (String)
    var lenderName: String? {
        get {
            return self["lenderName"] as? String
        }
        set {
            self["lenderName"] = newValue!
        }
    }
    
    //Renter (relation)
    var renter: String? {
        get {
            return self["renter"] as? String
        }
        set {
            self["renter"] = newValue!
        }
    }
    
    //Rented Date
    var rentedDate: String? {
        get {
            return self["rentedDate"] as? String
        }
        set {
            self["rentedDate"] = newValue!
        }
    }
    
    //Due Date
    var dueDate: String? {
        get {
            return self["dueDate"] as? String
        }
        set {
            self["dueDate"] = newValue!
        }
    }
    
    //Returned Date
    var returnedDate: String? {
        get {
            return self["returnedDate"] as? String
        }
        set {
            self["returnedDate"] = newValue!
        }
    }
    
    //Cost
    var cost: String? {
        get {
            return self["cost"] as? String
        }
        set {
            self["cost"] = newValue!
        }
    }
    
    //Payment (relation)
    var payment: PFRelation? {
        get {
            return self["payment"] as? PFRelation
        }
        set {
            self["payment"] = newValue!
        }
    }
    
    //Per Diem?
    var perDiem: String? {
        get {
            return self["perDiem"] as? String
        }
        set {
            self["perDiem"] = newValue!
        }
    }
    
    /*Item Status: 
        0: none
        1: rent requested
        2: picked up
        3: returned
        4: returned and invoiced
        5: returned and paid
    */
    var itemStatus: Int? {
        get {
            return self["itemStatus"] as? Int
        }
        set {
            self["itemStatus"] = newValue!
        }
    }
    
    var displayName: String? {
        get {
            return self["displayName"] as? String
        }
        set {
            self["displayName"] = newValue!
        }
    }
    
    
}
