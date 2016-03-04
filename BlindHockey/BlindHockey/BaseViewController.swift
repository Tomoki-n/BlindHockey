//
//  BaseViewController.swift
//  BlindHockey
//
//  Created by Nishinaka Tomoki on 2016/02/20.
//  Copyright © 2016年 Nishinaka Tomoki. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity
import CoreLocation
import SpriteKit

class BaseViewController: UIViewController  {
    
    
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!
    var app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
}