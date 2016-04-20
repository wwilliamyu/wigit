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

class ListItem: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var itemName: UITextField!
    @IBOutlet var priceSwitch: UISwitch!
    @IBOutlet var itemPrice: UITextField!
    @IBOutlet var deposit: UITextField!
    @IBOutlet var depositLabel: UILabel!
    
    @IBOutlet var itemTags: UITextField!
    @IBOutlet var itemCategory: UITextField!
    
    @IBOutlet var returnMonth: UITextField!
    @IBOutlet var returnDay: UITextField!
    @IBOutlet var returnYear: UITextField!
    
    @IBOutlet var pickupLocation: UITextField!
    
    @IBOutlet var itemDetails: UITextView!
    
    @IBOutlet var listItemButton: UIButton!
    @IBOutlet var addImageButton: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var thumbnail: UIImageView!
    let imagePicker = UIImagePickerController()
    
    func displayAlert(let title:String, let message:String, let action:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: action, style: .Default, handler: nil)
        //        { (action:UIAlertAction!) in
        //            println("you have pressed OK button");
        //        }
        alert.addAction(OKAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func listItem(sender: AnyObject) {
        if itemName.text == "" || itemPrice.text == "" || itemCategory.text == "" || returnMonth.text == "" || returnDay.text == "" || returnYear.text == "" || pickupLocation == "" || thumbnail.image == nil {
            
            self.displayAlert("Error!", message: "Please fill out all fields.", action: "Okay")
            
        }
        
        func saveItem(alert: UIAlertAction!) {
            var rentedItem = PFObject(className:"RentedItem")
            rentedItem["name"] = itemName.text!
            
            if priceSwitch.on {
                
                // check for decimals
                if let price = Float(itemPrice.text!)
                {
                    print("SETTING ONETIME PRICE")
                    rentedItem["rental_price_onetime"] = price
                }
                rentedItem["rental_price_daily"] = 0
            }
            else {
                rentedItem["rental_price_onetime"] = 0
                if let dailyPrice = Float(itemPrice.text!)
                {
                    rentedItem["rental_price_daily"] = dailyPrice
                }
            }
            
            if deposit.text == ""
            {
                rentedItem["deposit"] = 0
            } else {
                rentedItem["deposit"] = Int(deposit.text!)!
            }
            
            
            rentedItem["category"] = itemCategory.text!
            
            rentedItem["tags"] = itemTags.text! // future changes impending!!!
            
            // SET WHEN BUYING!!! ========================
            
            rentedItem["rental_time"] = 0
            rentedItem["renter"] = ""
            
            // ===========================================
            
            var currentUser = PFUser.currentUser()
            if currentUser != nil {
                // Do stuff with the user
                
                rentedItem["owner"] = (currentUser!["username"] as! String)
                rentedItem.relationForKey("ownerAccount").addObject(currentUser!)
            } else {
                // Show the signup or login screen
                print("There is a problem with currentUser in ListItem.swift")
            }
            
            if self.thumbnail.image != nil
            {
                rentedItem["thumbnail"] = PFFile(data: UIImagePNGRepresentation(self.thumbnail.image!)!)
            }

            
            rentedItem["pickup_location"] = pickupLocation.text!
            
            
            // SET WHEN BUYING!!! ========================
            
            rentedItem["start_date"] = ""
            
            // ===========================================
            
            rentedItem["return_date"] = returnMonth.text! + "-" + returnDay.text! + "-" + returnYear.text!
            rentedItem["item_description"] = itemDetails.text
            
            
            rentedItem.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    func confirmedListing(alert: UIAlertAction!) {
                        let api = WigitAPI()
                        api.geocodeAddress(rentedItem["pickup_location"] as! String, completion: { (let lat, let lon, let error) in
                            if error == 0
                            {
                                print("saving coordinates of \(lat), \(lon)")
                                rentedItem["coordinates"] = PFGeoPoint(latitude: lat, longitude: lon)
                                rentedItem.saveEventually()
                                dispatch_async(dispatch_get_main_queue(), {
                                    let details = self.storyboard!.instantiateViewControllerWithIdentifier("itemDetails") as! ItemDetails
                                    details.item = rentedItem
                                    self.presentViewController(details, animated: true, completion: nil)
                                })
                            }
                        })
                        
                    }
                    
                    let alert = UIAlertController(title: "Congratulations", message: "You have listed an item!", preferredStyle: .Alert)
                    
                    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: confirmedListing))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                } else {
                    // There was a problem, check error.description
                    self.displayAlert("Error!", message: "There was a problem with your listing.", action: "Well, fuck")
                }
            }
        }
        
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure these details are correct?", preferredStyle: .Alert)
    
        
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: saveItem))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        itemDetails.layer.cornerRadius = 5
        
    }
    
    @IBAction func addImage(sender: AnyObject)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .Camera
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setImage(image: UIImage)
    {
        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.2, 0.2))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        thumbnail.image = scaledImage
    }
    
    @IBAction func SwitchChanged(switchState: UISwitch)
    {
        /*
        if switchState.on
        {
            self.deposit.hidden = true
            self.depositLabel.hidden = true
        } else {
            self.deposit.hidden = false
            self.depositLabel.hidden = false
        }
         */
    }
    
    //MARK -- UIImagePickerControllerDelegate Method
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("entering UIImagePickerController delegate method.")
        addImageButton.setTitle(" ", forState: .Normal)
        picker.dismissViewControllerAnimated(true, completion: nil)
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            setImage(pickedImage)
        }
    }
    
}

