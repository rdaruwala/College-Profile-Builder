//
//  mapViewController.swift
//  College Profile Builder
//
//  Created by Rohan Daruwala on 7/8/15.
//  Copyright © 2015 Rohan Daruwala. All rights reserved.
//

import UIKit
import MapKit

class mapViewController: UIViewController, UITextFieldDelegate {
    
    var collegeRecieved : College!
    
    @IBOutlet weak var mapViewObject: MKMapView!
    @IBOutlet weak var inputTextField: UITextField!
    
    /**
    Runs when the view is loaded. Displays the map and drops a pin on the college's location
    **/
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.text = "" + collegeRecieved.name + ", " + collegeRecieved.location
        textFieldShouldReturn(inputTextField)
    }
    
    /**
    Helper function to display a pin on the map
    **/
    func displayMap(center: CLLocationCoordinate2D, span: MKCoordinateSpan, pinTitle: String){
        let region = MKCoordinateRegionMake(center, span)
        let pin = MKPointAnnotation()
        pin.coordinate = center
        pin.title = pinTitle
        mapViewObject.addAnnotation(pin)
        mapViewObject.setRegion(region, animated: true)
        self.view.endEditing(true)
    }
    
    /**
    Function to drop a pin on a location given in the text field
    **/
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(inputTextField.text!, completionHandler: {
            placemarks, error in
            if error != nil{
                print(error)
            }
            else{
                var toDisplay:[CLPlacemark] = []
                var doAction = true
                if(placemarks!.count == 1){
                    let placemark = placemarks!.first as CLPlacemark!
                    let center = placemark.location.coordinate
                    let span = MKCoordinateSpanMake(0.1, 0.1)
                    doAction = false
                    self.displayMap(center, span: span, pinTitle: self.inputTextField.text!)
                }
                else if(placemarks!.count > 1 && placemarks!.count <= 10){
                    toDisplay = placemarks!
                }
                else{
                    for(var i = 0; i < 10; i++){
                        toDisplay[i] = placemarks![i]
                    }
                }
                if(doAction){
                    let actionSheet = UIAlertController(title: "Select Location", message: "Please select your preferred location", preferredStyle: .ActionSheet)
                    for(var i = 0; i < toDisplay.count; i++){
                        let placemark = toDisplay[i] as CLPlacemark!
                        let center = placemark.location.coordinate
                        let span = MKCoordinateSpanMake(0.1, 0.1)
                        
                        let leAction = UIAlertAction(title: toDisplay[i].name + ", " + toDisplay[i].administrativeArea , style: .Default){ (action) -> Void in
                            self.displayMap(center, span: span, pinTitle: self.inputTextField.text!)
                        }
                        actionSheet.addAction(leAction)
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    }
                    actionSheet.addAction(cancelAction)
                    
                    self.presentViewController(actionSheet, animated: true, completion: nil)
                }
            }
        })
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
