//
//  ModifyEmailController.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/5/15.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//
import AVOSCloud
import UIKit

class ModifyEmailController: UITableViewController {

    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBOutlet var EmailTextField: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // file the field with old email
        EmailTextField.text = me.email
        EmailTextField.becomeFirstResponder()
    }

   
//      save the new email
    @IBAction func saveEmail(sender: UIBarButtonItem) {
        AVUser.currentUser().setObject(EmailTextField.text, forKey: "email")
        KVNProgress.showWithStatus(" ")
        AVUser.currentUser().saveInBackgroundWithBlock(){
            (success:Bool, error:NSError!) -> Void in
            if success {
                KVNProgress.dismiss()
                KVNProgress.showSuccessWithStatus("修改成功")
                me.email = self.EmailTextField.text
                self.navigationController?.popViewControllerAnimated(true)
            }
            else {
                KVNProgress.dismiss()
                KVNProgress.showErrorWithStatus("网络错误")
            }
        }
    }
    
    
}
