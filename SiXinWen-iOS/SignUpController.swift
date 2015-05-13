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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func SignUp(sender: UIButton) {
        
        if userNameField.text == "" || nickNameField.text == "" || setPasswordField.text == "" || ensurePasswordField.text == "" {
            KVNProgress.showErrorWithStatus("无效的用户名/昵称/密码")
            return
        }
        
        if setPasswordField.text != ensurePasswordField.text {
            KVNProgress.showErrorWithStatus("密码不一致")
            return
        }
        
        var user = AVUser()
        user.username = userNameField.text
        user.password = setPasswordField.text
        user.setObject(nickNameField.text, forKey: "NickName")
        user.signUpInBackgroundWithBlock(){
            (success:Bool, error:NSError!) -> Void in
            if success {
                AVUser.logOut()
                AVUser.logInWithUsernameInBackground(self.userNameField.text, password: self.setPasswordField.text){
                    (user :AVUser!, error :NSError!) -> Void in
                    if user != nil {
                        KVNProgress.showSuccessWithStatus("注册成功")
                        self.navigationController?.popViewControllerAnimated(true)?.navigationController?.popViewControllerAnimated(true)
                    }
                    else{
                        KVNProgress.showErrorWithStatus("注册失败")
                    }
                }
                //self.navigationController?.popViewControllerAnimated(true)
            }
            else {
                KVNProgress.showErrorWithStatus("注册失败")
            }
        }
        
        
        
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
