//
//  ViewController.swift
//  Secundo
//
//  Created by Juan David Cruz Serrano on 8/10/16.
//  Copyright © 2016 Juan David Cruz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
 
        if NSUserDefaults.standardUserDefaults().boolForKey(LaunchStrings.AlreadyLaunched) == false {
            
            self.performSegueWithIdentifier(LaunchStrings.WelcomeViewSegueId, sender: nil)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

