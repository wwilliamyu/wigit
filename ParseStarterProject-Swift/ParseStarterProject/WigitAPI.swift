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
import CoreLocation
import LMGeocoder

class WigitAPI: NSObject, CLLocationManagerDelegate
{
    var locationManager: CLLocationManager!
    
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
            query.whereKey("owner", notEqualTo: currentUser!.username!)
            query.findObjectsInBackgroundWithBlock({ (let objects, let error) -> Void in
                if objects != nil {
                    completion(objects, error)
                } else {
                    completion(nil, error)
                }
            })
        }
    }
    
    func nearbyItems(completion: PFQueryArrayResultBlock, error: Int)
    {
        let currentUser = PFUser.currentUser()
        if currentUser != nil
        {
            PFGeoPoint.geoPointForCurrentLocationInBackground({ (let point, let error) in
                if point != nil
                {
                    let query = PFQuery(className: "RentedItem")
                    query.whereKey("coordinates", nearGeoPoint: point!)
                    query.whereKey("rentalStatus", notEqualTo:"1")
                    query.whereKey("owner", notEqualTo:currentUser!.username!)
                    query.findObjectsInBackgroundWithBlock({ (let objects, let error) -> Void in
                        if objects != nil {
                            completion(objects, error)
                        } else {
                            completion(nil, error)
                        }
                    })

                }
            })
        }
    }
    
    //returns an array of rentals where either renter or lender are the current user
    func rentalsForUser(completion: ([WigitRentalModel])->())
    {
        let currentUser = PFUser.currentUser()
        if currentUser != nil
        {
            let renterQuery = PFQuery(className: "WigitRentalModel")
            renterQuery.whereKey("renter", equalTo:currentUser!["username"] as! String)
            let lenderQuery = PFQuery(className: "WigitRentalModel")
            lenderQuery.whereKey("lender", equalTo:currentUser!["username"] as! String)
            let completeQuery = PFQuery(className: "WigitRentalModel")
            completeQuery.whereKey("itemStatus", notEqualTo:5)
            let query = PFQuery.orQueryWithSubqueries([renterQuery, lenderQuery, completeQuery])

            query.findObjectsInBackgroundWithBlock({ (let objects, let error) in
                if objects != nil
                {
                    completion(objects as! [WigitRentalModel])
                }
            })
        }
    }
    
    func updatePaymentToken(token: String)
    {
        let currentUser = PFUser.currentUser()
        if currentUser != nil
        {
            PFCloud.callFunctionInBackground("createCustomer", withParameters: ["tokenId" : token], block: { (let objects, let error) in
                print("RESPONSE: \(objects)")
                if (objects as? String) != nil
                {
                    currentUser!["paymentToken"] = objects as! String
                    currentUser!.saveEventually()
                }
            })
        }
    }
    
    func tokenForUser() -> String?
    {
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            if currentUser!.objectForKey("paymentToken") != nil
            {
                return currentUser!["paymentToken"] as? String
            }
            return nil
        }
        return nil
    }
    
    func rentalForItem(item: PFObject, completion:(WigitRentalModel)->())
    {
        self.rentalsForUser { (let models) in
            for model in models
            {
                let itemQuery = model.rentedItem!.query()
                itemQuery.findObjectsInBackgroundWithBlock({ (let objects, let error) in
                    if objects != nil
                    {
                        print("rentals are not nil. First object has id of \(objects!.first!.objectId!). test object as id of \(item.objectId!)")
                        if objects!.first!.objectId! == item.objectId!
                        {
                            completion(model)
                        }
                    }
                })
            }
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
    
    func geocodeAddress(address: String, completion:(Double, Double, Int)->())
    {
        LMGeocoder.sharedInstance().geocodeAddressString(address, service: .AppleService) { (let locations, let error) in
            if let location = locations.first! as? LMAddress
            {
                print("coordinates: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                completion(Double(location.coordinate.latitude), Double(location.coordinate.longitude), 0)
            } else {
                completion(0.0, 0.0, 1)
            }
        }
    }
    
    func coordinatesForCurrentLocation() -> (Double, Double)
    {
        let coordinates = (0.0, 0.0)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse
        {
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        return coordinates
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            
        }
    }

    
    func updateRentalStatus(rental: WigitRentalModel!, newStatus: Int!)
    {
        //change rental's status and save
        rental.itemStatus = newStatus
        rental.saveInBackground()
    }
    
    func makeStripePayment(tokenId: String, amount: Int, rental: WigitRentalModel, completion:()->()) {
        let params: [String: NSObject] = ["customerId": tokenId,
                                          "amount": amount]
        PFCloud.callFunctionInBackground("chargeCustomer", withParameters: params) { (result, error) -> Void in
            if error == nil {
                print(result)
                let payment = WigitPaymentModel()
                payment.payer?.addObject(PFUser.currentUser()!)
                payment.rental?.addObject(rental)
                payment.payee = rental.lender!
                let dateFormatter:NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy"
                let dateInFormat:String = dateFormatter.stringFromDate(NSDate())
                payment.paidDate = dateInFormat
                payment.amount = Double(amount) / 100
                payment.paymentStatus = 1
                payment.saveEventually()
                completion()
            } else {
                print(error)
            }
        }
    }
    
}
