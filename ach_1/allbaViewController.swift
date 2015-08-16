//
//  allbaViewController.swift
//  ach_1
//
//  Created by 早坂彪流 on 2015/05/04.
//  Copyright (c) 2015年 早坂彪流. All rights reserved.
//

import UIKit

class allbaViewController: UIViewController,UITableViewDelegate {
    deinit{
        print("killallbaViewController")
    }
    @IBOutlet weak var baTableView: UITableView!
    let URLStr = "/matchIndex"
    private let see = LUKeychainAccess.standardKeychainAccess().stringForKey("sessionID")
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var createGameButton: UIButton!
    private var indicator:MBProgressHUD! = nil
    var alert_selectid:Int = 0
    private var socket:SIOSocket! = nil
    var m_id:[Int]! = []// 試合ID
    var matchName:[String]! = []// 試合名
    var sponsor:[String]! = []// 主催
    var created:[String]! = []// 試合開始日
    var arrows:[Int]! = []// 射数
    var perEnd:[Int]! = []// セット数
    var length:[Int]! = []// 距離
    var players:[Int]! = []// 参加人数 (得点表の数)
    
      var checkOrganization_flag:Bool! = nil
    var arr_of_extractMatchIndexList:Array<data_of_extractMatchIndex>!  //保持class
    override func viewDidLoad() {
        super.viewDidLoad()
       // baTableView.allowsSelection = false
        createGameButton.addTarget(self, action: "creategameevent:", forControlEvents: UIControlEvents.TouchUpInside)
        arr_of_extractMatchIndexList = []
        SIOget()
        
         }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Allba_to_Siirtira") {
            let data = arr_of_extractMatchIndexList[alert_selectid]
            let nextViewController: siitira_ViewController = segue.destinationViewController as! siitira_ViewController
            nextViewController.pleyid = data.m_id
            // self.socket = nil
        }else if (segue.identifier == "allba_to_creatematch") {
            let nextViewController: createMatchviewcontroller = segue.destinationViewController as! createMatchviewcontroller
            nextViewController._checkOrganization_flag = checkOrganization_flag
            checkOrganization_flag = false
            // self.socket = nil
        }
       
    }
    @IBAction func returnMenuforallroom(segue:UIStoryboardSegue){
        SIOget()
    }
//アラートのボタンの関数
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = arr_of_extractMatchIndexList[indexPath.row]
        
        //アラートのインスタンスを生成
        let alert = UIAlertController(title: "ルーム内容", message: "試合開始日:\(data.created)\n試合名:\(data.matchName)\n主催者：\(data.sponsor)\n人数:\(data.players)\n距離:\(data.players)\n射数:\(data.arrows)\nセット数:\(data.perEnd)", preferredStyle: UIAlertControllerStyle.Alert)
        
// AlertControllerにActionを追加
        // 基本的にはActionが追加された順序でボタンが配置される
        //ちなみに Cancelは例外的に一番下に配置される
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
            print(action.title)
            self.performSegueWithIdentifier("Allba_to_Siirtira", sender: self)
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))
        alert_selectid = indexPath.row
        // アラートを表示
        self.presentViewController(alert,
            animated: true,
            completion: {
                print("Alert displayed")
        })
    }
    
    func creategameevent(sender:UIButton){
      
        if (self.see != nil && self.see != "nilf"){
            let emitID = ["sessionID":"sessionID=" + self.see]
            self.socket.emit("checkOrganization", args:[emitID] as [AnyObject])
        }
        self.socket.on("checkOrganization", callback: {(data:[AnyObject]!) in
            let dic = data[0] as! NSDictionary
            self.checkOrganization_flag = dic["belongs"] as! Bool
        })
        self.performSegueWithIdentifier("allba_to_creatematch", sender: self)
    }
    
// --tabelViewDatasouce
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath:NSIndexPath!) -> UITableViewCell! {
        
        print("cell")
        
        let cell: allbaTableCell = self.baTableView.dequeueReusableCellWithIdentifier("allbacell",forIndexPath: indexPath) as! allbaTableCell
        cell.gotonext.enabled = false
        cell.gotonext.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        cell.game_name_label.text = arr_of_extractMatchIndexList[indexPath.row].matchName
        cell.game_master_label.text = arr_of_extractMatchIndexList[indexPath.row].sponsor
        cell.tag = arr_of_extractMatchIndexList[indexPath.row].m_id
        print(indexPath.row)
      
        return cell
    }
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
        print("count")
        return arr_of_extractMatchIndexList.count
    }

    @IBAction func returnAllva_to_cellpointview(segue:UIStoryboardSegue){
       
        SIOgetredata()
    }
    @IBAction func returnAllva_to_Siitira(segue:UIStoryboardSegue){

        SIOgetredata()
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
    func SIOget(){
        m_id.removeAll()
        matchName.removeAll()
        sponsor.removeAll()
        created.removeAll()
        arrows.removeAll()
        perEnd.removeAll()
        length.removeAll()
        players.removeAll()
        SIOSocket.socketWithHost(Utility_inputs_limit().URLdataSet + URLStr, response:  { (_socket: SIOSocket!) in
            self.socket=_socket
            //接続の時に呼ばれる
            self.socket.onConnect = {()in
            
                let see:LUKeychainAccess = LUKeychainAccess.standardKeychainAccess()
                let seeD = see.stringForKey("sessionID")
                print(seeD)
                if (seeD != nil && seeD != "nilf"){
                    let emitID = ["sessionID":"sessionID=" + seeD]
                    // アニメーションを開始する.
                    self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    self.indicator.dimBackground = true
                    self.indicator.labelText = "Loading..."
                    self.indicator.labelColor = UIColor.whiteColor()
                    let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)
                    
                   self.socket.emit("extractMatchIndex", args:[emitID] as [AnyObject])
                    self.socket.on("extractMatchIndex", callback: {(data:[AnyObject]!) in
                        self.arr_of_extractMatchIndexList.removeAll()
                        
                        //値保持の配列とcount変数
                        var i = 0
            if data[0] is NSArray == true{
                
                        let are = data[0] as! NSArray
                        while(i < are.count ){
                            
                            let dic = are[i]as! NSDictionary
                            // print(are)
                            
                            let _extractMatchIndex = data_of_extractMatchIndex(_m_id: dic["m_id"] as! Int, _matchName: dic["matchName"] as! String, _sponsor: dic["sponsor"] as!String, _created: dic["created"] as! String, _arrows: dic["arrows"] as! Int, _perEnd: dic["perEnd"] as! Int, _length: dic["length"] as! Int, _players: dic["players"] as! Int)
                            
                            self.arr_of_extractMatchIndexList?.append(_extractMatchIndex)
                            
                            i++
                        }
                    }
                        self.baTableView.reloadData()
                        timer.invalidate()
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                    })
                    
                }
                
            }
            //再接続の時に呼ばれる
            self.socket.onReconnect = {(attements:Int) in
                
            }
            //切断された時に呼ばれる
            self.socket.onDisconnect = {() in
                print("disconnrcted")
            }
          
            
            self.socket.on("broadcastInsertMatch", callback: {(data:[AnyObject]!) in
                // アニメーションを開始する.
                self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                self.indicator.dimBackground = true
                self.indicator.labelText = "Loading..."
                self.indicator.labelColor = UIColor.whiteColor()
                
                print(data)
                let dic = data[0]as! NSDictionary
               
                
                let _extractMatchIndex = data_of_extractMatchIndex(_m_id: dic["m_id"] as! Int, _matchName: dic["matchName"] as! String, _sponsor: dic["sponsor"] as!String, _created: dic["created"] as! String, _arrows: dic["arrows"] as! Int, _perEnd: dic["perEnd"] as! Int, _length: dic["length"] as! Int, _players: dic["players"] as! Int)
                
                self.arr_of_extractMatchIndexList?.append(_extractMatchIndex)
           
                
                self.baTableView.reloadData()
               
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            })
            self.socket.on("broadcastCloseMatch", callback: {(data:[AnyObject]!) in
                //試合終了メソッドを書く
                let dic:NSDictionary = (data[0] as? NSDictionary)!
                let s_ID:Int = (dic["m_id"] as? Int)!
                let ID = Int(s_ID)
                for var i = 0;i<self.arr_of_extractMatchIndexList.count;i++ {
                    if self.arr_of_extractMatchIndexList[i].m_id == ID{
                        self.arr_of_extractMatchIndexList.removeAtIndex(i)
                        break
                    }
                }
                 self.baTableView.reloadData()
                
            })

        })
    }
    func SIOgetredata(){
        let see:LUKeychainAccess = LUKeychainAccess.standardKeychainAccess()
        let seeD = see.stringForKey("sessionID")
        print(seeD)
        if (seeD != nil && seeD != "nilf"){
            let emitID = ["sessionID":"sessionID=" + seeD]
            // アニメーションを開始する.
            self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.indicator.dimBackground = true
            self.indicator.labelText = "Loading..."
            self.indicator.labelColor = UIColor.whiteColor()
            let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)
            
            self.socket.emit("extractMatchIndex", args:[emitID] as [AnyObject])
            self.socket.on("extractMatchIndex", callback: {(data:[AnyObject]!) in
                self.arr_of_extractMatchIndexList.removeAll()
                
                //値保持の配列とcount変数
                var i = 0
                if data[0] is NSArray == true{
                    
                    let are = data[0] as! NSArray
                    while(i < are.count ){
                        
                        let dic = are[i]as! NSDictionary
                      
                        
                        let _extractMatchIndex = data_of_extractMatchIndex(_m_id: dic["m_id"] as! Int, _matchName: dic["matchName"] as! String, _sponsor: dic["sponsor"] as!String, _created: dic["created"] as! String, _arrows: dic["arrows"] as! Int, _perEnd: dic["perEnd"] as! Int, _length: dic["length"] as! Int, _players: dic["players"] as! Int)
                        
                        self.arr_of_extractMatchIndexList?.append(_extractMatchIndex)
                      
                        i++
                    }
                }
                self.baTableView.reloadData()
                timer.invalidate()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
            })
            self.socket.on("broadcastCloseMatch", callback: {(data:[AnyObject]!) in
                //試合終了メソッドを書く
                let dic:NSDictionary = (data[0] as? NSDictionary)!
                let s_ID:Int = (dic["m_id"] as? Int)!
                let ID = Int(s_ID)
                for var i = 0;i<self.arr_of_extractMatchIndexList.count;i++ {
                    if self.arr_of_extractMatchIndexList[i].m_id == ID{
                        self.arr_of_extractMatchIndexList.removeAtIndex(i)
                        break
                    }
                }
                self.baTableView.reloadData()
            })

        }

    }
    
    
    

}