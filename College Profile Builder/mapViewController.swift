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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = CLLocationCoordinate2DMake(41.8938, -87.6354)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(center, span)
        
        let pin = MKPointAnnotation()
        pin.coordinate = center
        pin.title = "Mobile Makers"
        mapViewObject.addAnnotation(pin)
        mapViewObject.setRegion(region, animated: true)
    }
    
    func displayMap(center: CLLocationCoordinate2D, span: MKCoordinateSpan, pinTitle: String){
        let region = MKCoordinateRegionMake(center, span)
        let pin = MKPointAnnotation()
        pin.coordinate = center
        pin.title = pinTitle
        mapViewObject.addAnnotation(pin)
        mapViewObject.setRegion(region, animated: true)
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(inputTextField.text!, completionHandler: {
            placemarks, error in
            if error != nil{
                print(error)
            }
            else{
                let placemark = placemarks!.first as CLPlacemark!
                let center = placemark.location.coordinate
                let span = MKCoordinateSpanMake(0.1, 0.1)
                self.displayMap(center, span: span, pinTitle: self.inputTextField.text!)
            }
        })
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
