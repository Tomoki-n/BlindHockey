//
//  ClearViewController.swift
//  BlindHockey
//
//  Created by Nishinaka Tomoki on 2016/03/04.
//  Copyright © 2016年 Nishinaka Tomoki. All rights reserved.
//

import UIKit

class ClearViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet var returnview: UIButton!

    @IBOutlet var views: UIButton!
    
    @IBAction func review(sender: AnyObject) {
        
        let mainVC:UIViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        self.presentViewController(mainVC, animated: true, completion: nil)
    
    
    }
}
