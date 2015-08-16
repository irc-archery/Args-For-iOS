//
//  CreateOrganizationViewController.swift
//  ach_1
//
//  Created by 早坂彪流 on 2015/07/16.
//  Copyright © 2015年 早坂彪流. All rights reserved.
//

import UIKit

class CreateOrganizationViewController: UIViewController {

     private var indicator:MBProgressHUD! = nil
    @IBOutlet weak var OrganizationName_textfield: UITextField!
    
    @IBOutlet weak var PlayField_textfield: UITextField!
    
    @IBOutlet weak var Res_mail_textfield: UITextField!
    
   
    @IBOutlet weak var CreateOrganization_Button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
     self.CreateOrganization_Button.addTarget(self, action: "CreateOrganizatonButtonevent:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  CreateOrganizatonButtonevent(sender:UIButton){
        if OrganizationName_textfield.text != "" && PlayField_textfield.text != ""{
            //Request
            let URLStr = "/app/organization/"
            let CreateOrganazationRequest = NSMutableURLRequest(URL: NSURL(string:Utility_inputs_limit().URLdataSet+URLStr)!)
            //set　HTTP-POST
            CreateOrganazationRequest.HTTPMethod = "POST"
            //set the header((本当はどんな動作してるかわからない。。。なくてもうごく。。。?)
            CreateOrganazationRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            CreateOrganazationRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")//application/jsonで指定しないとJSONをJSONで囲ってしまう。
            //set requestbody on data(JSON)
            //set requestbody on data(JSON)
            CreateOrganazationRequest.allHTTPHeaderFields = ["cookie":"sessionID="+Utility_inputs_limit().keych_access]
            let CreateOrganazationdata = ["organizationName": OrganizationName_textfield.text!,"place":PlayField_textfield.text!,"email":Res_mail_textfield.text!]
            do {
                if NSJSONSerialization.isValidJSONObject(CreateOrganazationdata){
                let jsdata = try NSJSONSerialization.dataWithJSONObject(CreateOrganazationdata, options: NSJSONWritingOptions.PrettyPrinted)
                //bodyにいれる。
                    CreateOrganazationRequest.HTTPBody = jsdata
                }
            }catch{
                
                
            }
                //スレッドの設定((UIKitのための
                // let q_global: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                let q_main: dispatch_queue_t  = dispatch_get_main_queue();
        
        
                let task = NSURLSession.sharedSession().dataTaskWithRequest(CreateOrganazationRequest, completionHandler: {data, response, error in
            if (error == nil) {
                let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                print(result)
                print(response)
                // 受け取ったJSONデータをパースする.
                let json:NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                let rebool = json["results"] as! Bool
                if rebool == true{
                    
                    dispatch_async(q_main, {
                        self.performSegueWithIdentifier("CreateOrganization_to_OreganizationDerails", sender: self)
                    })
                }else{
                    //login出来ない時の処理
                    let alert = UIAlertController(title: "エラー", message: "何かの問題が起きました。", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)}))
                    // アラートを表示
                    self.presentViewController(alert,
                        animated: true,
                        completion: {
                            print("Alert displayed")
                    })
                }
            } else {
                print(error)
                //login出来ない時の処理
                let alert = UIAlertController(title: "エラー", message: "サーバーに到達できません。管理者に連絡または時間をおいて再度アクセスしてください", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)}))
                // アラートを表示
                self.presentViewController(alert,
                    animated: true,
                    completion: {
                        print("Alert displayed")
                })
                
            }
        })
        task.resume()
        }else{
            //login出来ない時の処理
            let alert = UIAlertController(title: "エラー", message: "記述が足りません確認をしてください。", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)}))
            // アラートを表示
            self.presentViewController(alert,
                animated: true,
                completion: {
                    print("Alert displayed")
            })
            
            
            
        }
}
    
    //値渡しする為のovarride
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "login_to_AccuntCreate") {
           
        }else if segue.identifier == "MyPage_to_PastPerformance"{
            
        }
        
    }

}