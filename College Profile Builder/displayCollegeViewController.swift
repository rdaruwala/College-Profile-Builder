//
//  displayCollegeViewController.swift
//  College Profile Builder
//
//  Created by Rohan Daruwala on 7/6/15.
//  Copyright © 2015 Rohan Daruwala. All rights reserved.
//

import UIKit

class displayCollegeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collegeImage: UIImageView!
    
    @IBOutlet weak var collegeNameTextField: UILabel!
    @IBOutlet weak var collegeLocationTextField: UITextField!
    @IBOutlet weak var collegeEnrollmentTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var insertPicButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var latitudeTextField: UITextField!
    
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var viewOnMapButton: UIButton!
    
    
    var collegeList:[String]!
    var colleges:[College]!
    let defaults = NSUserDefaults.standardUserDefaults()
    var imagePicker = UIImagePickerController()
    
    var collegeRecieved:College!
    
    var index:Int!
    var loadButtonBool:Bool!
    
    
    /**
    Runs when the view is loaded. Loads arrays from NSUserDefaults, then sets them to empty if they are nil. Creates borders around the buttons. If recieved college is not in the colleges array, the 'load' button is hidden.
    **/
    override func viewDidLoad() {
        super.viewDidLoad()
        loadButtonBool = true
        
        collegeImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        imagePicker.delegate = self
        
        collegeList = defaults.objectForKey("collegeList") as? [String]
        let tempData = NSUserDefaults.standardUserDefaults().objectForKey("Colleges") as? NSData
        
        if let tempData = tempData{
            colleges = NSKeyedUnarchiver.unarchiveObjectWithData(tempData) as? [College]
        }
        
        
        if(collegeList == nil){
            collegeList = []
        }
        if(colleges == nil){
            colleges = []
        }
        
        saveButton.backgroundColor = UIColor.clearColor()
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderWidth = 3
        saveButton.layer.borderColor = UIColor.blueColor().CGColor
        
        insertPicButton.backgroundColor = UIColor.clearColor()
        insertPicButton.layer.cornerRadius = 10
        insertPicButton.layer.borderWidth = 3
        insertPicButton.layer.borderColor = UIColor.blueColor().CGColor
        
        loadButton.backgroundColor = UIColor.clearColor()
        loadButton.layer.cornerRadius = 10
        loadButton.layer.borderWidth = 3
        loadButton.layer.borderColor = UIColor.blueColor().CGColor
        
        viewOnMapButton.backgroundColor = UIColor.clearColor()
        viewOnMapButton.layer.cornerRadius = 10
        viewOnMapButton.layer.borderWidth = 3
        viewOnMapButton.layer.borderColor = UIColor.blueColor().CGColor
        
        collegeNameTextField.text = collegeRecieved.name
        
        index = isItIn(collegeRecieved)
        
        viewOnMapButton.hidden = true
        
        if(index == -1){
            loadButton.hidden = true
        }
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
    }
    
    /**
    Moves the screen when keyboard is opened and closed
    **/
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 125
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 125
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    If all the fields are filled, check to see if the college is already saved. If it is, then delete it. Then save, and display a notification.
    **/
    @IBAction func saveButtonAction(sender: AnyObject) {
        if(collegeNameTextField.text != nil && collegeLocationTextField.text != nil && collegeEnrollmentTextField.text != nil && collegeNameTextField.text != "" && collegeLocationTextField.text != "" && collegeEnrollmentTextField.text != "" && collegeImage.image != nil && urlTextField.text != "" && urlTextField.text != nil && latitudeTextField.text != "" && longitudeTextField.text != "" && latitudeTextField.text != nil && longitudeTextField.text != nil){
            let toSave:College = College(name: collegeNameTextField.text!, location: collegeLocationTextField.text!, enrollment: Int(collegeEnrollmentTextField.text!)!, image: collegeImage.image!, webURL: urlTextField.text!, latitude: Double(latitudeTextField.text!)!, longitude: Double(longitudeTextField.text!)!)
            if (index != -1){
                colleges.removeAtIndex(index)
            }
            colleges.append(toSave)
            saveData()
            viewOnMapButton.hidden = false
            let alert = UIAlertController(title: "Saved", message: "Saved successfully!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /**
    Picks an image to show in the image view
    **/
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if(image != nil){
            collegeImage.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
    Saves the data to NSUserData
    **/
    func saveData(){
        defaults.setObject(collegeList, forKey: "collegeList")
        let data = NSKeyedArchiver.archivedDataWithRootObject(colleges)
        defaults.setObject(data, forKey: "Colleges")
        defaults.synchronize()
    }
    
    /**
    When the picture select button is tapped, open an image picker
    **/
    @IBAction func pictureTapped(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    /**
    Check to see if a college with the given college's name exists in the array
    **/
    func isItIn(check: College)-> Int{
        for(var i = 0; i < colleges.count; i++){
            if(check.name == colleges[i].name){
                return i
            }
        }
        return -1
    }
    
    /**
    Loads college from array using the value obtained from index (if the college is saved or not)
    **/
    func loadCollegeView(){
        if(index > -1){
            collegeImage.image = colleges[index].image
            collegeNameTextField.text = colleges[index].name
            collegeLocationTextField.text = colleges[index].location
            collegeEnrollmentTextField.text = String(colleges[index].enrollment)
            urlTextField.text = colleges[index].webURL
            latitudeTextField.text = String(colleges[index].latitude)
            longitudeTextField.text = String(colleges[index].longitude)
            
            viewOnMapButton.hidden = false
        }
    }
    /**
    Calls the load function if the load button is clicked. Once it's clicked, it changes to a 'View URL' button which serves as a segue to the URL
    **/
    @IBAction func loadButtonAction(sender: AnyObject) {
        if(loadButtonBool == true){
            loadCollegeView()
            loadButtonBool = false
            loadButton.setTitle("Visit Website", forState: UIControlState.Normal)
            viewOnMapButton.hidden = false
        }
        else{
            self.performSegueWithIdentifier("modalWebView", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "modalWebView"){
            let next = segue.destinationViewController as? UINavigationController
            let vc = next?.topViewController as? webViewController
            vc!.webURL = colleges[index].webURL
        }
        else if(segue.identifier == "mapViewSegue"){
            //let next = segue.destinationViewController as? UINavigationController
            //let vc = next?.topViewController as? mapViewController
            
            let vc = segue.destinationViewController as! mapViewController
            vc.collegeRecieved = colleges[index]
        }
    }
    
    @IBAction func showOnMapAction(sender: AnyObject) {
        self.performSegueWithIdentifier("mapViewSegue", sender: self)
    }
    
    
}
