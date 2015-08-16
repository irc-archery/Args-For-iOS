//
//  Organization_managementViewController.swift
//  ach_1
//
//  Created by 早坂彪流 on 2015/07/20.
//  Copyright © 2015年 早坂彪流. All rights reserved.
//

import UIKit

class Organization_managementViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //Organization_managementCell
    @IBOutlet weak var OrganizationName_Label: UILabel!
    @IBOutlet weak var OrganizationMembers_Label: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var GotomemberAdd_button: UIButton!
    
    
    private var indicator:MBProgressHUD! = nil
    var organizationName:String!// ユーザーが所属している団体名
    var members:Int!// メンバー数
    // メンバーデータの一覧
    var memberList:Array<memberListData!> = Array<memberListData!>()
    struct memberListData {
        var p_id:Int// 選手ID(非表示、削除時に使用)
        var playerName:String// 選手名
        var birth:String// 生年月日
        var email:String// E-mail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.tableview.allowsSelection = false
        self.GotomemberAdd_button.addTarget(self, action: "GotomemberAdd_buttonEvent:", forControlEvents: UIControlEvents.TouchUpInside)
        HttpRes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
// --tabelViewDatasouce
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        print("cell")
        
        let cell: Organization_managementTableViewCell = self.tableview.dequeueReusableCellWithIdentifier("Organization_managementCell",forIndexPath: indexPath) as! Organization_managementTableViewCell
        
        cell.PlayName_Label.text = String(self.memberList[indexPath.row].playerName)
        cell.CreatePlaytime_Label.text = String(self.memberList[indexPath.row].birth)
        cell.Sum_Label.text = String(self.memberList[indexPath.row].email)
        // let em_data = arr_of_extractMatchIndex[indexPath.row]
        //  cell.input_of_extractMatchIndex(em_data, indexPath_row: indexPath.row)
        print(indexPath.row)
        // baTableView.reloadSections(NSIndexSet(index: indexPath.row), withRowAnimation: UITableViewRowAnimation.Automatic)
        //buttonの関連ずけ
        //cell.gotonext.addTarget(self, action: "getdetails_button_event:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        print("count")
        return memberList.count
    }
    //アラートのボタンの関数
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        let data = memberList[indexPath.row]
        
        //アラートのインスタンスを生成
        let alert = UIAlertController(title: "確認", message: "\(memberList[indexPath.row].playerName)をメンバーから削除しますか？", preferredStyle: UIAlertControllerStyle.Alert)
        
        // AlertControllerにActionを追加
        // 基本的にはActionが追加された順序でボタンが配置される
        //ちなみに Cancelは例外的に一番下に配置される
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: {action in
            print(action.title)
            let URLStr = "/app/organization/members/"
            let HTTPRequest = NSMutableURLRequest(URL: NSURL(string:Utility_inputs_limit().URLdataSet+URLStr+String(self.memberList[indexPath.row].p_id))!)
            HTTPRequest.HTTPMethod = "DELETE"
            let deleteRequest = ["sessionID":"sessionID="+Utility_inputs_limit().keych_access]
            do {
                if NSJSONSerialization.isValidJSONObject(deleteRequest){
                    let js_deleteRequest = try NSJSONSerialization.dataWithJSONObject(deleteRequest, options: NSJSONWritingOptions.PrettyPrinted)
                    //bodyにいれる。
                    HTTPRequest.allHTTPHeaderFields = deleteRequest
                }
            }catch{
                
            }
            print(HTTPRequest)
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
                        
                        self.memberList.removeAtIndex(indexPath.row)
                         tableView.deselectRowAtIndexPath(indexPath, animated: false)
                            tableView.reloadData()
                        }else{
                        let errStr:String = json["err"] as! String
                        //login出来ない時の処理
                        let alert = UIAlertController(title: "エラー", message: errStr, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)
                             tableView.deselectRowAtIndexPath(indexPath, animated: false)
                        }))
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
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:{ action in print(action.title)
                         tableView.deselectRowAtIndexPath(indexPath, animated: false)
                    }))
                    // アラートを表示
                    self.presentViewController(alert,
                        animated: true,
                        completion: {
                            print("Alert displayed")
                    })
                }
            })
            task.resume()

            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }))
      
        // アラートを表示
        self.presentViewController(alert,
            animated: true,
            completion: {
                print("Alert displayed")
        })
    }
//値渡しする為のovarride
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
//buttonEvent
    func GotomemberAdd_buttonEvent(sender:UIBarButtonItem){
        self.performSegueWithIdentifier("Organization_management_to_AddtionMembar", sender: self)
    }
    func HttpRes(){
        if memberList.count != 0{
            memberList.removeAll()
        }
        // アニメーションを開始する.
        self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.indicator.dimBackground = true
        self.indicator.labelText = "Loading..."
        self.indicator.labelColor = UIColor.whiteColor()
        //スレッドの設定((UIKitのための
       
        let q_main: dispatch_queue_t  = dispatch_get_main_queue();
       
        //Request
        let URLStr = "/app/organization/members/"
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
                    self.organizationName = dict["organizationName"] as? String
                    self.members = dict["members"] as? Int
                    let arrMembar:NSArray = (dict["memberList"] as? NSArray)!
                    for var j = 0;j<arrMembar.count;j++ {
                        let i = arrMembar[j] as! NSDictionary
                        let oj:memberListData! = memberListData(p_id: Int((i["p_id"] as? NSNumber)!), playerName: (i["playerName"] as? String)!, birth: ( i["birth"] as? String)!, email: (i["email"] as? String)!)
                        self.memberList.append(oj)
                    }
                    dispatch_async(q_main, {
                        self.OrganizationName_Label.text = self.organizationName
                        self.OrganizationMembers_Label.text = String(self.members)
                        self.tableview.reloadData()
                    })
                } catch{
                    //login出来ない時の処理
                    let alert = UIAlertController(title: "エラー", message: "メンバーは存在しません。", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)}))
                    // アラートを表示
                    self.presentViewController(alert,
                        animated: true,
                        completion: {
                            print("Alert displayed")
                    })
                    
                }
                
                dispatch_async(q_main, {
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
    @IBAction func returnOrganization_management_to_AddtionMembar(segue:UIStoryboardSegue){
        HttpRes()
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
//cellclass
class Organization_managementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var PlayName_Label: UILabel!
    
    @IBOutlet weak var CreatePlaytime_Label: UILabel!
    
    @IBOutlet weak var Sum_Label: UILabel!
    
}