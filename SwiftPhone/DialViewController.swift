//
//  DialViewController.swift
//  SwiftPhone
//
//  Created by d2h on 17/08/16.
//  Copyright © 2016 Devin Rader. All rights reserved.
//

import Foundation

import UIKit

class DialViewController: UIViewController {
    
    @IBOutlet weak var txtState: UILabel!
    
    var isIncomingCall = false;
    var callcenter : String = "";
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector:Selector("PendingDisconnectReceived:"),
            name:"PendingDisconnectReceived", object:nil)
        

        self.button.contentHorizontalAlignment =
            UIControlContentHorizontalAlignment.Fill;
        self.button.contentVerticalAlignment =
            UIControlContentVerticalAlignment.Fill;
        
        if(isIncomingCall==true){
            initIncomingCall();
        }else {
            initOutcomingCall();
        }
        
        
        
    }
    
    func initIncomingCall(){
        txtState.text="Call Incoming"
        
        do{
            phone.acceptConnection()
        }catch{
            
        }
    }
    
    func initOutcomingCall(){
        txtState.text="Call Outcoming"
        let params : Dictionary<String,String> = [
            "To" : callcenter
        ];
        phone.connectWithParams(params: params)
    }
    
    @IBAction func disconnect(sender: AnyObject) {
        if (phone.connection != nil){
            try phone.connection.disconnect();
        }
        if (phone.pendingConnection != nil){
            try phone.pendingConnection.disconnect();
        }
        if (phone.device != nil){
            phone.device.disconnectAll();
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func PendingDisconnectReceived(notification:NSNotification) {
        navigationController?.popViewControllerAnimated(true)
    }

    
    
}
