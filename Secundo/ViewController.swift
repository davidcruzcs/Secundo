//
//  ViewController.swift
//  Secundo
//
//  Created by Juan David Cruz Serrano on 8/10/16.
//  Copyright © 2016 Juan David Cruz. All rights reserved.
//

import UIKit
import MediaPlayer
import SubtleVolume

class ViewController: UIViewController {

    let volume = SubtleVolume(style: .Plain)
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpVolumeButtons()
        
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
    
    func setUpVolumeButtons() {
   
        volume.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: 1)
        volume.barTintColor = .blackColor()
        volume.barBackgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
        volume.animation = .FadeIn
        view.addSubview(volume)
       
    }


}

