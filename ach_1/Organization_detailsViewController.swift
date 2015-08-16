//
//  Organization_detailsViewController.swift
//  ach_1
//
//  Created by 早坂彪流 on 2015/07/20.
//  Copyright © 2015年 早坂彪流. All rights reserved.
//

import UIKit

class Organization_detailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

  
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var OrganizatonName_Label: UILabel!//ユーザーが所属している団体名
    @IBOutlet weak var Create_for_days_Organizaton_Label: UILabel!//団体設立日
    @IBOutlet weak var OrganizationMen_values_Label: UILabel!//メンバー数
    @IBOutlet weak var OrganizationRootName_Label: UILabel!//責任者名
    @IBOutlet weak var OrganizationField_Label: UILabel!//活動場所
    @IBOutlet weak var OrganizaitonEmail_Label: UILabel!//連絡用のメール
    @IBOutlet weak var GotoOrganizationMa_button: UIButton!
    
    /*MyVariables*/
    var OrganizationName:String!//ユーザーが所属している団体名
    var Establish:String!//団体設立日
    var Membars:Int!//メンバー数
    var admin:String!//責任者名
    var place:String!//活動場所
    var email:String!//連絡用のメール
    var status:Int!// ユーザが団体に所属しているか 1: 所属している, 0: 所属していない
    
     private var indicator:MBProgressHUD! = nil
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

        self.tableview.allowsSelection = false
        self.GotoOrganizationMa_button.addTarget(self, action: "GotoOrganizationMa_buttonEvent:", forControlEvents: UIControlEvents.TouchUpInside)
        HttpRes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// --tabelViewDatasouce
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        print("cell")
        
        let cell: OrganizationDetaillsTableViewCell = self.tableview.dequeueReusableCellWithIdentifier("OrganizationDetaillsCell",forIndexPath: indexPath) as! OrganizationDetaillsTableViewCell
        
        cell.PlayName_Label.text = String(self.memberList[indexPath.row].playerName)
        cell.Birth_Label.text = String(self.memberList[indexPath.row].birth)
        cell.EmailLLabel.text = String(self.memberList[indexPath.row].email)
       
        print(indexPath.row)
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        print("count")
        return memberList.count
    }

//buttonEvent
    func GotoOrganizationMa_buttonEvent(sender:UIButton!){
        self.performSegueWithIdentifier("Organization_details_to_Organization_management", sender: self)
    }
//値渡しする為のovarride
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Organization_details_to_Organization_management") {
            
        }
    }
//http
    func HttpRes(){
        if memberList.count != 0{
            memberList.removeAll()
        }
        //スレッドの設定((UIKitのための
        let q_main: dispatch_queue_t  = dispatch_get_main_queue();
                // アニメーションを開始する.
        self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.indicator.dimBackground = true
        self.indicator.labelText = "Loading..."
        self.indicator.labelColor = UIColor.whiteColor()
        
        //Request
        let URLStr = "/app/organization"
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
                    self.OrganizationName = dict["organizationName"] as? String
                    self.Establish = dict["establish"] as? String
                    self.email = dict["email"] as? String
                    self.admin = dict["admin"] as? String
                    self.Membars = dict["members"] as? Int
                    self.place = dict["place"] as? String
                    self.status = dict["status"] as? Int
                    let arrMembar:NSArray = (dict["memberList"] as? NSArray)!
                    for var j = 0;j<arrMembar.count;j++ {
                        let i = arrMembar[j] as! NSDictionary
                        let oj:memberListData! = memberListData(p_id: Int((i["p_id"] as? NSNumber)!), playerName: (i["playerName"] as? String)!, birth: ( i["birth"] as? String)!, email: (i["email"] as? String)!)
                        self.memberList.append(oj)
                    }
                    dispatch_async(q_main, {
                        self.OrganizatonName_Label.text = self.OrganizationName
                        self.Create_for_days_Organizaton_Label.text = self.Establish
                        self.OrganizationMen_values_Label.text = String(self.Membars)
                        self.OrganizationRootName_Label.text = self.admin
                        self.OrganizationField_Label.text = self.place
                        self.OrganizaitonEmail_Label.text = self.email
                        self.tableview.reloadData()
                    })
                } catch{
                    
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
    @IBAction func returnMenuOrganization_details_to_Organization_management(segue:UIStoryboardSegue){
        HttpRes()
        self.setNeedsStatusBarAppearanceUpdate()
    }
}

class OrganizationDetaillsTableViewCell: UITableViewCell {
    @IBOutlet weak var PlayName_Label: UILabel!
    @IBOutlet weak var Birth_Label: UILabel!
    @IBOutlet weak var EmailLLabel: UILabel!
    
}
