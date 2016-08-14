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
import ARNTransitionAnimator

class ViewController: UIViewController {

    let volume = SubtleVolume(style: .Plain)
    @IBOutlet weak var miniPlayerView : LineView!
    @IBOutlet weak var miniPlayerButton : UIButton!
    
    private var animator : ARNTransitionAnimator!
    private var modalVC : PlayerViewController!
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpVolumeButtons()
        
        setUpMiniPlayer()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
 
        if NSUserDefaults.standardUserDefaults().boolForKey(LaunchStrings.AlreadyLaunched) == false {
            
            self.performSegueWithIdentifier(LaunchStrings.WelcomeViewSegueId, sender: nil)
            
        }
    }
    
    func setUpMiniPlayer () {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.modalVC = storyboard.instantiateViewControllerWithIdentifier("PlayerViewController") as? PlayerViewController
        self.modalVC.modalPresentationStyle = .OverFullScreen
        self.modalVC.tapCloseButtonActionHandler = { [unowned self] in
            self.animator.interactiveType = .None
        }
        
        let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.miniPlayerButton.setBackgroundImage(self.generateImageWithColor(color), forState: .Highlighted)
        
        self.setupAnimator()
        
    }
    
    func setupAnimator() {
        
        self.animator = ARNTransitionAnimator(operationType: .Present, fromVC: self, toVC: self.modalVC)
        self.animator.usingSpringWithDamping = 0.8
        self.animator.gestureTargetView = self.miniPlayerView
        self.animator.interactiveType = .Present
        
        // Present
        
        self.animator.presentationBeforeHandler = { [unowned self] containerView, transitionContext in
            
            print("Start Presentation")
            self.beginAppearanceTransition(false, animated: false)
            
            self.animator.direction = .Top
            
            self.modalVC.view.frame.origin.y = self.miniPlayerView.frame.origin.y + self.miniPlayerView.frame.size.height
            self.view.addSubview(self.modalVC.view)
            
            self.view.layoutIfNeeded()
            self.modalVC.view.layoutIfNeeded()
            
            // miniPlayerView
            let startOriginY = self.miniPlayerView.frame.origin.y
            let endOriginY = -self.miniPlayerView.frame.size.height
            let diff = -endOriginY + startOriginY
            
            
            self.animator.presentationCancelAnimationHandler = { containerView in
                self.miniPlayerView.frame.origin.y = startOriginY
                self.modalVC.view.frame.origin.y = self.miniPlayerView.frame.origin.y + self.miniPlayerView.frame.size.height
                
                self.miniPlayerView.alpha = 1.0
                for subview in self.miniPlayerView.subviews {
                    subview.alpha = 1.0
                }
            }
            
            self.animator.presentationAnimationHandler = { [unowned self] containerView, percentComplete in
                let _percentComplete = percentComplete >= 0 ? percentComplete : 0
                self.miniPlayerView.frame.origin.y = startOriginY - (diff * _percentComplete)
                if self.miniPlayerView.frame.origin.y < endOriginY {
                    self.miniPlayerView.frame.origin.y = endOriginY
                }
                self.modalVC.view.frame.origin.y = self.miniPlayerView.frame.origin.y + self.miniPlayerView.frame.size.height
               
                
                let alpha = 1.0 - (1.0 * _percentComplete)
                
                for subview in self.miniPlayerView.subviews {
                    subview.alpha = alpha
                }
            }
            
            self.animator.presentationCompletionHandler = { containerView, completeTransition in
                self.endAppearanceTransition()
                
                if completeTransition {
                    self.miniPlayerView.alpha = 0.0
                    self.modalVC.view.removeFromSuperview()
                    containerView.addSubview(self.modalVC.view)
                    self.animator.interactiveType = .Dismiss
                    self.animator.gestureTargetView = self.modalVC.view
                    self.animator.direction = .Bottom
                } else {
                    self.beginAppearanceTransition(true, animated: false)
                    self.endAppearanceTransition()
                }
            }
        }
        
        // Dismiss
        
        self.animator.dismissalBeforeHandler = { [unowned self] containerView, transitionContext in
            print("start dismissal")
            self.beginAppearanceTransition(true, animated: false)
            
            self.view.addSubview(self.modalVC.view)
            
            self.view.layoutIfNeeded()
            self.modalVC.view.layoutIfNeeded()
            
            // miniPlayerView
            let startOriginY = 0 - self.miniPlayerView.bounds.size.height
            let endOriginY = self.view.bounds.size.height  - self.miniPlayerView.frame.size.height
            let diff = -startOriginY + endOriginY
            
            
            self.animator.dismissalCancelAnimationHandler = { containerView in
                self.miniPlayerView.frame.origin.y = startOriginY
                self.modalVC.view.frame.origin.y = self.miniPlayerView.frame.origin.y + self.miniPlayerView.frame.size.height
               self.miniPlayerView.alpha = 0.0
                for subview in self.miniPlayerView.subviews {
                    subview.alpha = 0.0
                }
            }
            
            self.animator.dismissalAnimationHandler = { containerView, percentComplete in
                
                let _percentComplete = percentComplete >= -0.05 ? percentComplete : -0.05
                self.miniPlayerView.frame.origin.y = startOriginY + (diff * _percentComplete)
                self.modalVC.view.frame.origin.y = self.miniPlayerView.frame.origin.y + self.miniPlayerView.frame.size.height
                let alpha = 1.0 * _percentComplete
                self.miniPlayerView.alpha = 1.0
                for subview in self.miniPlayerView.subviews {
                    subview.alpha = alpha
                }
                
            }
            
            self.animator.dismissalCompletionHandler = { containerView, completeTransition in
                self.endAppearanceTransition()
                
                if completeTransition {
                    self.modalVC.view.removeFromSuperview()
                    self.animator.gestureTargetView = self.miniPlayerView
                    self.animator.interactiveType = .Present
                } else {
                    self.modalVC.view.removeFromSuperview()
                    containerView.addSubview(self.modalVC.view)
                    self.beginAppearanceTransition(false, animated: false)
                    self.endAppearanceTransition()
                }
            }
        }
        
        self.modalVC.transitioningDelegate = self.animator
    }
    
    @IBAction func tapMiniPlayerButton() {
        self.animator.interactiveType = .None
        self.presentViewController(self.modalVC, animated: true, completion: nil)
    }
    
    private func generateImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 1, 1)
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
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

