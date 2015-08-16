//
//  login_ViewController.swift
//  ach_1
//
//  Created by 早坂彪流 on 2015/05/04.
//  Copyright (c) 2015年 早坂彪流. All rights reserved.
//

import UIKit

class login_ViewController: UIViewController,NSURLSessionDelegate,NSURLSessionDataDelegate,UITextFieldDelegate {
    var ioview:UIView!
    var logoImageView: UIImageView!
    
   private var socket:SIOSocket! = nil
    var dic:[AnyObject]!
    private var indicator:MBProgressHUD! = nil
    @IBOutlet weak var login_sendbutton: UIButton!
    @IBOutlet weak var email_textfield: UITextField!
    @IBOutlet weak var password_textfield: UITextField!
    @IBOutlet weak var AccountCreate_Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*animation Tenp*/
         self.ioview = UIView(frame:CGRectMake(0, 0, view.frame.width, view.frame.height))
        self.view.addSubview(ioview)
        //imageView作成
        self.logoImageView = UIImageView(frame: CGRectMake(0, 0, view.frame.width, 200))
        self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
        //画面centerに
        self.logoImageView.center = self.view.center
        //logo設定
        self.logoImageView.image = UIImage(named: "args-logo-title4-trim-ver2.png")
        //viewに追加
        self.ioview.addSubview(self.logoImageView)
        self.ioview.backgroundColor = UIColor(red: 61.0, green: 120.0, blue:204.0, alpha: 1.0)
     
        //buttonの関連ずけ
        login_sendbutton.addTarget(self, action: "loginsend:", forControlEvents: UIControlEvents.TouchUpInside)
        AccountCreate_Button.addTarget(self, action: "gotoAccountCreate:", forControlEvents: UIControlEvents.TouchUpInside)
        //delgate...etc
        password_textfield.delegate = self
        email_textfield.delegate = self
        password_textfield.tag = 2
        email_textfield.tag = 1
    }
    override func viewDidAppear(animated: Bool) {
        //少し縮小するアニメーション
        UIView.animateWithDuration(0.4,
            delay: 1.0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: { () in
                self.logoImageView.transform = CGAffineTransformMakeScale(0.8, 0.8)
            }, completion: { (Bool) in
                
        })
        
        //拡大させて、消えるアニメーション
        UIView.animateWithDuration(0.2,
            delay: 1.3,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: { () in
                self.logoImageView.transform = CGAffineTransformMakeScale(2.5, 2.5)
                self.logoImageView.alpha = 0
            }, completion: { (Bool) in
                self.logoImageView.removeFromSuperview()
                self.ioview.removeFromSuperview()
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnMenulogin(segue:UIStoryboardSegue){
        
    }
    
    
    
    
    //buttonイベント
    func loginsend(sender:UIButton!){
        
        //ボタンのフォーカス外す
        email_textfield.resignFirstResponder()
        password_textfield.resignFirstResponder()
        
        if email_textfield.text != "" && password_textfield.text != ""{
            // アニメーションを開始する.
            self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.indicator.dimBackground = true
            self.indicator.labelText = "Loading..."
            self.indicator.labelColor = UIColor.whiteColor()
        //Request
        let URLStr = "/app/Login"
        let loginRequest = NSMutableURLRequest(URL: NSURL(string:Utility_inputs_limit().URLdataSet+URLStr)!)
        //set　HTTP-POST
        loginRequest.HTTPMethod = "POST"
        //set the header((本当はどんな動作してるかわからない。。。なくてもうごく。。。?)
        loginRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        loginRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")//application/jsonで指定しないとJSONをJSONで囲ってしまう。
        //set requestbody on data(JSON)
        let login = ["email":email_textfield.text!,"password":password_textfield.text!]
        do {
            if NSJSONSerialization.isValidJSONObject(login){
            let js_login = try NSJSONSerialization.dataWithJSONObject(login, options: NSJSONWritingOptions.PrettyPrinted)
            //bodyにいれる。
            loginRequest.HTTPBody = js_login
            }
        }catch{
        
        }
        //スレッドの設定((UIKitのための
      
        let q_main: dispatch_queue_t  = dispatch_get_main_queue();
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(loginRequest, completionHandler: {data, response, error in
            if (error == nil) {
                
                var rebool:Bool! = false
                var errstr:String!
                // 受け取ったJSONデータをパースする.
                do{
                    let json:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                     rebool = json["results"] as! Bool
                     errstr = json["err"] as? String
                }catch{
                  errstr = "50x系のhttpレスポンスなどのエラーの可能性があります。Server管理者にお問い合わせください。"
                }
               
                if rebool == true{
                    // 更新はmain threadで
                        let httpReponse:NSHTTPURLResponse = response as! NSHTTPURLResponse
                        let cookies:NSArray = NSHTTPCookie.cookiesWithResponseHeaderFields(httpReponse.allHeaderFields as! [String : String], forURL: httpReponse.URL!)
                    
                    
                        //クッキーの抜き出し
                        print(cookies.count)
                
                            for var i = 0;i<cookies.count;i++
                            {
                                let cookie:NSHTTPCookie = cookies.objectAtIndex(i) as! NSHTTPCookie
                                print(cookie.name, cookie.value)
                                //保存を書く:::**********************************
                               Utility_inputs_limit().keych_access = cookie.value
                            
                            }
                            dispatch_async(q_main, {
                                MBProgressHUD.hideHUDForView(self.view, animated: true)

                                self.performSegueWithIdentifier("login_to_mypage", sender: self)
                            })
                    }else  {
                    
                            //login出来ない時の処理
                            let alert = UIAlertController(title: "エラー", message: errstr, preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)}))
                            // アラートを表示
                            self.presentViewController(alert,
                                animated: true,
                                completion: {
                            print("Alert displayed")
                            MBProgressHUD.hideHUDForView(self.view, animated: true)

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
                            MBProgressHUD.hideHUDForView(self.view, animated: true)

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
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
            })

        
        }
        }
    func gotoAccountCreate(sender:UIButton!){
        self.performSegueWithIdentifier("login_to_AccuntCreate", sender: self)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 1{
            password_textfield.becomeFirstResponder()
        }
        return true
    }
    //値渡しする為のovarride
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     

    }
   //どこの画面をタップしてもフォーカスを外すのが動く
    @IBAction func uptapevent(sender: AnyObject) {
        self.view.endEditing(true)
    }
}
