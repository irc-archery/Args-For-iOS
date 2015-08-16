//
//  mypageViewController.swift
//  ach_1
//
//  Created by 早坂彪流 on 2015/07/16.
//  Copyright © 2015年 早坂彪流. All rights reserved.
//

import UIKit

class mypageViewController: UIViewController ,BEMSimpleLineGraphDataSource,BEMSimpleLineGraphDelegate{
    
    struct record {
        var matchName:String!// 得点表が作成された試合名
        var created:String!// 得点表が作成された日時
        var sum:Int!// 得点合計
        var arrows:Int!//射数
        var perEnd:Int!//setvalue
        var avg:Int!// 得点heikinn
    }
    //protdata
    // サンプルラベル
    var SampleLabel: Array<String> = ["1", "2", "3", "4", "5"]
  
    
    @IBOutlet weak var stdname_Label: UILabel!
    @IBOutlet weak var stdemail_Label: UILabel!
    @IBOutlet weak var stdOrganizationName_Label: UILabel!
    
    @IBOutlet weak var stdI_born_Label: UILabel!
    
    @IBOutlet weak var sex_Label: UILabel!
    @IBOutlet weak var OrganizationPage_Button: UIButton!
    //    @IBOutlet weak var CreateGame_Button: UIButton!
    @IBOutlet weak var MatchList_Button: UIButton!
    @IBOutlet weak var PastPerformance_Button: UIButton!
    @IBOutlet weak var AccountRemove_Button: UIButton!
    
    @IBOutlet weak var Logout_Button: UIButton!
    
    @IBOutlet weak var ProtFoundaton: UIView!
    private var indicator:MBProgressHUD! = nil
    
    
    @IBOutlet weak var S_1_Label: UILabel!
    @IBOutlet weak var sa_1_Label: UILabel!
    @IBOutlet weak var S_2_Label: UILabel!
    @IBOutlet weak var sa_2_Label: UILabel!
    @IBOutlet weak var S_3_Label: UILabel!
    @IBOutlet weak var sa_3_Label: UILabel!
    @IBOutlet weak var S_4_Label: UILabel!
    @IBOutlet weak var sa_4_Label: UILabel!
    @IBOutlet weak var S_5_Label: UILabel!
    @IBOutlet weak var sa_5_Label: UILabel!
    
    
    
    
    
    /*パーソナルデータ*/
    var playerName:String!
    var rubyPlayerName:String!
    var email:String!
    var birth:String!
    var sex:Int!
    var organizationName:String!
    var recordlist :Array<record>! = []
    
    func viewaddtionData(){
        if recordlist.isEmpty == false{
            print(recordlist.count)
            if 0<recordlist.count {
                S_1_Label.text = "試合:"+self.recordlist[0].matchName
                sa_1_Label.text = "sum:"+String(self.recordlist[0].sum) + "avg:" + String(self.recordlist[0].avg)
            }
            if 1<recordlist.count{
                S_2_Label.text = "試合:"+self.recordlist[1].matchName
                sa_2_Label.text = "sum:"+String(self.recordlist[1].sum) + "avg:" + String(self.recordlist[1].avg)
            }
            if 2 <  recordlist.count{
                S_3_Label.text = "試合:"+self.recordlist[2].matchName
                sa_3_Label.text = "sum:"+String(self.recordlist[2].sum) + "avg:" + String  (self.recordlist[2].avg)
            }
            if 3 < recordlist.count{
                S_4_Label.text = "試合:"+self.recordlist[3].matchName
                sa_4_Label.text = "sum:"+String(self.recordlist[3].sum) + "avg:" + String(self.recordlist[3].avg)
            }
            if 4 < recordlist.count{
                S_5_Label.text = "試合:"+self.recordlist[4].matchName
                sa_5_Label.text = "sum:"+String(self.recordlist[4].sum) + "avg:" + String(self.recordlist[4].avg)
            }
            
        }
        //protのやつ
        let ProtView:BEMSimpleLineGraphView = BEMSimpleLineGraphView(frame: CGRectMake(0,34, self.view.frame.width - 16 - 5,self.ProtFoundaton.frame.height - 34))
        ProtView.dataSource = self
        ProtView.delegate = self
        ProtView.enableYAxisLabel = true// Y軸のラベルを表示
        ProtView.enableXAxisLabel = true// X軸のラベルを表示
        ProtView.enableReferenceAxisFrame = true// X, Y軸のフレーム（外枠）を表示するか
        ProtView.enableReferenceXAxisLines = true
        ProtView.enableReferenceYAxisLines = true
        ProtView.enableBezierCurve = false//各ポイントを結ぶ線を滑らかに表示するか
        // Y軸をViewの高さに合わせてスケールするか
        ProtView.autoScaleYAxis = true
        ProtView.alwaysDisplayDots = true
        ProtView.colorLine = UIColor.orangeColor()
        ProtView.colorTop = UIColor.whiteColor()
        ProtView.colorBottom = UIColor.whiteColor()
        ProtView.widthLine = 5
        self.ProtFoundaton.addSubview(ProtView)
        
    }
    func HTTPAccs(){
        self.recordlist.removeAll()
        // アニメーションを開始する.
        self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.indicator.dimBackground = true
        self.indicator.labelText = "Loading..."
        self.indicator.labelColor = UIColor.whiteColor()
        
        
        //スレッドの設定((UIKitのための
        // let q_global: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        let q_main: dispatch_queue_t  = dispatch_get_main_queue();
        //        dispatch_async(q_main, {
        //            self.performSegueWithIdentifier("login_to_mypage", sender: self)
        //        })
        //Request
        let URLStr = "/app/personal"
        let loginRequest = NSMutableURLRequest(URL: NSURL(string:Utility_inputs_limit().URLdataSet+URLStr)!)
        // set the method(HTTP-GET)
        loginRequest.HTTPMethod = "GET"
        //GET 付属情報
        //set requestbody on data(JSON)
        loginRequest.allHTTPHeaderFields = ["cookie":"sessionID="+Utility_inputs_limit().keych_access]
        print(loginRequest)
        
        // use NSURLSession
        let task = NSURLSession.sharedSession().dataTaskWithRequest(loginRequest, completionHandler: { data, response, error in
            if (error == nil) {
                //convert json data to dictionary
                do{
                    let  dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    print(dict);//かくにんよう
                    self.playerName = dict["playerName"] as? String
                    self.rubyPlayerName = dict["rubyPlayerName"] as? String
                    self.email = dict["email"] as? String
                    self.birth = dict["birth"] as? String
                    self.sex = dict["sex"] as? Int
                    self.organizationName = dict["organizationName"] as? String
                    let errstd = dict["err"] as? String
                    if errstd != nil{
                        dispatch_async(q_main, {
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            let see:LUKeychainAccess! = LUKeychainAccess.standardKeychainAccess()!
                            see.setString("nilf", forKey: "sessionID");
                            let alert = UIAlertController(title: "err", message: errstd!+"login画面へ遷移します。", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)
                                self.performSegueWithIdentifier("mypage_to_Endlogin", sender: self)
                                
                            }))
                            // アラートを表示
                            self.presentViewController(alert,
                                animated: true,
                                completion: {
                                    print("Alert displayed")
                            })
                        })
                    }
                    else if   (dict["record"] is NSArray) == true{
                        let recorddata:NSArray = (dict["record"] as? NSArray)!
                        
                        for var counter:Int = 0; counter < recorddata.count;counter++ {
                            let dicrecorddata = recorddata[counter] as! NSDictionary
                            let _matchName:String = (dicrecorddata["matchName"] as? String)!
                            let _created:String = (dicrecorddata["created"] as? String)!
                            let _sum:Int = (dicrecorddata["sum"] as? Int)!
                            let _arrows:Int = (dicrecorddata["arrows"] as? Int)!
                            let _perEnd:Int = (dicrecorddata["perEnd"] as? Int)!
                            var _avg:Int = 0
                            if _perEnd != 0 && _sum != 0 {
                                _avg = _sum / _perEnd
                            }
                            self.recordlist.append(record(matchName: _matchName, created: _created, sum: _sum, arrows: _arrows, perEnd: _perEnd, avg: _avg))
                            print(counter)
                        }
                    }
                } catch{
                    
                }
                //やりかけ
                dispatch_async(q_main, {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    if self.playerName == nil {
                        self.playerName = ""
                    }
                    self.stdname_Label.text = "名前:"+self.playerName
                    
                    if self.email == nil {
                        self.email =  ""
                    }
                    self.stdemail_Label.text = "E-mail:"+self.email
                    
                    if self.birth == nil {
                        self.birth =  ""
                    }
                    self.stdI_born_Label.text = "生年月日:"+self.birth
                    
                    var sexst:String!
                    if self.sex == nil {
                        sexst = ""
                    }
                    else if self.sex == 0 {
                        sexst = "男性"
                    }else if self.sex == 1{
                        sexst = "女性"
                    }else if self.sex == 8 {
                        sexst = "その他"
                    }else if self.sex == 9 {
                        sexst = "未設定"
                    }
                    self.sex_Label.text = "性別:"+sexst
                    
                    if self.organizationName == nil{
                        self.organizationName = ""
                    }
                    self.stdOrganizationName_Label.text = "所属団体名:"+self.organizationName
                    self.viewaddtionData()
                    
                    
                })
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
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //http通信
        HTTPAccs()
        //buttonevent
        self.OrganizationPage_Button.addTarget(self, action: "OrganizationPage_Button_Event:", forControlEvents: UIControlEvents.TouchUpInside)
        // self.CreateGame_Button.addTarget(self, action: "CreateGame_Button_Event:", forControlEvents: UIControlEvents.TouchUpInside)
        self.MatchList_Button.addTarget(self, action: "MatchList_Button_Event:", forControlEvents: UIControlEvents.TouchUpInside)
        self.PastPerformance_Button.addTarget(self, action: "PastPerformance_Button_Event:", forControlEvents: UIControlEvents.TouchUpInside)
        self.AccountRemove_Button.addTarget(self, action: "AccountRemove_Button_Event:", forControlEvents: UIControlEvents.TouchUpInside)
        self.Logout_Button.addTarget(self, action: "Logout_Button_Event:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //buttonevent
    func OrganizationPage_Button_Event(sender:UIButton!){
        if organizationName == ""{
            self.performSegueWithIdentifier("MyPage_to_CreateOrganization", sender: self)
        }else{
            self.performSegueWithIdentifier("MyPage_to_OreganizationDerails", sender: self)
        }
    }
    func CreateGame_Button_Event(sender:UIButton!){
        self.performSegueWithIdentifier("MyPage_to_CreateMatch", sender: self)
    }
    func MatchList_Button_Event(sender:UIButton!){
        self.performSegueWithIdentifier("MyPage_to_Allba", sender: self)
    }
    func PastPerformance_Button_Event(sender:UIButton){
        self.performSegueWithIdentifier("MyPage_to_PastPerformance", sender: self)
    }
    func AccountRemove_Button_Event(sender:UIButton){
        //login出来ない時の処理
        let alert = UIAlertController(title: "確認", message: "本当に削除しますか？", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)
        
    

        let URLStr = "/app/personal"
        let HTTPRequest = NSMutableURLRequest(URL: NSURL(string:Utility_inputs_limit().URLdataSet+URLStr)!)
        HTTPRequest.HTTPMethod = "DELETE"
        let deleteRequest = ["sessionID":"sessionID="+Utility_inputs_limit().keych_access]
        do {
            if NSJSONSerialization.isValidJSONObject(deleteRequest){
                _ = try NSJSONSerialization.dataWithJSONObject(deleteRequest, options: NSJSONWritingOptions.PrettyPrinted)
                //bodyにいれる。
                HTTPRequest.allHTTPHeaderFields = deleteRequest
            }
        }catch{
            
        }
        let q_main: dispatch_queue_t  = dispatch_get_main_queue();
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(HTTPRequest, completionHandler: { data, response, error in
            if (error == nil) {
                let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                print(result)
                print(response)
                // 受け取ったJSONデータをパースする.
                let json:NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                let rebool = json["results"] as! Bool
                if rebool == true{
                    // 更新はmain threadで
                    //let httpReponse:NSHTTPURLResponse = response as! NSHTTPURLResponse
                    
                    dispatch_async(q_main, {
                        self.performSegueWithIdentifier("mypage_to_Endlogin", sender: self)
                    })
                }else{
                    let errStr:String = json["err"] as! String
                    //login出来ない時の処理
                    let alert = UIAlertController(title: "エラー", message: errStr, preferredStyle: UIAlertControllerStyle.Alert)
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
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)}))
        // アラートを表示
        self.presentViewController(alert,
            animated: true,
            completion: {
                print("Alert displayed")
        })
    }
    func Logout_Button_Event(sender:UIButton){
        
        let see:LUKeychainAccess! = LUKeychainAccess.standardKeychainAccess()!
        if see != "nilf"||see != nil{
            
            see.setString("nilf", forKey: "sessionID");    print(see.stringForKey("sessionID"))
            
            
            //sessionの破棄ができてれば
            if see.stringForKey("sessionID") == "nilf"{
                //アラートのインスタンスを生成
                let alert = UIAlertController(title: "リザルト", message: "logoutしました。login画面へ移行します。", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)
                    self.performSegueWithIdentifier("mypage_to_Endlogin", sender: self)
                    
                }))
                // アラートを表示
                self.presentViewController(alert,
                    animated: true,
                    completion: {
                        print("Alert displayed")
                })
            }
        }else {
            //アラートのインスタンスを生成
            let alert = UIAlertController(title: "リザルト", message: "既にloginoutしています。", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)}))
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
        if (segue.identifier == "MyPage_to_CreateOrganization") {
            
        }else if segue.identifier == "MyPage_to_PastPerformance"{
            
        }else if segue.identifier == "MyPage_to_CreateMatch"{
            
        }else if segue.identifier == "mypage_to_Endlogin"{
            
            S_1_Label.text = "試合:"
            sa_1_Label.text = "sum:"
            
            S_2_Label.text = "試合:"
            sa_2_Label.text = "sum:"
            
            
            S_3_Label.text = "試合:"
            sa_3_Label.text = "sum:"
            
            S_4_Label.text = "試合:"
            sa_4_Label.text = "sum:"
            
            S_5_Label.text = "試合:"
            sa_5_Label.text = "sum:"
            
        }
        
    }
    
    @IBAction func returnMenuMyPage_to_OldPlayData(segue:UIStoryboardSegue){
        HTTPAccs()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    @IBAction func returnMenuMyPage_to_OrganizationDetails(segue:UIStoryboardSegue){
        HTTPAccs()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    @IBAction func returnMenuMyPage_to_CreateMatch(segue:UIStoryboardSegue){
        HTTPAccs()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    @IBAction func returnMenuMyPage_to_Allba(segue:UIStoryboardSegue){
        HTTPAccs()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    @IBAction func returnMenuMyPage_to_CreateOrganization(segue:UIStoryboardSegue){
        HTTPAccs()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    @IBAction func returngoMenuEndlogin(segue:UIStoryboardSegue){
        HTTPAccs()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    //Prot
    //@req
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        
        return 5
        
    }
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        if recordlist.isEmpty == false && index<recordlist.count {
            return CGFloat(recordlist[index].sum)
        }else{
            return CGFloat(0)
        }
    }
    func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String{
        if recordlist.isEmpty == false && index<recordlist.count {
            return NSString(string: SampleLabel[index]) as String
        }else{
            return NSString(string: "未開催") as String
        }
        
    }
}

