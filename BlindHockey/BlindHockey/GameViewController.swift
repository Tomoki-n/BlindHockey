//
//  GameViewController.swift
//  BlindHockey
//
//  Created by Nishinaka Tomoki on 2016/02/20.
//  Copyright (c) 2016年 Nishinaka Tomoki. All rights reserved.
//

import UIKit
import SpriteKit
import MultipeerConnectivity
import CoreLocation

class GameViewController: UIViewController, MCBrowserViewControllerDelegate,MCSessionDelegate ,CLLocationManagerDelegate {
    
    
    let serviceType = "LCOC-Chat"
    
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID! = nil
    var getid :Int = 0
    var app = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        // create the browser viewcontroller with a unique service name
        self.browser = MCBrowserViewController(serviceType:serviceType,
            session:self.session)
        
        self.browser.delegate = self
        
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,
            discoveryInfo:nil, session:self.session)
        // tell the assistant to start advertising our fabulous chat
        self.assistant.start()
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        let scene = GameScene(size: skView.bounds.size)
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        
        skView.presentScene(scene)
        
        
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        if (getid == 0){
            getid = 1
            self.presentViewController(self.browser, animated: true, completion: nil)
        }
    }
    
    func sendMes(values: String){
        
        let msg = values.dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: false)
        print(values)
        do {
            try self.session.sendData(msg!,
                toPeers: self.session.connectedPeers,
                withMode: MCSessionSendDataMode.Unreliable)
            
        } catch {
            // do something.
        }
        
        
    }
    
    func browserViewControllerDidFinish(
        browserViewController: MCBrowserViewController)  {
            // Called when the browser view controller is dismissed (ie the Done
            // button was tapped)
            app.controller = self
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(
        browserViewController: MCBrowserViewController)  {
            // Called when the browser view controller is cancelled
            app.controller = self
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func session(session: MCSession, didReceiveData data: NSData,
        fromPeer peerID: MCPeerID)  {
            // Called when a peer sends an NSData to us
            
            // This needs to run on the main queue
            dispatch_async(dispatch_get_main_queue()) {
                
                let msg = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                
                print(msg)
                if msg == "dead" {
                    self.app.ene_dead = true
                }
                else if msg == "rebone"{
                    self.app.ene_rebone = true
                }
                else{
                    let arr2 = msg.componentsSeparatedByString(",")
                    self.app.getdata = true
                    self.app.myturn = true
                    if let n = NSNumberFormatter().numberFromString(arr2[0]) {
                        self.app.balldx = CGFloat(n)
                    }
                    if let n = NSNumberFormatter().numberFromString(arr2[1]) {
                        self.app.balldy = CGFloat(n)
                        
                    }
                    
                    if let n = NSNumberFormatter().numberFromString(arr2[2]) {
                        self.app.posx = CGFloat(n)
                    }
                    self.app.getdata = true
                }
            }
    }
    
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(session: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID, withProgress progress: NSProgress)  {
            
            // Called when a peer starts sending a file to us
    }
    
    func session(session: MCSession,
        didFinishReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        atURL localURL: NSURL, withError error: NSError?)  {
            // Called when a file has finished transferring from another peer
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream,
        withName streamName: String, fromPeer peerID: MCPeerID)  {
            // Called when a peer establishes a stream with us
    }
    
    func session(session: MCSession, peer peerID: MCPeerID,
        didChangeState state: MCSessionState)  {
            // Called when a connected peer changes state (for example, goes offline)
            
    }
    
}
