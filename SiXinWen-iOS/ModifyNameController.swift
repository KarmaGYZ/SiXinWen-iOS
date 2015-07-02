//
//  LoginViewController.swift
//  SiXinWen-iOS
//
//  Created by Karma Guo on 5/6/15.
//  Copyright (c) 2015 SiXinWen. All rights reserved.
//

import UIKit
import AVOSCloud



class ModifyNameController: UITableViewController ,UITextFieldDelegate{
    var nickName:String = ""
    @IBOutlet weak var nickNameField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // file the field with old nick name
        nickNameField.text = nickName
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        nickNameField.becomeFirstResponder()
        
    }
    

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText:NSString = textField.text
        let newText:NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        // enable the save button
        saveButton.enabled = (newText.length>0) && !textField.text.isEmpty
        return true
    }
    
    
//  save the nick name
    @IBAction func SaveNickName() {
        AVUser.currentUser().setObject(nickNameField.text, forKey: "NickName")
        KVNProgress.showWithStatus(" ")
        AVUser.currentUser().saveInBackgroundWithBlock(){
            (success:Bool, error:NSError!) -> Void in
            if success {
                KVNProgress.dismiss()
                KVNProgress.showSuccessWithStatus("修改成功")
                me.nickname = self.nickNameField.text
                self.navigationController?.popViewControllerAnimated(true)
            }
            else {
                KVNProgress.dismiss()
                KVNProgress.showErrorWithStatus("修改失败")
            }
        }
    }
    
    

}
