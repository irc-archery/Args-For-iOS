//
//  mypage_ViewController.swift
//  ach_1
//
//  Created by 早坂彪流 on 2015/05/03.
//  Copyright (c) 2015年 早坂彪流. All rights reserved.
//

import UIKit

class siitira_ViewController: UIViewController,UITableViewDelegate {
    deinit{
        print("killsiitira_ViewController")
    }
    struct siitira{
        var sc_id:Int!//得点表ID
        var playerName:String!//選手名
        var scoreTotal:Int!//得点合計
        var perEnd:Int!
    }
    let URLStr = "/scoreCardIndex"
    @IBOutlet weak var toktableview: UITableView!
    private let see = LUKeychainAccess.standardKeychainAccess().stringForKey("sessionID")
    @IBOutlet weak var createscorebord: UIButton!
    
    @IBOutlet weak var closeMatch_button: UIButton!
    private var socket:SIOSocket! = nil
    private var indicator:MBProgressHUD! = nil
    var siitiraArray:Array<siitira>! = []
    var countcell : Int = 0
    var pleyid:Int!
    var intocount:Bool!=true
    private var checkPermission_data:Bool!//編集モード、閲覧モードのチェックの得点表にデータを渡すための
    private var SendSC_ID:Int = 0//SCID送るための変数


    func SIOsc(){
        self.siitiraArray.removeAll()
        SIOSocket.socketWithHost(Utility_inputs_limit().URLdataSet + URLStr, response:  { (_socket: SIOSocket!) in
            self.socket=_socket
            //接続の時に呼ばれる
            self.socket.onConnect = {()in
                if self.pleyid != nil{
                    // アニメーションを開始する.
                    self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    self.indicator.dimBackground = true
                    self.indicator.labelText = "Loading..."
                    self.indicator.labelColor = UIColor.whiteColor()
                     let timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "UpdateofT:", userInfo: nil, repeats: true)
                    let idjs:NSDictionary = ["m_id":self.pleyid!,"sessionID":"sessionID="+Utility_inputs_limit().keych_access]
                    self.socket.emit("joinMatch", args:[idjs] as [AnyObject])
                    
                    self.socket.on("extractScoreCardIndex", callback: {(data:[AnyObject]!) in
                        
                        var i = 0 //値保持の配列のためのcount変数
                        print(data)
                        
                        
                        if data[0] is NSArray == true{
                            
                            let are:NSArray = data[0] as! NSArray
                            while(i < are.count ){
                                
                                let dic = are[i] as! NSDictionary
                                
                                let id = dic["sc_id"] as! Int
                                let playerName = dic["playerName"] as! String
                                
                                let total = dic["total"] as! Int
                                let perEnd = dic["perEnd"] as! Int
                                
                                var getflag = false
                                for var i = 0;i<self.siitiraArray.count;i++ {
                                    if self.siitiraArray[i].sc_id == id{
                                        getflag = true
                                    }
                                }
                                if getflag == false{
                                self.siitiraArray.append(siitira_ViewController.siitira(sc_id: id, playerName: playerName, scoreTotal: total, perEnd: perEnd))
                                }
                                
                                i++
                                
                            }
                            self.countcell = i
                            
                            self.toktableview.reloadData()
                            timer.invalidate()
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                        }
                        
                    })
                    print("The first SocketCall!")
                    
                    let sec = Utility_inputs_limit().keych_access
                    let id:NSDictionary = ["m_id":self.pleyid,"sessionID":"sessionID=" + sec]
                    self.socket.emit("checkMatchCreater", args:[id] as [AnyObject])
                    self.socket.on("checkMatchCreater") { (data:[AnyObject]!) in
                        let dic:NSDictionary = data[0] as! NSDictionary
                        let pra = dic["permission"] as! Bool
                        self.checkPermission_data = pra
                        if self.checkPermission_data == false{
                            self.closeMatch_button.hidden = true
                        }
                        timer.invalidate()
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                    }
                }
                
                
            }
            //再接続の時に呼ばれる
            self.socket.onReconnect = {(attements:Int) in
                
            }
            //切断された時に呼ばれる
            self.socket.onDisconnect = {() in
                print("disconnrcted")
            }
            //通常受信
            /*  self.socket.on("receive", callback: {(data:[AnyObject]!) in
            
            })*/
            
            
            self.socket.on("broadcastInsertScoreCard", callback: {(data:[AnyObject]!) in
                // アニメーションを開始する.
                self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                self.indicator.dimBackground = true
                self.indicator.labelText = "Loading..."
                self.indicator.labelColor = UIColor.whiteColor()
              
                print(data[0])
                if  data[0] is NSDictionary == false{
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    
                    let alert = UIAlertController(title: "メッセージ", message: "broadcastInsertScoreCardNSNULL", preferredStyle: UIAlertControllerStyle.Alert)
                    //Actionadd
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
                        print(action.title)
                        
                    }))

                    return }
        
                let dic = data[0] as! NSDictionary
                
                let id:Int = dic["sc_id"] as! Int
                let playerName:String = dic["playerName"] as! String
                let totalae:Int = dic["total"] as! Int
                let perEnd = dic["perEnd"] as! Int
                
                                var che = false
                                for var i = 0;i<self.siitiraArray.count;i++ {
                                    if self.siitiraArray[i].sc_id == id{
                                        che = true
                                    }
                            }
                
                if che == false{
                self.siitiraArray.append(siitira_ViewController.siitira(sc_id: id, playerName: playerName, scoreTotal: totalae, perEnd: perEnd))
                 }
                self.toktableview.reloadData()
                
                
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
            })
            self.socket.on("broadcastInsertScore", callback: {(data:[AnyObject]!) in
                // アニメーションを開始する.
                self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                self.indicator.dimBackground = true
                self.indicator.labelText = "Loading..."
                self.indicator.labelColor = UIColor.whiteColor()
               
                print(data[0])
               
                if data[0] is NSDictionary == false {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    let alert = UIAlertController(title: "メッセージ", message: "broadcastInsertScoreNSNULL", preferredStyle: UIAlertControllerStyle.Alert)
                    //Actionadd
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
                        print(action.title)
                        
                    }))
                    return
                }
                let dic = data[0] as! NSDictionary
                
                let id:Int = dic["sc_id"] as! Int
                let totalae:Int = dic["total"] as! Int
                let perEnd = dic["perEnd"] as! Int
                
                if self.siitiraArray.isEmpty == false{
                    for var i = 0;i<self.siitiraArray.count;i++ {
                        if self.siitiraArray[i].sc_id == id{
                            
                            self.siitiraArray[i].sc_id = id
                            self.siitiraArray[i].scoreTotal = totalae
                            self.siitiraArray[i].perEnd = perEnd
                        }
                    }
                }
                
                self.toktableview.reloadData()
                
                
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
            })
            self.socket.on("broadcastUpdateScore", callback: {(data:[AnyObject]!) in
                // アニメーションを開始する.
                self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                self.indicator.dimBackground = true
                self.indicator.labelText = "Loading..."
                self.indicator.labelColor = UIColor.whiteColor()
                
                print(data[0])
            
                if data[0] is NSDictionary == true{
                let dic = data[0] as! NSDictionary
                
                let id:Int = dic["sc_id"] as! Int
                let totalae:Int = dic["total"] as! Int
                    
                if self.siitiraArray.isEmpty == false{
                    for var i = 0;i<self.siitiraArray.count;i++ {
                        if self.siitiraArray[i].sc_id == id{
                            
                            self.siitiraArray[i].sc_id = id
                            self.siitiraArray[i].scoreTotal = totalae
                            
                        }
                    }
                    MBProgressHUD.hideHUDForView(self.view, animated: true)

                }
                
                self.toktableview.reloadData()
                }else{
                    let alert = UIAlertController(title: "メッセージ", message: "broadcastUpdateScoreNSNULL", preferredStyle: UIAlertControllerStyle.Alert)
                    //Actionadd
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
                        print(action.title)
                        
                    }))
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    return
                }
                
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
            })
            self.socket.on("broadcastCloseMatch", callback: {(data:[AnyObject]!) in
                //試合終了メソッドを書く
                let dic:NSDictionary = (data[0] as? NSDictionary)!
                let alert = UIAlertController(title: "メッセージ", message: "試合は終了しました。試合一覧画面に移ります", preferredStyle: UIAlertControllerStyle.Alert)
                //Actionadd
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
                    print(action.title)
                    self.performSegueWithIdentifier("UnretunrAll_to_Sii", sender: self)
                }))
                
                // アラートを表示
                self.presentViewController(alert,
                    animated: true,
                    completion: {
                        print("Alert displayed")
                })
                
            })
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //toktableview.allowsSelection = false
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.m_id != nil{
            
        }
        SIOsc()
        self.createscorebord.addTarget(self, action: "createscorebordEvent:", forControlEvents: UIControlEvents.TouchUpInside)
        self.closeMatch_button.addTarget(self, action: "closeMatch_buttonEvent:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //出現後に起動するアレ
    override func viewDidAppear(animated: Bool) {
        
    }
    // --tabelViewDatasouce
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath:NSIndexPath!) -> UITableViewCell! {
        print("cell")
        
        let cell: mypage_table_cell = self.toktableview.dequeueReusableCellWithIdentifier("tokcell",forIndexPath: indexPath) as! mypage_table_cell
        cell.gotoScore_sheet_button.enabled = false
        cell.gotoScore_sheet_button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        
        cell.gotoScore_sheet_button.tag = indexPath.row
        if self.siitiraArray.isEmpty == false{
            //cell.gotoScore_sheet_button.addTarget(self, action: "gettargetCard:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.playername_label.text = String(siitiraArray[indexPath.row].playerName)
            cell.set_label.text = String(siitiraArray[indexPath.row].perEnd)
            cell.playpoint_lable.text = String(siitiraArray[indexPath.row].scoreTotal)
        }
        return cell
    }
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
        print("count")
        if self.siitiraArray.isEmpty == true{
            return 0
        }
        return self.siitiraArray.count
    }
    //    タイマーのあれ
    func onUpdate(timer : NSTimer){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        timer.invalidate()
        //アラートのインスタンスを生成
        let alert = UIAlertController(title: "エラー", message: "レスポンスが帰ってきませんでした電波状態が悪い可能性が有ります再度アプリを再起動してください。", preferredStyle: UIAlertControllerStyle.Alert)
        
        // AlertControllerにActionを追加
        // 基本的にはActionが追加された順序でボタンが配置される
        //ちなみに Cancelは例外的に一番下に配置される
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
            print(action.title)
        }))
        
        // アラートを表示
        self.presentViewController(alert,
            animated: true,
            completion: {
                print("Alert displayed")
        })
    }
    func UpdateofT(timer : NSTimer){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        timer.invalidate()
        //アラートのインスタンスを生成
        let alert = UIAlertController(title: "エラー", message: "レスポンスが帰ってきませんでした電波状態が悪い可能性が有ります再度アプリを再起動してください。", preferredStyle: UIAlertControllerStyle.Alert)
        
        // AlertControllerにActionを追加
        // 基本的にはActionが追加された順序でボタンが配置される
        //ちなみに Cancelは例外的に一番下に配置される
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
            print(action.title)
        }))
        
        // アラートを表示
        self.presentViewController(alert,
            animated: true,
            completion: {
                print("Alert displayed")
        })
    }
    //アラートのボタンの関数
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // アニメーションを開始する.
        self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.indicator.dimBackground = true
        self.indicator.labelText = "Loading..."
        self.indicator.labelColor = UIColor.whiteColor()
        let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)
        let q_main: dispatch_queue_t  = dispatch_get_main_queue();
        let sec = Utility_inputs_limit().keych_access
        let fir = self.siitiraArray[indexPath.row].sc_id
        
        intocount = false
        let idjs:NSDictionary = ["sc_id":fir,"sessionID":"sessionID=" + sec]
     
        self.socket.emit("checkPermission", args:[idjs] as [AnyObject])
        self.socket.on("checkPermission") { (data:[AnyObject]!) in
            
            let dic:NSDictionary = data[0] as! NSDictionary
            let pra = dic["permission"] as! Bool
            self.checkPermission_data = pra
            self.SendSC_ID = Int(self.siitiraArray[indexPath.row].sc_id)
            dispatch_async(q_main, {
                self.toktableview.deselectRowAtIndexPath(indexPath, animated: true)
                timer.invalidate()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.performSegueWithIdentifier("siitira_to_cellpoint", sender: self)
                
            })
            
        }
    }
    // AlertControllerにActionを追加（まだ使ってない）
    func addActionsToAlertController(controller: UIAlertController) {
        // 基本的にはActionが追加された順序でボタンが配置される
        //ちなみに Cancelは例外的に一番下に配置される
        controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
            print(action.title)
            self.performSegueWithIdentifier("Allba_to_Siirtira", sender: self)
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)
            
        }))
    }
    
    //unwind
    @IBAction func returnsiitira_to_Cellpoint(segue:UIStoryboardSegue){
      
        SIOsc()
        
        intocount=true
    }
    @IBAction func returnsiitira_to_CreateScoreCard(segue:UIStoryboardSegue){
     
        SIOsc()
        
    }
    //値渡しのためのovarride
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "siitira_to_createscore"{
            let nextViewController: createscoreCardViewController = segue.destinationViewController as! createscoreCardViewController
            nextViewController.m_id = pleyid
             socket.close()
          
        }else if segue.identifier == "siitira_to_cellpoint"{
            let nextViewController: cellpointViewController = segue.destinationViewController as! cellpointViewController
            nextViewController.MycheckPermission_data = checkPermission_data
            nextViewController.set_sc_id = self.SendSC_ID
            nextViewController.get_mid = pleyid
             socket.close()
         
        }
    }
    
    //buttonEvent
    func createscorebordEvent(sender:UIButton!){
        
        self.performSegueWithIdentifier("siitira_to_createscore", sender: self)
        //scoreindex_to_createscore
        //scoreindex_to_login
    }
    //試合削除
    func closeMatch_buttonEvent(sender:UIButton){
        
        let sec = Utility_inputs_limit().keych_access
        let idjs:NSDictionary = ["m_id":pleyid,"sessionID":"sessionID=" + sec]
        self.socket.emit("closeMatch", args:[idjs] as [AnyObject])
        //その後どこかに遷移
    }
    func gettargetCard(sender:UIButton){
        toktableview.allowsSelection = false
        let q_main: dispatch_queue_t  = dispatch_get_main_queue();
        let sec = Utility_inputs_limit().keych_access
        let fir = self.siitiraArray[sender.tag].sc_id
        
        let idjs:NSDictionary = ["sc_id":fir,"sessionID":"sessionID=" + sec]
        self.socket.emit("checkPermission", args:[idjs] as [AnyObject])
        self.socket.on("checkPermission") { (data:[AnyObject]!) in
            let dic:NSDictionary = data[0] as! NSDictionary
            let pra = dic["permission"] as! Bool
            self.checkPermission_data = pra
            self.SendSC_ID = Int(self.siitiraArray[sender.tag].sc_id)
            
            dispatch_async(q_main, {
                self.performSegueWithIdentifier("siitira_to_cellpoint", sender: self)
            })
        }
    }
}