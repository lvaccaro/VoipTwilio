//
//  AppDelegate.swift
//  SwiftPhone
//
//  Created by Devin Rader on 1/28/15.
//  Copyright (c) 2015 Devin Rader. All rights reserved.
//

import UIKit


//let SPDefaultReceiver:String = "client:jenny"
//let SPDefaultReceiver:String = "00393472503196"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        if  UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound], categories: nil))
        }

        let notification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as! UILocalNotification!
        if (notification != nil) {
            // Do your stuff with notification
            NSNotificationCenter.defaultCenter().postNotificationName(
                "tapNotificationIncomingConnectionReceived",
                object: nil,
                userInfo:nil)
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        /*
        var topController : UIViewController = (application.keyWindow?.rootViewController)!
        
        while ((topController.presentedViewController) != nil) {
            
            topController = topController.presentedViewController!
        }
        
        let alert = UIAlertController(title: "", message: notification.alertBody, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in}))
        
        topController.presentViewController(alert, animated: true, completion: nil)
        */
        
        
            // Do your stuff with notification
            NSNotificationCenter.defaultCenter().postNotificationName(
                "tapNotificationIncomingConnectionReceived",
                object: nil,
                userInfo:nil)
        
        
    }
    
}

