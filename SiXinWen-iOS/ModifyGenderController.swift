//
//  ModifyGenderController.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/5/15.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit
import AVOSCloud

class ModifyGenderController: UITableViewController {

    @IBOutlet var maleCell: UITableViewCell!
    
    @IBOutlet var femaleCell: UITableViewCell!
    
    let male = 0, female = 1
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //  check mark the old gender
        if me.gender == nil || me.gender == "男" {
            maleCell.accessoryType = .Checkmark
            femaleCell.accessoryType = .None
        }
        else {
            maleCell.accessoryType = .None
            femaleCell.accessoryType =  .Checkmark
        }
        
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // checkmark the selected gender
        if indexPath.row == male{
            maleCell.accessoryType = .Checkmark
            femaleCell.accessoryType = .None
            saveGender("男")
        }
        else{
            femaleCell.accessoryType = .Checkmark
            maleCell.accessoryType = .None
            saveGender("女")
        }
        
    }
    
//      save the gender in the server
    func saveGender(gender: String){
        AVUser.currentUser().setObject(gender, forKey: "gender")
        KVNProgress.showWithStatus(" ")
        AVUser.currentUser().saveInBackgroundWithBlock(){
            (success:Bool, error:NSError!) -> Void in
            if success {
                KVNProgress.dismiss()
                KVNProgress.showSuccessWithStatus("修改成功")
                me.gender = gender
                self.navigationController?.popViewControllerAnimated(true)
            }
            else {
                KVNProgress.dismiss()
                KVNProgress.showErrorWithStatus("网络错误")
            }
        }
        
        
    }
    
    

}
