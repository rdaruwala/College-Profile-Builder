//
//  College.swift
//  College Profile Builder
//
//  Created by Rohan Daruwala on 7/6/15.
//  Copyright © 2015 Rohan Daruwala. All rights reserved.
//

import UIKit
import Foundation

class College : NSObject, NSCoding{
    
    var image:UIImage!
    var name:String
    var enrollment:Int
    var location:String
    
    
    
    override init(){
        self.image = UIImage(named: "defaultImage.png")
        self.name = "Default University"
        self.enrollment = 42
        self.location = "Imaginary Land"
    }
    
    init(name: String){
        self.image = UIImage(named: "defaultImage.png")
        self.name = name
        self.enrollment = 42
        self.location = "Imaginary Land"
    }
    
    init(name: String, location: String, enrollment: Int, image: UIImage){
        self.name = name
        self.location = location
        self.enrollment = enrollment
        self.image = image
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(location, forKey: "location")
        aCoder.encodeObject(enrollment, forKey: "enrollment")
        aCoder.encodeObject(image, forKey: "image")
    }
    
    required init?(coder aDecoder: NSCoder){
        self.name = (aDecoder.decodeObjectForKey("name") as? String)!
        self.location = (aDecoder.decodeObjectForKey("location") as? String)!
        self.enrollment = (aDecoder.decodeObjectForKey("enrollment") as? Int)!
        self.image = aDecoder.decodeObjectForKey("image") as? UIImage
    }
    
    
    
}
