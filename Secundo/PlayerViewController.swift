//
//  PlayerViewController.swift
//  Secundo
//
//  Created by Juan David Cruz Serrano on 8/12/16.
//  Copyright © 2016 Juan David Cruz. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    var tapCloseButtonActionHandler : (Void -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let effect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
        self.view.sendSubviewToBack(blurView)
        // Do any additional setup after loading the view.
    }

    @IBAction func tapCloseButton() {
        self.tapCloseButtonActionHandler?()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
