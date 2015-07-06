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
    @IBOutlet weak var collegeNameTextField: UITextField!
    @IBOutlet weak var collegeLocationTextField: UITextField!
    @IBOutlet weak var collegeEnrollmentTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var insertPicButton: UIButton!
    
    
    var collegeList:[String]!
    var colleges:[College]!
    let defaults = NSUserDefaults.standardUserDefaults()
    var imagePicker = UIImagePickerController()
    
    var collegeRecieved:College!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        
        collegeNameTextField.text = collegeRecieved.name
        
        let index = isItIn(collegeRecieved)
        if(index > -1){
            collegeImage.image = colleges[index].image
            collegeNameTextField.text = colleges[index].name
            collegeLocationTextField.text = colleges[index].location
            collegeEnrollmentTextField.text = String(colleges[index].enrollment)
        }
        
        //collegeImage.image = collegeRecieved.image
        //collegeNameTextField.text = collegeRecieved.name
        //collegeLocationTextField.text = collegeRecieved.location
        //collegeEnrollmentTextField.text = String(collegeRecieved.enrollment)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillShowNotification, object: nil);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonAction(sender: AnyObject) {
        if(collegeNameTextField.text != nil && collegeLocationTextField.text != nil && collegeEnrollmentTextField.text != nil && collegeNameTextField.text != "" && collegeLocationTextField.text != "" && collegeEnrollmentTextField.text != "" && collegeImage.image != nil){
            let toSave:College = College(name: collegeNameTextField.text!, location: collegeLocationTextField.text!, enrollment: Int(collegeEnrollmentTextField.text!)!, image: collegeImage.image!)
            colleges.append(toSave)
            saveData()
            
            let alert = UIAlertController(title: "Saved", message: "Saved successfully!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if(image != nil){
            collegeImage.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*func saveData(){
        defaults.setObject(collegeList, forKey: "collegeList")
        defaults.setObject(colleges, forKey: "Colleges")
        defaults.synchronize()
    }*/
    
    func saveData(){
        defaults.setObject(collegeList, forKey: "collegeList")
        let data = NSKeyedArchiver.archivedDataWithRootObject(colleges)
        defaults.setObject(data, forKey: "Colleges")
        defaults.synchronize()
    }
    
    @IBAction func pictureTapped(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    /*func isItIn(check: College)-> Int{
        for(var i = 0; i < colleges.count; i++){
            if(check.name == colleges[i].name && check.image == colleges[i].image && check.location == colleges[i].location && check.enrollment == colleges[i].enrollment){
                return i
            }
        }
        return -1
    }*/
    
    func isItIn(check: College)-> Int{
        for(var i = 0; i < colleges.count; i++){
            if(check.name == colleges[i].name){
                return i
            }
        }
        return -1
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
}
