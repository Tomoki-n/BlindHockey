//
//  ConnectionViewController.swift
//  BlindHockey
//
//  Created by Nishinaka Tomoki on 2016/02/20.
//  Copyright © 2016年 Nishinaka Tomoki. All rights reserved.
//

import UIKit

class ConnectionViewController: UIViewController {
    
    
    var app = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendplayer1(sender: AnyObject) {
        app.firstturn = true
        
        self.performSegueWithIdentifier("goplay", sender: nil)
        
        
        
        
    }
    
    @IBAction func sendplayer2(sender: AnyObject) {
        app.firstturn = false
        
        self.performSegueWithIdentifier("goplay", sender: nil)
        
        
        
    }
    
    
}
