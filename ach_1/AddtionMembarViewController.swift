//
//  AddtionMembarViewController.swift
//  ach_1
//
//  Created by 早坂彪流 on 2015/07/27.
//  Copyright © 2015年 早坂彪流. All rights reserved.
//

import UIKit

class AddtionMembarViewController: UIViewController {

    @IBOutlet weak var Change_the_way1_Button: UIButton!
    @IBOutlet weak var addemail_textfield: UITextField!
    @IBOutlet weak var addpassword_textfield: UITextField!
    @IBOutlet weak var MembarAdd_button: UIButton!
    
    //画面タッチのイベント(フォーカス戻すやつ)
    @IBAction func uptapevent(sender: AnyObject) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Change_the_way1_Button.hidden = true
        self.addemail_textfield.tag = 0
        self.addpassword_textfield.tag = 1
        self.MembarAdd_button.addTarget(self, action: "MembarAdd_buttonEvent:", forControlEvents: UIControlEvents.TouchUpInside)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//buttonEvent
    func MembarAdd_buttonEvent(sender:UIButton){
        //ボタンのフォーカス外す
        addemail_textfield.resignFirstResponder()
        addpassword_textfield.resignFirstResponder()
        if addemail_textfield.text != "" && addpassword_textfield.text != ""{
            //Request
            let URLStr = "/app/organization/members/"
            let MembarAddRequest = NSMutableURLRequest(URL: NSURL(string:Utility_inputs_limit().URLdataSet+URLStr)!)
            //set　HTTP-POST
            MembarAddRequest.HTTPMethod = "POST"
            //set the header((本当はどんな動作してるかわからない。。。なくてもうごく。。。?)
            MembarAddRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            MembarAddRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")//application/jsonで指定しないとJSONをJSONで囲ってしまう。
           
            //set requestbody on data(JSON)
            MembarAddRequest.allHTTPHeaderFields = ["sessionID":"sessionID="+Utility_inputs_limit().keych_access]
            let login = ["email":addemail_textfield.text!,"password":addpassword_textfield.text!]
            do {
                if NSJSONSerialization.isValidJSONObject(login){
                    let js_login = try NSJSONSerialization.dataWithJSONObject(login, options: NSJSONWritingOptions.PrettyPrinted)
                    //bodyにいれる。
                    MembarAddRequest.HTTPBody = js_login
                }
            }catch{
                
            }
            //スレッドの設定((UIKitのための
            let q_main: dispatch_queue_t  = dispatch_get_main_queue();
            
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(MembarAddRequest, completionHandler: {data, response, error in
                if (error == nil) {
                    let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                    print(result)
                    print(response)
                    // 受け取ったJSONデータをパースする.
                    let json:NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    let rebool = json["results"] as! Bool
                    if rebool == true{
                       // NSUserDefaults.standardUserDefaults().setBool(true, forKey: )
                        dispatch_async(q_main, {
                            self.performSegueWithIdentifier("Unwind_Organization_details_to_Addmembar", sender: self)
                        })
                    }else{
                        let errstr:String = json["err"] as! String
                        //login出来ない時の処理
                        let alert = UIAlertController(title: "エラー", message: errstr, preferredStyle: UIAlertControllerStyle.Alert)
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 0{
            addpassword_textfield.becomeFirstResponder()
        }
        return true
    }
//値渡しする為のovarride
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Unwind_Organization_details_to_Addmembar") {
           
        }
        
    }
}
