//
//  OverViewController.swift
//  BlindHockey
//
//  Created by Nishinaka Tomoki on 2016/03/04.
//  Copyright © 2016年 Nishinaka Tomoki. All rights reserved.
//

import UIKit

class OverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func returnview(sender: AnyObject) {
    
        
        let mainVC:UIViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        self.presentViewController(mainVC, animated: true, completion: nil)

    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
