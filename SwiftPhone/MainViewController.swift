//
//  ViewController.swift
//  SwiftPhone
//
//  Created by Devin Rader on 1/28/15.
//  Copyright (c) 2015 Devin Rader. All rights reserved.
//

import UIKit
import BRYXBanner
import AVFoundation

var phone : Phone!;

class MainViewController: UIViewController {

    var isIncomingCall = false;
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var receiver: UITextField!
    @IBOutlet weak var sbCapabilityTokenUrl: UITextField!
    
    @IBOutlet weak var SPTwiMLAppSid: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector:Selector("pendingIncomingConnectionReceived:"),
            name:"PendingIncomingConnectionReceived", object:nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector:Selector("tapNotificationIncomingConnectionReceived:"),
            name:"tapNotificationIncomingConnectionReceived", object:nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func start(sender: AnyObject) {
        
        phone = Phone()
        phone.login(name.text!,SPBaseCapabilityTokenUrl: sbCapabilityTokenUrl.text!,SPTwiMLAppSid: SPTwiMLAppSid.text!)
        
    }
    
    @IBAction func call(sender: AnyObject) {
        self.isIncomingCall=false;
        self.performSegueWithIdentifier("call", sender: nil);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "call" {
            if let viewController = segue.destinationViewController as? DialViewController {
                viewController.isIncomingCall = self.isIncomingCall;
                viewController.callcenter = receiver.text!;
            }
        }
    }
    
    var banner : Banner?;
    var player: AVAudioPlayer?;
    
    func pendingIncomingConnectionReceived(notification:NSNotification) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, withOptions: .MixWithOthers)
            try audioSession.setActive(true)
            playSound()
        } catch {
            print("AVAudioSession cannot be set")
        }
        
            
        if UIApplication.sharedApplication().applicationState != UIApplicationState.Active {
            UIApplication.sharedApplication().cancelAllLocalNotifications();
            
            let notification:UILocalNotification = UILocalNotification()
            notification.soundName = "ringtone.mp3"
            if #available(iOS 8.2, *) {
                notification.alertTitle = "Call Incoming"
            } else {
                // Fallback on earlier versions
            }
            notification.alertBody = "Touch here to dial"
            notification.alertLaunchImage = "call"
            notification.fireDate = NSDate().dateByAddingTimeInterval(NSTimeInterval(1000))
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
            
            
        }else {
            banner = Banner(title: "Call Incoming", subtitle: "Touch here to dial", image: UIImage(named: "call"), backgroundColor: UIColor(red:0/255.0, green:0/255.0, blue:0.0, alpha:1.000),didTapBlock:  bannertap );
            banner!.dismissesOnTap = true
            banner!.show(duration: 30.0)
            
        }
        
        
        
    }
    
    func playSound() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        let url = NSBundle.mainBundle().URLForResource("ringtone", withExtension: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOfURL: url)
            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
            NSLog("duration"+String(player.duration))
            
        } catch let error as NSError {
            print(error.description)
        }
    }
    func stopSound(){
        player?.stop()
    }
    
    
    
    func bannertap()->(){
        NSNotificationCenter.defaultCenter().postNotificationName(
            "tapNotificationIncomingConnectionReceived",
            object: nil,
            userInfo:nil)
    }
    
    func tapNotificationIncomingConnectionReceived(notification:NSNotification) {
        if(!(banner==nil)){
            self.banner?.dismiss();
            self.stopSound();
        }
        self.isIncomingCall=true;
        self.performSegueWithIdentifier("call", sender: nil);
    }

    
}
