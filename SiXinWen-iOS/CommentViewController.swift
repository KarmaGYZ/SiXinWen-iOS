//
//  CommentViewController.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/3/24.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
   
    
    
    
    
    @IBOutlet var instantComment: UIView!
    
    
    @IBOutlet var popularComment: UIView!
    
    
    @IBAction func commentSwitch(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex{
            
        case 0:
            
            instantComment.hidden = false
            
            popularComment.hidden = true
            
            break
            
        case 1:
            
            popularComment.hidden = false
            
            instantComment.hidden = true;
            
            break
            
        default: break
            
            
            
        }
        
        
    }
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
