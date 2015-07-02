//
//  detailInfoController.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/5/15.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit
import AVOSCloud

let cameraIndex = 1, libraryIndex = 2


class detailInfoController: UITableViewController, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var Avatar: UIImageView!
    
    var choseSourceView: UIAlertView!

    var picker = UIImagePickerController()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init the alert view, in which user select the source of the avatar
        choseSourceView = UIAlertView(title:"修改头像" , message:"选择头像来源", delegate: self,
            cancelButtonTitle: "取消", otherButtonTitles: "拍照", "从相册选择")
        
        // init the image pick
        picker.delegate = self
        picker.allowsEditing = true
        Avatar.image = me.avartar
        
    }


    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == cameraIndex {
            // select from camera
            picker.sourceType = .Camera
            // present pick view
            self.presentViewController(picker, animated: true, completion: nil)
        }
        else if buttonIndex == libraryIndex{
            // select from photo library
            picker.sourceType = .PhotoLibrary
            // present pick view
            self.presentViewController(picker, animated: true, completion: nil)
        }
        
    }
    
// save the avatar in the server
    func saveImage(img: UIImage){
        
        var imgData = UIImagePNGRepresentation(img)
        var imgFile: AVFile = AVFile.fileWithData(imgData) as! AVFile
        AVUser.currentUser().setObject(imgFile, forKey: "Avartar")
        KVNProgress.showWithStatus(" ")
        AVUser.currentUser().saveInBackgroundWithBlock(){
            (success:Bool,error: NSError!) -> Void in
            if success {
                me.avartar = img
                KVNProgress.dismiss()
                KVNProgress.showSuccessWithStatus("上传成功")
            }
            else {
                KVNProgress.dismiss()
                KVNProgress.showErrorWithStatus("上传失败")
            }
        }
        
        
    }
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        var img = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if img != nil {
        img!.drawInRect(CGRectMake(0 , 0, 100, 100))
        Avatar.image = img
        saveImage(img!)
            
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func changeAvatar(sender: AnyObject) {
              choseSourceView.show()
    }
    
    
// log out
    @IBAction func Logout(sender: AnyObject) {
        
        var installationId:String = UIDevice.currentDevice().identifierForVendor.UUIDString
        
        AVUser.logInWithUsernameInBackground(installationId, password: "password"){
            (user :AVUser!, error :NSError!) -> Void in
            if user != nil {
                me.username = AVUser.currentUser().username
                me.nickname = AVUser.currentUser().objectForKey("NickName") as? String
                var avartarFile = AVUser.currentUser().objectForKey("Avartar") as? AVFile
                if avartarFile != nil{
                    
                    avartarFile?.getDataInBackgroundWithBlock(){
                        (imgData:NSData!, error:NSError!) -> Void in
                        if(error == nil){
                            me.avartar = UIImage(data: imgData)
                                                    }
                    }
                }
                else {
                    me.avartar = UIImage(named: "usrwalker")
                }
                me.password = AVUser.currentUser().password
                me.gender = AVUser.currentUser().objectForKey("gender") as? String
                self.navigationController?.popViewControllerAnimated(true)
            }
            else{
                // fail to log out
                KVNProgress.showErrorWithStatus("网络错误")
            }
        }

        
        
        
    }
    
    
   
}
