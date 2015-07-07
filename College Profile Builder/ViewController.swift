//
//  ViewController.swift
//  College Profile Builder
//
//  Created by Rohan Daruwala on 7/6/15.
//  Copyright © 2015 Rohan Daruwala. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var collegeList:[String]!
    var colleges:[College]!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.tag = 0
        
        collegeList = defaults.objectForKey("collegeList") as? [String]
        let tempData = NSUserDefaults.standardUserDefaults().objectForKey("Colleges") as? NSData
        
        if let tempData = tempData{
            colleges = NSKeyedUnarchiver.unarchiveObjectWithData(tempData) as? [College]
        }
        //colleges = defaults.objectForKey("Colleges") as? [College]
        
        
        if(collegeList == nil){
            collegeList = []
        }
        if(colleges == nil){
            colleges = []
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collegeList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = collegeList[indexPath.row]
        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            let index = isItIn(College(name: collegeList[indexPath.row]))
            collegeList.removeAtIndex(indexPath.row)
            if(index > -1){
                colleges.removeAtIndex(indexPath.row)
            }
            saveData()
            tableView.reloadData()
        }
    }
    
    @IBAction func onPlusButtonAction(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add College", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Add college name here"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(cancelAction)
        
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { (action) -> Void in
            let collegeTextField = alert.textFields![0] as UITextField
            self.collegeList.append(collegeTextField.text!)
            self.saveData()
            self.tableView.reloadData()
        }
        alert.addAction(addAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func editButtonAction(sender: UIBarButtonItem) {
        if(sender.tag == 0){
            tableView.editing = true
            sender.tag = 1
        }
        else{
            tableView.editing = false
            sender.tag  = 0
        }
    }
    
    func saveData(){
        defaults.setObject(collegeList, forKey: "collegeList")
        let data = NSKeyedArchiver.archivedDataWithRootObject(colleges)
        defaults.setObject(data, forKey: "Colleges")
        defaults.synchronize()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! displayCollegeViewController
        let index = tableView.indexPathForSelectedRow?.row
        destination.collegeRecieved = College(name:collegeList[index!])
        
    }
    
    func isItIn(check: College)-> Int{
        for(var i = 0; i < colleges.count; i++){
            if(check.name == colleges[i].name){
                return i
            }
        }
        return -1
    }
    
}

