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

        choseSourceView = UIAlertView(title:"修改头像" , message:"选择头像来源", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "拍照", "从相册选择")
        
        picker.delegate = self
        picker.allowsEditing = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == cameraIndex {
            picker.sourceType = .Camera
            self.presentViewController(picker, animated: true, completion: nil)
        }
        else if buttonIndex == libraryIndex{
            picker.sourceType = .PhotoLibrary
            self.presentViewController(picker, animated: true, completion: nil)
        }
        
    }
    
    func saveImage(img: UIImage){
        
        var imgData = UIImagePNGRepresentation(img)
        var imgFile: AVFile = AVFile.fileWithData(imgData) as! AVFile
        AVUser.currentUser().setObject(imgFile, forKey: "Avartar")
        AVUser.currentUser().saveInBackgroundWithBlock(){
            (success:Bool,error: NSError!) -> Void in
            if success {
                me.avartar = img
                KVNProgress.showSuccessWithStatus("上传成功")
                //self.navigationController?.popViewControllerAnimated(true)
            }
            else {
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
    
    
    
    @IBAction func Logout(sender: AnyObject) {
      //  AVUser.logOut()
        var installationId:String = UIDevice.currentDevice().identifierForVendor.UUIDString
        
        AVUser.logInWithUsernameInBackground(installationId, password: "password"){
            (user :AVUser!, error :NSError!) -> Void in
            if user != nil {
                println("用户登陆成功")
                //installation.addUniqueObject("Giants", forKey: "channels")
                //installation.setObject(AVObject(withoutDataWithClassName: "_User", objectId: AVUser.currentUser().objectId), forKey: "user")
        
                
                me.username = AVUser.currentUser().username
                me.nickname = AVUser.currentUser().objectForKey("NickName") as? String
                var avartarFile = AVUser.currentUser().objectForKey("Avartar") as? AVFile
                if avartarFile != nil{
                    //   println("asdfasdfasdf")
                    avartarFile?.getDataInBackgroundWithBlock(){
                        (imgData:NSData!, error:NSError!) -> Void in
                        if(error == nil){
                            me.avartar = UIImage(data: imgData)
                            //                                self.usrPhoto.imageView!.image = UIImage(data: imgData)
                            // println("asdfasdfasdf")
                            //self.tableView.reloadData()
                        }
                    }
                }
                me.password = AVUser.currentUser().password
                me.gender = AVUser.currentUser().objectForKey("gender") as? String
                self.navigationController?.popViewControllerAnimated(true)
            }
            else{
                println("用户登录失败")
                KVNProgress.showErrorWithStatus("网络错误")
            }
        }

        
        
        
    }
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
