//
//  Phone.swift
//  SwiftPhone
//
//  Created by Devin Rader on 1/30/15.
//  Copyright (c) 2015 Devin Rader. All rights reserved.
//

import Foundation
import AVFoundation



public class Phone : NSObject, TCDeviceDelegate,TCConnectionDelegate {
    var device:TCDevice!
    var connection:TCConnection!
    var pendingConnection:TCConnection!
    
    
    
    var SPDefaultClientName : String = ""
    var SPBaseCapabilityTokenUrl:String = ""
    var SPTwiMLAppSid:String = ""
    
    func login(clientName : String, SPBaseCapabilityTokenUrl: String, SPTwiMLAppSid: String) {
        self.SPDefaultClientName=clientName;
        self.SPBaseCapabilityTokenUrl=SPBaseCapabilityTokenUrl;
        self.SPTwiMLAppSid=SPTwiMLAppSid;
    
        TwilioClient.sharedInstance().setLogLevel(TCLogLevel.LOG_VERBOSE)
        
        let url:String = self.getCapabilityTokenUrl()
        NSLog("url : "+url);
        
        let swiftRequest = SwiftRequest()
        swiftRequest.get(url, callback: { (err, response, body) -> () in
            if err != nil {
                return
            }
            
            //let token = NSString(data: body as! NSData, encoding: NSUTF8StringEncoding) as! String
            let token = body as! NSString
            print(token)
            
            if err == nil && token != "" {
                if self.device == nil {
                    self.device = TCDevice(capabilityToken: token as String, delegate: self)
                }
                else {
                    self.device!.updateCapabilityToken(token as String)
                }
                self.listen();
            }
            else if err != nil && response != nil {
                // We received and error with a response
            }
            else if err != nil {
                // We received an error without a response
            }
        })
    }
    
    func getCapabilityTokenUrl() -> String {
        
        var querystring:String = String()
        
        //querystring += String(format:"&sid=%@", SPTwiMLAppSid)
        querystring += String(format:"&client=%@", SPDefaultClientName)

        return String(format:SPBaseCapabilityTokenUrl, querystring)
    }

    func connectWithParams(params dictParams:Dictionary<String,String> = Dictionary<String,String>()) {
        if !self.capabilityTokenValid() {
            self.login(self.SPDefaultClientName,SPBaseCapabilityTokenUrl: self.SPBaseCapabilityTokenUrl,SPTwiMLAppSid: self.SPTwiMLAppSid)
        }
        
        self.connection = self.device?.connect(dictParams, delegate: self)

    }
    
    func listen(){
        if !self.capabilityTokenValid() {
            self.login(self.SPDefaultClientName,SPBaseCapabilityTokenUrl: self.SPBaseCapabilityTokenUrl,SPTwiMLAppSid: self.SPTwiMLAppSid)
        }
        
        self.device.listen();
    }
    
    
    func acceptConnection() {
        self.connection = self.pendingConnection
        self.pendingConnection = nil
        
        self.connection?.accept()
    }
    
    func rejectConnection() {
        self.pendingConnection?.reject()
        self.pendingConnection = nil
    }
    
    func ignoreConnection() {
        self.pendingConnection?.ignore()
        self.pendingConnection = nil
    }
    
    func sendInput(input:String) {
        if self.connection != nil {
            self.connection!.sendDigits(input)
        }
    }
    
    func setSpeaker(enabled:Bool) throws {
        if self.connection != nil {
            if (enabled)
            {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker);
            } else {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.None);
            }
        }
    }
    
    func muteConnection(mute:Bool) {
        if self.connection != nil {
            self.connection!.muted = mute;
        }
    }

    func capabilityTokenValid()->(Bool) {
        var isValid:Bool = false
    
        if self.device != nil {
            let capabilities = self.device!.capabilities! as NSDictionary
        
            let expirationTimeObject:NSNumber = capabilities.objectForKey("expiration") as! NSNumber
            let expirationTimeValue:Int64 = expirationTimeObject.longLongValue
            let currentTimeValue:NSTimeInterval = NSDate().timeIntervalSince1970
        
            if (expirationTimeValue-Int64(currentTimeValue)) > 0 {
                isValid = true
            }else {
                print ("token not valid")
            }
        }
    
        return isValid
    }
    
    public func deviceDidStartListeningForIncomingConnections(device: TCDevice)->() {
        print("Started listening for incoming connections")
        self.device.incomingSoundEnabled=false
    }
    
    public func device( didStartListeningForIncomingConnections device:TCDevice)->() {
        print("Started listening for incoming connections")
    }
    
    public func device(device:TCDevice, didStopListeningForIncomingConnections error:NSError)->(){
        print("Stopped listening for incoming connections")
    }
    
    public func device(device:TCDevice, didReceivePresenceUpdate presenceEvent:TCPresenceEvent)->(){
        print("didReceivePresenceUpdate"+presenceEvent.name);
        
    }
    
    public func device(device:TCDevice, didReceiveIncomingConnection connection:TCConnection)->() {
        print("Receiving an incoming connection")
        self.pendingConnection = connection
        
        NSNotificationCenter.defaultCenter().postNotificationName(
            "PendingIncomingConnectionReceived",
            object: nil,
            userInfo:nil)
    }
    
    public func connection(connection:TCConnection, didFailWithError error:NSError)->(){
        print("connection : didFailWithError");
        
        NSNotificationCenter.defaultCenter().postNotificationName(
            "PendingDisconnectReceived",
            object: nil,
            userInfo:nil)
    }
    
    public func connectionDidStartConnecting(connection:TCConnection)->(){
        print("connection : connectionDidStartConnecting");
    }
    
    public func connectionDidConnect(connection:TCConnection)->(){
        print("connection : connectionDidConnect");
    }
    
    public func connectionDidDisconnect(connection:TCConnection)->(){
        print("connection : connectionDidDisconnect");
        
        NSNotificationCenter.defaultCenter().postNotificationName(
            "PendingDisconnectReceived",
            object: nil,
            userInfo:nil)
    }
    
    
}