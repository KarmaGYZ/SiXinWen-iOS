//
//  ModifyPSwordController.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/5/12.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit
import AVOSCloud

class ModifyPSwordController: UITableViewController {

    @IBOutlet weak var originalPasswordField: UITextField!
    
    @IBOutlet weak var newPasswordField: UITextField!
    
    @IBOutlet weak var confirmNewPasswordField: UITextField!
    
    @IBAction func changePassword(sender: UIBarButtonItem) {
        // ensure those fields not empty
        if originalPasswordField.text == "" || newPasswordField.text == "" || confirmNewPasswordField.text == ""  {
            KVNProgress.showErrorWithStatus("密码不能为空")
            return
        }
        // double check the new password
        if newPasswordField.text != confirmNewPasswordField.text {
            KVNProgress.showErrorWithStatus("新密码不一致")
        }
        KVNProgress.showWithStatus(" ")
        AVUser.currentUser().updatePassword(originalPasswordField.text, newPassword: newPasswordField.text){
            (obj:AnyObject!, error:NSError!) -> Void in
            if error != nil {
                KVNProgress.dismiss()
                KVNProgress.showErrorWithStatus("修改失败")
            }
            else {
                KVNProgress.dismiss()
                KVNProgress.showSuccessWithStatus("修改成功")
                self.navigationController?.popViewControllerAnimated(true)
            }
            
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }
    

}
