//
//  menuTableViewController.swift
//  SiXinWen-iOS
//
//  Created by Karma Guo on 5/6/15.
//  Copyright (c) 2015 SiXinWen. All rights reserved.
//

import UIKit
import AVOSCloud

class menuTableViewController: UITableViewController {

    @IBOutlet var usrPhoto: UIButton!
    @IBOutlet var userNickName: UILabel!
    
    @IBOutlet weak var loginHint: UILabel!
    
    @IBOutlet weak var nickNameCell: UITableViewCell!
    
    @IBOutlet weak var passwordCell: UITableViewCell!
    
    @IBOutlet weak var myNickName: UILabel!
    
    @IBOutlet weak var modifyPassword: UILabel!
    
    
    let photoSize: CGFloat = 70
    
    var defaultPhoto = UIImage(named: "匿名头像")!
//    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "setNickName" {
            let controller = segue.destinationViewController as! ModifyNameController
            controller.nickName = userNickName.text!
        }
        // prepare for the segue to the set Nick name controller, set the textview of it
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // configue the imageview layer and image
        usrPhoto.imageView!.layer.cornerRadius = photoSize / 2
        usrPhoto.imageView!.layer.masksToBounds = true
        usrPhoto.imageView!.layer.borderColor = UIColor.whiteColor().CGColor
        usrPhoto.imageView!.layer.borderWidth = 2.3
        usrPhoto.imageView!.image = defaultPhoto
        usrPhoto.setImage(defaultPhoto, forState: .Normal)
        usrPhoto.setImage(defaultPhoto, forState: .Selected)
    }
    
    @IBAction func clickAvartar() {
        // perform segue depend on whether user has login
        if loginHint.text == "点击登陆" {
            performSegueWithIdentifier("login", sender: nil)
        }
        else {
            performSegueWithIdentifier("userInfo", sender: nil)
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
         self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        var query = AVUser.query()
        if AVUser.currentUser() != nil {
            // configue for login user
            if me.nickname != nil && me.nickname != "" {
                self.userNickName.text = me.nickname
                self.loginHint.text = ""
                self.nickNameCell.userInteractionEnabled = true
                self.passwordCell.userInteractionEnabled = true
                self.myNickName.enabled = true
                self.modifyPassword.enabled = true
                self.userNickName.enabled = true
            }
                // configue for anonimous user
            else {
                self.userNickName.text = "未登录"
                self.loginHint.text = "点击登陆"
                self.nickNameCell.userInteractionEnabled = false
                self.passwordCell.userInteractionEnabled = false
                self.myNickName.enabled = false
                self.modifyPassword.enabled = false
                self.userNickName.enabled = false
            }
            usrPhoto.setImage(me.avartar, forState: .Normal)
            usrPhoto.setImage(me.avartar, forState: .Selected)
            

        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    // MARK: - Table view data source

   
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
