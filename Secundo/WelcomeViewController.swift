//
//  WelcomeViewController.swift
//  Secundo
//
//  Created by Juan David Cruz Serrano on 8/11/16.
//  Copyright © 2016 Juan David Cruz. All rights reserved.
//


import UIKit
import AFNetworking

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var imageViewJuan: UIImageView!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var continueButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUIComponents()
        
        loadProfileInfo()
        loadTextFromCloud()
        
        UIApplication.sharedApplication().statusBarHidden = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func setUpUIComponents() {
        
        self.imageViewJuan.layer.cornerRadius = self.imageViewJuan.frame.height/2
        self.imageViewJuan.layer.masksToBounds = true
        
    }
    
    func loadProfileInfo () {
        
        self.imageViewJuan.setImageWithURL(LaunchStrings.JuanImageLink!, placeholderImage: UIImage())
        
    }
    
    
    func loadTextFromCloud () {
        
        let languageCode:String = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode)! as! String
        let textFilename: String = "welcome-"+languageCode+".json"
       
        let manager:AFHTTPSessionManager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/plain")
        
        
        manager.GET(LaunchStrings.WelcomeTextBaseLink+textFilename, parameters: nil, progress: nil, success: { (task, response) in
            
                let textDictionary:NSDictionary = response as! NSDictionary
                self.printTextFromCloud(textDictionary)
            
            }) { (task, error) in
                
                let errorObject:NSError = error
                print ("Error getting welcome json: \(errorObject)")
                
                if (error.code == 404) {
                    
                    print("JSON Welcome not found for this language")
                    self.loadDefaultTextFromCloud()
                
                }
        }
        
       
        
    }
    
    func loadDefaultTextFromCloud () {
        
        let textFilename: String = "welcome-en.json"
        
        let manager:AFHTTPSessionManager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/plain")
        
        
        manager.GET(LaunchStrings.WelcomeTextBaseLink+textFilename, parameters: nil, progress: nil, success: { (task, response) in
            
            let textDictionary:NSDictionary = response as! NSDictionary
            self.printTextFromCloud(textDictionary)
            
        }) { (task, error) in
            
            let errorObject:NSError = error
            print ("Error getting welcome json: \(errorObject)")
            
        }
        
        
        
    }
    
    
    func printTextFromCloud (dictionary: AnyObject!) {
        
        let dictionary:NSDictionary = dictionary as! NSDictionary
        let textDictionary = dictionary.objectForKey("text")! as? NSDictionary
        
        self.helloLabel.text = textDictionary?.objectForKey("HelloTitle")! as? String
        
        self.messageTextView.text = textDictionary?.objectForKey("HelloMessage")! as? String
        self.messageTextView.textAlignment = NSTextAlignment.Center
        self.messageTextView.textColor = UIColor(white: 0.44, alpha: 1.0)
        
        self.continueButton.setTitle(textDictionary?.objectForKey("ContinueMessage")! as? String, forState: UIControlState.Normal)
        
    }
    
    
    
    @IBAction func hideWelcomeView(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: LaunchStrings.AlreadyLaunched)
            
        self.dismissViewControllerAnimated(false) { }
        
    }
    
    
}

