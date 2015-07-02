//
//  SignUpController.swift
//  SiXinWen-iOS
//
//  Created by Karma Guo on 5/13/15.
//  Copyright (c) 2015 SiXinWen. All rights reserved.
//

import UIKit
import AVOSCloud
class SignUpController: UIViewController {

    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var nickNameField: UITextField!
    
    
    @IBOutlet weak var setPasswordField: UITextField!
    
    
    @IBOutlet weak var ensurePasswordField: UITextField!
    
    
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet var gender: UISegmentedControl!
    
    
      
    
    @IBAction func SignUp(sender: UIButton) {
        // ensure those fields not empty
        if userNameField.text == "" || nickNameField.text == "" || setPasswordField.text == "" || ensurePasswordField.text == "" {
            KVNProgress.showErrorWithStatus("无效的用户名/昵称/密码")
            return
        }
        
        // double check the password
        if setPasswordField.text != ensurePasswordField.text {
            KVNProgress.showErrorWithStatus("密码不一致")
            return
        }
        
        var user = AVUser()
        user.username = userNameField.text
        user.password = setPasswordField.text
        user.setObject(nickNameField.text, forKey: "NickName")
        
        KVNProgress.showWithStatus(" ")
        user.signUpInBackgroundWithBlock(){
            (success:Bool, error:NSError!) -> Void in
            if success {
                AVUser.logOut()
                AVUser.logInWithUsernameInBackground(self.userNameField.text, password: self.setPasswordField.text){
                    (user :AVUser!, error :NSError!) -> Void in
                    if user != nil {
                        KVNProgress.dismiss()
                        KVNProgress.showSuccessWithStatus("注册成功")
                        // get the user name and nick name
                        me.username = AVUser.currentUser().username
                        me.nickname = AVUser.currentUser().objectForKey("NickName") as? String
                        var avartarFile = AVUser.currentUser().objectForKey("Avartar") as? AVFile
                        if avartarFile != nil{
                            // find the avatar
                            avartarFile?.getDataInBackgroundWithBlock(){
                                (imgData:NSData!, error:NSError!) -> Void in
                                if(error == nil){
                                     // save the avatar
                                    me.avartar = UIImage(data: imgData)
                                }
                            }
                        }
                        // save the password\gender\email
                        me.password = AVUser.currentUser().password
                        me.gender = AVUser.currentUser().objectForKey("gender") as? String
                        me.email = AVUser.currentUser().objectForKey("email") as? String
                        self.navigationController?.popViewControllerAnimated(true)?.navigationController?.popViewControllerAnimated(true)
                    }
                    else{
                        KVNProgress.dismiss()
                        KVNProgress.showErrorWithStatus("注册失败")
                    }
                }
            }
            else {
                KVNProgress.dismiss()
                KVNProgress.showErrorWithStatus("注册失败")
            }
        }
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }


}
