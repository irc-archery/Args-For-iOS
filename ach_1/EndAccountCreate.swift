//
//  acacreateViewController.swift
//  ach_1
//
//  Created by 早坂彪流 on 2015/05/20.
//  Copyright (c) 2015年 早坂彪流. All rights reserved.
//




protocol Endacareate_delegate{
    func accreate_event(flag:Bool)
}
import UIKit

class EndAccountCreateViewController:UIViewController ,UITextFieldDelegate,UIToolbarDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate{
 
    //テキスト
    @IBOutlet weak var last_name_textfield: UITextField!
    @IBOutlet weak var frist_name_textfield: UITextField!
    @IBOutlet weak var H_last_name_textfield: UITextField!
    @IBOutlet weak var Hfrist_name_textfield: UITextField!
    @IBOutlet weak var email_textfield: UITextField!
    @IBOutlet weak var ps_textfield: UITextField!
    
    @IBOutlet weak var ps_Confirmation_textfield: UITextField!
    @IBOutlet weak var data_of_birth_textfield: UITextField!
    //チェックボックス
    @IBOutlet weak var male_button: UIButton!
    @IBOutlet weak var female_button: UIButton!
    @IBOutlet weak var fm_button: UIButton!
    //新規登録
    @IBOutlet weak var newcreate_Button: UIButton!
    
    
    private var indicator:MBProgressHUD! = nil
    //ツール達
    var myToolBar:UIToolbar!
    var dataPic:UIDatePicker!
    //チェックボックスのフラグ
    var male_button_flag:Bool = false
    var female_button_flag:Bool = false
    var fm_button_flag:Bool = false
    var checkoff:UIImage! = UIImage(named: "checkbox_off_background.png")
    var checkon:UIImage!  = UIImage(named: "checkbox_on_background.png")
    
    //送りつける者達
    var firstname:String! //'firstName':	string,	// 名
    var lastname:String! //'lastName':		string,	// 姓
    var H_firstname:String!// ふりがな - 名
    var H_lastname:String!// ふりがな - 姓
    var emails:String!//email
    var password:String! //password
    
    var year :String!
    var mounth:String!
    var day:String!
    var birth:NSDate!// 生年月日 format : 1997-08-06
    var birthString:String!
    var sex:Int! = 9 // 男性 : 0, 女性 : 1, その他 : 8, 未設定 : 9
    
    var textbarF:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //tag付け
        last_name_textfield.tag = 1
        frist_name_textfield.tag = 2
        H_last_name_textfield.tag = 3
        Hfrist_name_textfield.tag = 4
        email_textfield.tag = 5
        ps_textfield.tag = 6
        ps_Confirmation_textfield.tag = 7
        data_of_birth_textfield.tag = 8
        //set buttonevent
        self.male_button.addTarget(self, action: "male_button_event:", forControlEvents: UIControlEvents.TouchUpInside)
        self.female_button.addTarget(self, action: "female_button_event:", forControlEvents: UIControlEvents.TouchUpInside)
        self.fm_button.addTarget(self, action: "fm_button_event:", forControlEvents: UIControlEvents.TouchUpInside)
        self.newcreate_Button.addTarget(self, action: "createac_event:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Tool
        myToolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.width, 40))
        myToolBar.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.size.height-20)
        myToolBar.backgroundColor = UIColor.blackColor()
        myToolBar.barStyle = UIBarStyle.Black
        myToolBar.tintColor = UIColor.blackColor()
        myToolBar.delegate = self
        
        //閉じるボタンを追加など
        let myToolBarButton = UIBarButtonItem(title: "close", style: UIBarButtonItemStyle.Done, target: self, action: "onClick:")
        myToolBarButton.tag = 1
        myToolBarButton.tintColor = UIColor.whiteColor()
        myToolBar.items = [myToolBarButton]
        dataPic = UIDatePicker()
        dataPic.datePickerMode = UIDatePickerMode.Date//モード年月日
        let df = NSDateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        let nowdate = NSDate()
        dataPic.minimumDate = df.dateFromString("1900/01/01")
        dataPic.maximumDate = df.dateFromString(df.stringFromDate(nowdate))
        data_of_birth_textfield.inputView = dataPic
        data_of_birth_textfield.inputAccessoryView = myToolBar
        dataPic.addTarget(self, action: "pickerValueChange:", forControlEvents: UIControlEvents.ValueChanged)
        last_name_textfield.becomeFirstResponder()//フォーカス当てる
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //textfieldDelegate
    //改行でフォーカス外す
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 1{
            frist_name_textfield.becomeFirstResponder()
        }else if textField.tag == 2{
            H_last_name_textfield.becomeFirstResponder()
        }else if textField.tag == 3{
            Hfrist_name_textfield.becomeFirstResponder()
        }else if textField.tag == 4{
            email_textfield.becomeFirstResponder()
        }else if textField.tag == 5{
            ps_textfield.becomeFirstResponder()
        }else if textField.tag == 6{
            ps_Confirmation_textfield.becomeFirstResponder()
        }else if textField.tag == 7{
            data_of_birth_textfield.becomeFirstResponder()
        }
        return true
    }
    //buttonevent
    func male_button_event(sender:UIButton!){
        if(male_button_flag == false){
            male_button_flag = true
            self.male_button.setImage(checkon, forState: UIControlState.Normal)
            sex = 0
            //他のを解除
            female_button_flag = false
            self.female_button.setImage(checkoff, forState: UIControlState.Normal)
            fm_button_flag = false
            self.fm_button.setImage(checkoff, forState: UIControlState.Normal)
            
        }else{
            male_button_flag = false
            self.male_button.setImage(checkoff, forState: UIControlState.Normal)
            sex = 9
        }
    }
    func female_button_event(sender:UIButton!){
        if(female_button_flag == false){
            female_button_flag = true
            self.female_button.setImage(checkon, forState: UIControlState.Normal)
            //他のを解除
            male_button_flag = false
            self.male_button.setImage(checkoff, forState: UIControlState.Normal)
            fm_button_flag = false
            self.fm_button.setImage(checkoff, forState: UIControlState.Normal)
            sex = 1
        }else{
            female_button_flag = false
            self.female_button.setImage(checkoff, forState: UIControlState.Normal)
            sex = 9
        }
        
    }
    func fm_button_event(sender:UIButton!){
        if(fm_button_flag == false){
            fm_button_flag = true
            self.fm_button.setImage(checkon, forState: UIControlState.Normal)
            
            //他のを解除
            male_button_flag = false
            self.male_button.setImage(checkoff, forState: UIControlState.Normal)
            female_button_flag = false
            self.female_button.setImage(checkoff, forState: UIControlState.Normal)
            sex = 1
        }else{
            fm_button_flag = false
            self.fm_button.setImage(checkoff, forState: UIControlState.Normal)
            sex = 9
        }
        
    }
    // && (male_button_flag == true || female_button_flag == true || )
    func createac_event(sender:UIButton){
        //記入漏れがあるかどうか
        if last_name_textfield.text != "" && frist_name_textfield != "" && H_last_name_textfield.text != "" && Hfrist_name_textfield.text != "" && email_textfield.text != "" && ps_textfield.text != "" && ps_Confirmation_textfield.text != "" && data_of_birth_textfield.text != ""{
            
            firstname = frist_name_textfield.text
            lastname = last_name_textfield.text
            H_firstname = Hfrist_name_textfield.text
            H_lastname = H_last_name_textfield.text
            emails = email_textfield.text
            password = ps_textfield.text
            
            
            
            //パスワードが同じかどうか
            if ps_textfield.text == ps_Confirmation_textfield.text {
                let URLStr = "/app/createAccount"
                //  let URLStr = "http://49.212.91.93/app/createAccount"
                // POST用のリクエストを生成.
                let SessionRequest = NSMutableURLRequest(URL: NSURL(string: Utility_inputs_limit().URLdataSet + URLStr)!)
                
                // set the method(HTTP-GET)
                SessionRequest.HTTPMethod = "POST"
                //set the header((本当はどんな動作してるかわからない。。。なくてもうごく。。。?)
                SessionRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                SessionRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                //データを付属させる
                let postingData  = ["firstName":firstname,"lastName":lastname,"rubyFirstName":H_firstname,"rubyLastName":H_lastname,"email":emails,"password":password,"birth":birthString ,"sex":sex]
                do {
                    let js_AC = try! NSJSONSerialization.dataWithJSONObject(postingData, options: NSJSONWritingOptions.PrettyPrinted)
                    //bodyにいれる。
                    SessionRequest.HTTPBody = js_AC
                    
                }catch{
                    
                }
                
                //スレッドの設定((UIKitのための
                //let _q_global: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                let q_main: dispatch_queue_t  = dispatch_get_main_queue();
                
                //make of task
                let myTask = NSURLSession.sharedSession().dataTaskWithRequest(SessionRequest, completionHandler: {data,response,error in
                    
                    if (error == nil) {
                        let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                        var rebool:Bool! = false
                        var errstr:String!
                        // 受け取ったJSONデータをパースする.
                        do{
                            let json:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                            if (json["err"] as? String != nil){
                                errstr = json["err"] as! String
                            }
                            rebool = json["results"] as! Bool
                        }catch{
                            errstr = "50x系のhttpレスポンスなどのエラーの可能性があります。Server管理者にお問い合わせください。"
                        }
                        print(response)
                        print("result\(result)")
                        if rebool == true{
                            //ここからcookieを使う
                            let httpReponse:NSHTTPURLResponse = response as! NSHTTPURLResponse
                            let cookies:NSArray = NSHTTPCookie.cookiesWithResponseHeaderFields(httpReponse.allHeaderFields as! [String : String], forURL: httpReponse.URL!)
                            //var cookies:NSArray = NSHTTPCookie.cookiesWithResponseHeaderFields(httpReponse.allHeaderFields, forURL: response.URL as NSURL!)
                            //クッキーの抜き出し
                            print(cookies)
                            for var i = 0;i<cookies.count;i++
                            {
                                let cookie:NSHTTPCookie = cookies.objectAtIndex(i) as! NSHTTPCookie
                                print(cookie.name, cookie.value)
                                if rebool  == true{
                                    if(cookie.name == "sessionID"){
                                        //保存を書く:::**********************************
                                        Utility_inputs_limit().keych_access = cookie.value
                                    }
                                    // 更新はmain threadで
                                    dispatch_async(q_main, {
                                        self.performSegueWithIdentifier("Unwind_Mypage_to_EndAccountCreate", sender: self)
                                    })
                                }
                            }
                        } else{
                            
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
                        })
                    }
                })
                myTask.resume()
            }else{
                //ps同じじゃない時の処理korekara
                let alert = UIAlertController(title: "エラー", message: "passwordが異なります。お確かめください。", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)}))
                // アラートを表示
                self.presentViewController(alert,
                    animated: true,
                    completion: {
                        print("Alert displayed")
                })
                
            }
        }else{
            //何も記述されてない時の処理korekara
            //ps同じじゃない時の処理korekara
            let alert = UIAlertController(title: "エラー", message: "記入漏れが存在します。ご確認ください", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)}))
            // アラートを表示
            self.presentViewController(alert,
                animated: true,
                completion: {
                    print("Alert displayed")
            })
            
            
        }
    }
    
    
    
    //値渡しできるやつ
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "AccountCreate_to_MyPage") {
          
            
            
        }
    }
    
    
    //閉じる
    func onClick(sender: UIBarButtonItem) {
        data_of_birth_textfield.resignFirstResponder()
    }
    //dataの引取と文字列分解
    func pickerValueChange(sender:UIDatePicker){
        var selectdata = String(sender.date)
        var Dcount = 0
        var count = 0
        var countfag = 0
        
        print(sender.date)
        while  true{
            count++
            
            if selectdata[advance(selectdata.startIndex, count)] == "-"{
                if Dcount==0{
                    year = selectdata[0..<count]
                    countfag = count
                    Dcount++
                }else if Dcount == 1{
                    mounth = selectdata[countfag+1..<count]
                    countfag = count
                    Dcount++
                }
            }
            if selectdata[advance(selectdata.startIndex, count)] == " "{
                if Dcount == 2{
                    day = selectdata[countfag+1..<count]
                    countfag = count
                    Dcount++
                    break
                }
            }
        }
        print(year+"年"+mounth+"月"+day+"日")
        if Int(day)!+1 < 32 {
            let dayser = Int(day)!+1
            let fday = String(dayser)

            data_of_birth_textfield.text = String(year+"年"+mounth+"月"+fday+"日")
            birthString = "\(year)-\(mounth)-\(fday)"
        }else{
            data_of_birth_textfield.text = String(year+"年"+mounth+"月"+day+"日")
            birthString = "\(year)-\(mounth)-\(day)"
        }
        let format = NSDateFormatter()
        format.dateFormat = "yyyy/MM/dd"
        format.locale = NSLocale(localeIdentifier: "ja")
        birth = format.dateFromString(birthString)
        
        
    }
    
    @IBAction func uptapevent(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
}

