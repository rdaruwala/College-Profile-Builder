//
//  webViewController.swift
//  College Profile Builder
//
//  Created by Rohan Daruwala on 7/7/15.
//  Copyright © 2015 Rohan Daruwala. All rights reserved.
//

import UIKit

class webViewController: UIViewController {
    
    @IBOutlet weak var webViewObject: UIWebView!
    var webURL:String!
    
    /**
    Creates a modal view to display the college's web page
    **/
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: webURL)
        let request = NSURLRequest(URL: url!)
        webViewObject.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
    Closes the modal view controller
    **/
    @IBAction func closeWebViewAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
