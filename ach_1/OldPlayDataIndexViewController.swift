//
//  OldPlayDataIndexViewController.swift
//  ach_1
//
//  Created by 早坂彪流 on 2015/07/18.
//  Copyright © 2015年 早坂彪流. All rights reserved.
//

import UIKit

class OldPlayDataIndexViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    private var indicator:MBProgressHUD! = nil
    @IBOutlet weak var tableview: UITableView!
    var OldScoreCardIndex = Array<OldScoreCardIndexData>()
    struct OldScoreCardIndexData {
        var arrows:Int!         //射数
        var sc_id:Int!          // 得点表ID
        var matchName:String!   // 得点表が作成された試合名
        var created:String!     // 得点表が作成された日時
        var sum:Int!            // 得点合計
        var perEnd:Int!
    }
    var selectedCell:Int!
    override func viewDidLoad() {
        super.viewDidLoad()

       HTTPres()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // --tabelViewDatasouce
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        print("cell")
        
        let cell: OldPlayDataIndexTableViewCell = self.tableview.dequeueReusableCellWithIdentifier("OldPlayDataCell",forIndexPath: indexPath) as! OldPlayDataIndexTableViewCell
       
        cell.playname_label.text = OldScoreCardIndex[indexPath.row].matchName
        cell.playcellCreate_when_time_label.text = OldScoreCardIndex[indexPath.row].created
        cell.sum_Label.text = String(OldScoreCardIndex[indexPath.row].sum)
        print(indexPath.row)
        // baTableView.reloadSections(NSIndexSet(index: indexPath.row), withRowAnimation: UITableViewRowAnimation.Automatic)
        //buttonの関連ずけ
        cell.getdetails_button.tag = indexPath.row
         cell.getdetails_button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        cell.getdetails_button.enabled = false
       // cell.getdetails_button.addTarget(self, action: "getdetails_button_event:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        print("count")
        return OldScoreCardIndex.count//arr_of_extractMatchIndex.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = OldScoreCardIndex[indexPath.row]
       
        //アラートのインスタンスを生成
        let alert = UIAlertController(title: "ルーム内容", message: "試合開始日:\(data.created)\n試合名:\(data.matchName)\n射数:\(data.arrows)\n得点表ID:\(data.sc_id)\n射数:\(data.arrows)\nセット数:\(data.perEnd)\n得点合計:\(data.sum)", preferredStyle: UIAlertControllerStyle.Alert)
        //Actionadd
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
            print(action.title)
            self.performSegueWithIdentifier("OldPlayDataIndex_to_cellpoint_is_see", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))

        selectedCell = indexPath.row
        // アラートを表示
        self.presentViewController(alert,
            animated: true,
            completion: {
                print("Alert displayed")
        })

    }
    
    //buttonevents
    func getdetails_button_event(sender:UIButton){
        
    }
    
    

    func HTTPres(){
        if OldScoreCardIndex.count != 0{
            OldScoreCardIndex.removeAll()
        }
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
        let URLStr = "/app/personal/record/"
        let loginRequest = NSMutableURLRequest(URL: NSURL(string:Utility_inputs_limit().URLdataSet+URLStr)!)
        // set the method(HTTP-GET)
        loginRequest.HTTPMethod = "GET"
        //GET 付属情報
        //set requestbody on data(JSON)
        loginRequest.allHTTPHeaderFields = ["cookie":"sessionID="+Utility_inputs_limit().keych_access]
        // use NSURLSession
        let task = NSURLSession.sharedSession().dataTaskWithRequest(loginRequest, completionHandler: { data, response, error in
            if (error == nil) {
                //convert json data to dictionary
                do{
                    let  dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    print(dict);//かくにんよう
                    
                    if dict["status"] as? Int != 0{
                        let OldScoreCardIndexData:NSArray = dict["record"] as! NSArray
                        for var i=0; i < OldScoreCardIndexData.count;i++ {
                            let dicrecorddata:NSDictionary = (OldScoreCardIndexData[i] as? NSDictionary)!
                            let _sc_id = dicrecorddata["sc_id"] as? Int
                            let _matchName = dicrecorddata["matchName"] as? String
                            let _created = dicrecorddata["created"] as? String
                            let _sum = dicrecorddata["sum"] as? Int
                            let _perEnd = dicrecorddata["perEnd"] as? Int
                            let _arrows = dicrecorddata["arrows"] as? Int
                            self.OldScoreCardIndex.append(OldPlayDataIndexViewController.OldScoreCardIndexData(arrows: _arrows, sc_id: _sc_id, matchName: _matchName, created: _created, sum: _sum, perEnd: _perEnd))
                            
                            }
                        }
                } catch{
                    
                }
                
                dispatch_async(q_main, {
                    self.tableview.reloadData()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "OldPlayDataIndex_to_cellpoint_is_see") {
            let nextViewController: cellpointViewControllerSeen = segue.destinationViewController as! cellpointViewControllerSeen
            nextViewController.set_sc_id = OldScoreCardIndex[selectedCell].sc_id
        }
    }
    @IBAction func returnOldPlayDataIndex_to_cellpointviewsee(segue:UIStoryboardSegue){
        
        HTTPres()
        self.setNeedsStatusBarAppearanceUpdate()
    }
}

class OldPlayDataIndexTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playname_label: UILabel!
    @IBOutlet weak var playcellCreate_when_time_label: UILabel!
   
    @IBOutlet weak var sum_Label: UILabel!
    @IBOutlet weak var getdetails_button: UIButton!
    
    
}