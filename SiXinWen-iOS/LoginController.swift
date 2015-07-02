//
//  LoginController.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/5/11.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit
import AVOSCloud

class LoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    
//    user log in
    @IBAction func login() {
        // ensure the name and password not empty
        if usernameField.text == "" || passwordField.text == "" {
            KVNProgress.showErrorWithStatus("用户名/密码不能为空")
            return
        }
        KVNProgress.showWithStatus(" ")
        
        // log in
        AVUser.logInWithUsernameInBackground(usernameField.text, password: passwordField.text){
            (user :AVUser!, error :NSError!) -> Void in
            if error == nil {
                KVNProgress.dismiss()
                KVNProgress.showSuccessWithStatus("登陆成功")
                // set the user name and nick name
                me.username = AVUser.currentUser().username
                me.nickname = AVUser.currentUser().objectForKey("NickName") as? String
                // set the avatar
                var avartarFile = AVUser.currentUser().objectForKey("Avartar") as? AVFile
                if avartarFile != nil{
                    // find the avatar
                    avartarFile?.getDataInBackgroundWithBlock(){
                        (imgData:NSData!, error:NSError!) -> Void in
                        if(error == nil){
                            // save the avatar
                            me.avartar = UIImage(data: imgData)
                            // save the password\gender\email
                            me.password = AVUser.currentUser().password
                            me.gender = AVUser.currentUser().objectForKey("gender") as? String
                            me.email = AVUser.currentUser().objectForKey("email") as? String
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                        else {
                            // fail to get the avatar
                            KVNProgress.showErrorWithStatus("载入头像失败")
                        }
                    }
                }
                else {
                    // cannot find the avatar
                    // save the password\gender\email
                    me.password = AVUser.currentUser().password
                    me.gender = AVUser.currentUser().objectForKey("gender") as? String
                    me.email = AVUser.currentUser().objectForKey("email") as? String
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
            else {
                // fail to log in 
                KVNProgress.dismiss()
                KVNProgress.showErrorWithStatus("用户名或密码错误")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }
    
}
