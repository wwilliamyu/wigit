//
//  WigitPaymentModel.swift
//  ParseStarterProject-Swift
//
//  Created by Derek Sanchez on 3/7/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import Parse

class WigitPaymentModel: PFObject, PFSubclassing
{
    class func parseClassName() -> String {
        return "WigitPaymentModel"
    }
    
    //payer (relation)
    var payer: PFRelation? {
        get {
            return self.relationForKey("payer") as PFRelation
        }
        set {
            self["payer"] = newValue!
        }
    }
    
    //rental (relation)
    var rental: PFRelation? {
        get {
            return self.relationForKey("rental") as PFRelation
        }
        set {
            self["rental"] = newValue!
        }
    }
    
    //payee (relation)
    var payee: String? {
        get {
            return self["payee"] as? String
        }
        set {
            self["payee"] = newValue!
        }
    }
    
    //Paid Date
    var paidDate: String? {
        get {
            return self["paidDate"] as? String
        }
        set {
            self["paidDate"] = newValue!
        }
    }
    
    //Amount
    var amount: Double? {
        get {
            return self["amount"] as? Double
        }
        set {
            self["amount"] = newValue!
        }
    }
    
    /*paymentStatus
        0: created
        1: successful charge from payer to Wigit account
        2: successful charge from Wigit account to payee account
        3: declined failure
        4: insufficient funds failure
    */
    var paymentStatus: Int? {
        get {
            return self["paymentStatus"] as? Int
        }
        set {
            self["paymentStatus"] = newValue!
        }
    }
    
}
