//
//  ViewController.swift
//  cell9
//
//  Created by 早坂彪流 on 2015/06/02.
//  Copyright (c) 2015年 早坂彪流. All rights reserved.
//

import UIKit
//returnOldPlayDataIndex_to_cellpointviewseeUnwindで
class cellpointViewControllerSeen: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBAction func uptapevent(sender: AnyObject) {
        self.view.endEditing(true)
    }
    var sc_id:Int!// 得点表ID
    var p_id:Int! // 選手ID((????)
    var playerName:String!// 選手名
    var organizationName:String!//団体名
    var matchName:String!//試合名
    var created:String!//試合日
    var number:String!//ゼッケン番号
    var prefectures:String!//都道府県
    var length:Int!// 距離
    var lengthStr:String!// 距離Str
    var countPerEnd:Int!// 現在のセット (テーブルに格納されているカラムの数)
    var ten:Int!// 10数
    var x:Int!// X数
    var sum:Int!// 合計
    
    var permission:Bool!
    struct oldscore {
        var score_1:String!
        var score_2:String!
        var score_3:String!
        var score_4:String!
        var score_5:String!
        var score_6:String!
        var updatedScore_1:String!
        var updatedScore_2:String!
        var updatedScore_3:String!
        var updatedScore_4:String!
        var updatedScore_5:String!
        var updatedScore_6:String!
        var subTotal :Int!
        var perEnd:Int!
    }
    var score : Array<oldscore>! = Array<oldscore>()
    let MyNotification_eventkey = "addbutton_action"//通知のイベントKey
    let URLStr = "/app/personal/record/"
    private var socket:SIOSocket! = nil
    private let see = Utility_inputs_limit().keych_access
     var set_sc_id:Int!//値渡しされるとこ
    
    
    @IBOutlet weak var delscorecard: UIButton!
    @IBOutlet weak var PlayMatchName_textfield: UITextField!
    @IBOutlet weak var year_mouth_day_textfield: UITextField!
    @IBOutlet weak var Saddlecloth_textfield: UITextField!
    @IBOutlet weak var playername_textfield: UITextField!
    @IBOutlet weak var Orgnaization_textfield: UITextField!
    @IBOutlet weak var prefectures_textfield: UITextField!
   
    @IBOutlet weak var firstcount_Label: UILabel!

    @IBOutlet weak var secondcount_Lable: UILabel!
    
    @IBOutlet weak var thirdcount_Label: UILabel!
    @IBOutlet weak var foruthcount_Label: UILabel!
    @IBOutlet weak var fifthcount_Label: UILabel!
    @IBOutlet weak var sixthcount_Label: UILabel!
    @IBOutlet weak var sumcount_Label: UILabel!
    
    @IBOutlet weak var tencount_Lable: UILabel!
    @IBOutlet weak var Xcount_Lable: UILabel!
    
    @IBOutlet weak var playersign_textfield: UITextField!
    @IBOutlet weak var recordersign_textfield: UITextField!
   
    
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var first_la_view: UIView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var contentview: UIView!
    @IBOutlet weak var ingrefientsTable_layout: NSLayoutConstraint!
    @IBOutlet weak var Layout_ScrollView: NSLayoutConstraint!
    @IBOutlet weak var contentView_Layout: NSLayoutConstraint!
    @IBOutlet weak var Scroll_Layout: NSLayoutConstraint!
    private var indicator:MBProgressHUD! = nil
    var cellcount = 0//ボタンのカウンタ変数
    var viewsize:CGRect!
    var first_tablesize:CGRect!
    var first_contentView:CGRect!
    var notcellcount = 0
    var sizeout = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlayMatchName_textfield.enabled = false
        year_mouth_day_textfield.enabled = false
        Saddlecloth_textfield.enabled = false
        playername_textfield.enabled = false
        Orgnaization_textfield.enabled = false
        prefectures_textfield.enabled = false
        playersign_textfield.enabled = false
        recordersign_textfield.enabled = false
        self.delscorecard.addTarget(self, action: "delscorecardEvent:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // アニメーションを開始する.
        self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.indicator.dimBackground = true
        self.indicator.labelText = "Loading..."
        self.indicator.labelColor = UIColor.whiteColor()
        
      
        let q_main: dispatch_queue_t  = dispatch_get_main_queue();
      
        //Request
        let URLStr = "/app/personal/record/"
        let Request = NSMutableURLRequest(URL: NSURL(string:Utility_inputs_limit().URLdataSet+URLStr+String(set_sc_id))!)
        // set the method(HTTP-GET)
        Request.HTTPMethod = "GET"
        //GET 付属情報
        //set requestbody on data(JSON)
        Request.allHTTPHeaderFields = ["cookie":"sessionID="+Utility_inputs_limit().keych_access]
        // use NSURLSession
        let task = NSURLSession.sharedSession().dataTaskWithRequest(Request, completionHandler: { data, response, error in
            if (error == nil) {
                //convert json data to dictionary
                do{
                    let  dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    print(dict);//かくにんよう
                    self.sc_id = dict["sc_id"] as? Int
                    self.p_id = dict["p_id"] as? Int
                    self.created = dict["created"] as? String
                    self.playerName = dict["playerName"] as? String
                    self.matchName  = dict["matchName"] as? String
                    self.length = dict["length"] as? Int
                    self.prefectures = dict["prefectures"] as? String
                    self.organizationName = dict["organizationName"] as? String
                    self.countPerEnd = dict["countPerEnd"] as? Int
                    self.number = dict["number"] as? String
                    self.ten = dict["ten"] as? Int
                    self.x = dict["x"] as? Int
                    self.sum = dict["sum"] as? Int
                    let scoredata:NSArray = (dict["score"] as? NSArray)!
                    
                    switch self.length{
                    case 0 :
                        self.lengthStr = "90m"
                    case 1 :
                        self.lengthStr = "70m"
                    case 2 :
                        self.lengthStr = "60m"
                    case 3 :
                        self.lengthStr = "50m"
                    case 4 :
                        self.lengthStr = "40m"
                    case 5 :
                        self.lengthStr = "30m"
                    case 6 :
                        self.lengthStr = "70m前"
                    case 7 :
                        self.lengthStr = "70m後"
                    default:
                        break
                    }

                    for var i=0; i < scoredata.count;i++ {
                        let dicrecorddata:NSDictionary = scoredata[i] as! NSDictionary
                        let score_1 = dicrecorddata["score_1"] as? String
                        let score_2 = dicrecorddata["score_2"] as? String
                        let score_3 = dicrecorddata["score_3"] as? String
                        let score_4 = dicrecorddata["score_4"] as? String
                        let score_5 = dicrecorddata["score_5"] as? String
                        let score_6 = dicrecorddata["score_6"] as? String
                        
                        
                        var updatedScore_1:String! = ""
                        var updatedScore_2:String! = ""
                        var updatedScore_3:String! = ""
                        var updatedScore_4:String! = ""
                        var updatedScore_5:String! = ""
                        var updatedScore_6:String! = ""
                        if dicrecorddata["updatedScore_1"] as? String != nil{
                            updatedScore_1 = dicrecorddata["updatedScore_1"] as? String
                        }
                        if dicrecorddata["updatedScore_2"] as? String != nil{
                            updatedScore_2 = dicrecorddata["updatedScore_2"] as? String
                        }
                        if dicrecorddata["updatedScore_3"] as? String != nil{
                            updatedScore_3 = dicrecorddata["updatedScore_3"] as? String
                        }
                        if dicrecorddata["updatedScore_4"] as? String != nil{
                            updatedScore_4 = dicrecorddata["updatedScore_4"] as? String
                        }
                        if dicrecorddata["updatedScore_5"] as? String != nil{
                            updatedScore_5 = dicrecorddata["updatedScore_5"] as? String
                        }
                        if dicrecorddata["updatedScore_6"] as? String != nil{
                            updatedScore_6 = dicrecorddata["updatedScore_6"] as? String
                        }
                        
                        let subTotal = dicrecorddata["subTotal"] as? Int
                        let perEnd = dicrecorddata["perEnd"] as? Int
                       
                        let adddata = oldscore(score_1: score_1, score_2: score_2, score_3: score_3, score_4: score_4, score_5: score_5, score_6: score_6, updatedScore_1: updatedScore_1, updatedScore_2: updatedScore_2, updatedScore_3: updatedScore_3, updatedScore_4: updatedScore_4, updatedScore_5: updatedScore_5, updatedScore_6: updatedScore_6, subTotal: subTotal, perEnd: perEnd)
                        self.score.append(adddata)
                    }
                } catch{
                    
                }
                
                dispatch_async(q_main, {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                        self.playername_textfield.text = self.playerName
                        self.PlayMatchName_textfield.text = self.matchName
                        self.Orgnaization_textfield.text = self.organizationName
                        self.Xcount_Lable.text = String(self.x)
                        self.tencount_Lable.text = String(self.ten)
                        self.year_mouth_day_textfield.text = self.created
                        self.Orgnaization_textfield.text = self.organizationName
                        self.prefectures_textfield.text = self.prefectures
                        self.Saddlecloth_textfield.text = self.number
                    for var i = 0;i<self.countPerEnd;i++ {
                         self.adaction()
                    }
                    
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
        

        
        self.TableView.allowsSelection = false//セル自体の選択を不可とする
        
        //set button event
       // dynamic_addcell_Button.addTarget(self, action: "eventButton_add:", forControlEvents: UIControlEvents.TouchUpInside)
        self.viewsize = view.bounds
        self.first_tablesize = self.TableView.bounds
        self.first_contentView = contentview.bounds
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        /****************/
        let longPressGesture :UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action:"longpress:")
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.allowableMovement = 20.0
        //        self.ba_name.addGestureRecognizer(longPressGesture)
        //        //これがないと長押しタップできない
        //        self.ba_name.userInteractionEnabled = true
        //        longPressGesture.delegate = self
        //tableviewを選択させない
        TableView.allowsSelection = false
    }
    
    func longpress(sender:UILongPressGestureRecognizer)
    {
        print("長押しされたよ")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // --tabelViewDatasouce
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        print("cell")
        
        let cell:TableviewCellSeen = self.TableView.dequeueReusableCellWithIdentifier("CellSeen",forIndexPath: indexPath) as! TableviewCellSeen
        //何セット目か
        print(indexPath.row)
        cell.perend_Label.text = String(self.score[self.score.count-1 - indexPath.row].perEnd) + "回目"
        cell.textField.text = self.lengthStr
        //cell.textField1.text = //ゼッケン
        let one = { () -> Int in
            if self.score[self.score.count-1 - indexPath.row].updatedScore_1 != ""{
                cell.textField_up2.backgroundColor = UIColor.redColor()
                if self.score[self.score.count-1 - indexPath.row].updatedScore_1 == "X"{
                    return 10
                } else if self.score[self.score.count-1 - indexPath.row].updatedScore_1 == "M"{
                    return 0
                }else{
                    return Int(self.score[self.score.count-1 - indexPath.row].updatedScore_1)!
                }
                
            }
            else{
                if self.score[self.score.count-1 - indexPath.row].score_1 == "X"{
                    return 10
                }else if self.score[self.score.count-1 - indexPath.row].score_1 == "M"{
                    return 0
                }else{
                    return Int(self.score[self.score.count-1 - indexPath.row].score_1)!                }
                }
        }
        let tw = { () -> Int in
            if self.score[self.score.count-1 - indexPath.row].updatedScore_2 != ""{
                cell.textField_up3.backgroundColor = UIColor.redColor()
                if self.score[self.score.count-1 - indexPath.row].updatedScore_2 == "X"{
                    return 10
                } else if self.score[self.score.count-1 - indexPath.row].updatedScore_2 == "M"{
                    return 0
                }else{
                    return Int(self.score[self.score.count-1 - indexPath.row].updatedScore_2)!
                }
            }
            else{
                if self.score[self.score.count-1 - indexPath.row].score_2 == "X"{
                    return 10
                }else if self.score[self.score.count-1 - indexPath.row].score_2 == "M"{
                    return 0
                }else{
                    return Int(self.score[self.score.count-1 - indexPath.row].score_2)!                }
            }
        }
        let th = { () -> Int in
            if self.score[self.score.count-1 - indexPath.row].updatedScore_3 != ""{
                cell.textField_up4.backgroundColor = UIColor.redColor()
                if self.score[self.score.count-1 - indexPath.row].updatedScore_3 == "X"{
                    return 10
                } else if self.score[self.score.count-1 - indexPath.row].updatedScore_3 == "M"{
                    return 0
                }else{
                    return Int(self.score[self.score.count-1 - indexPath.row].updatedScore_3)!
                }
            }
            else{
                if self.score[self.score.count-1 - indexPath.row].score_3 == "X"{
                    return 10
                }else if self.score[self.score.count-1 - indexPath.row].score_3 == "M"{
                    return 0
                }else{
                    return Int(self.score[self.score.count-1 - indexPath.row].score_3)!                }
            }
        }
        let fo = { () -> Int in
            if self.score[self.score.count-1 - indexPath.row].updatedScore_4 != ""{
                cell.textField_up5.backgroundColor = UIColor.redColor()
                if self.score[self.score.count-1 - indexPath.row].updatedScore_4 == "X"{
                    return 10
                } else if self.score[self.score.count-1 - indexPath.row].updatedScore_4 == "M"{
                    return 0
                }else{
                    return Int(self.score[self.score.count-1 - indexPath.row].updatedScore_4)!
                }
            }
            else{
                if self.score[self.score.count-1 - indexPath.row].score_4 == "X"{
                    return 10
                }else if self.score[self.score.count-1 - indexPath.row].score_4 == "M"{
                    return 0
                }else{
                    return Int(self.score[self.score.count-1 - indexPath.row].score_4)!                }
            }
        }
        let fi = {() -> Int in
            if self.score[self.score.count-1 - indexPath.row].updatedScore_5 != ""{
                cell.textField_up6.backgroundColor = UIColor.redColor()
                if self.score[self.score.count-1 - indexPath.row].updatedScore_5 == "X"{
                    return 10
                } else if self.score[self.score.count-1 - indexPath.row].updatedScore_5 == "M"{
                    return 0
                }else{
                    return Int(self.score[self.score.count-1 - indexPath.row].updatedScore_5)!
                }
            }
            else{
                if self.score[self.score.count-1 - indexPath.row].score_5 == "X"{
                    return 10
                }else if self.score[self.score.count-1 - indexPath.row].score_5 == "M"{
                    return 0
                }else{
                    return Int(self.score[self.score.count-1 - indexPath.row].score_5)!                }
            }
    }
        let six = { () -> Int in
            if self.score[self.score.count-1 - indexPath.row].updatedScore_6 != ""{
                cell.textField_up7.backgroundColor = UIColor.redColor()
                if self.score[self.score.count-1 - indexPath.row].updatedScore_6 == "X"{
                    return 10
                } else if self.score[self.score.count-1 - indexPath.row].updatedScore_6 == "M"{
                    return 0
                }else{
                    return Int(self.score[self.score.count-1 - indexPath.row].updatedScore_6)!
                }
            }
            else{
                if self.score[self.score.count-1 - indexPath.row].score_6 == "X"{
                    return 10
                }else if self.score[self.score.count-1 - indexPath.row].score_6 == "M"{
                    return 0
                }else{
                    return Int(self.score[self.score.count-1 - indexPath.row].score_6)!                }
            }
        }
        
        cell.textField2.text = self.score[self.score.count-1 - indexPath.row].score_1
        cell.textField3.text = self.score[self.score.count-1 - indexPath.row].score_2
        cell.textField4.text = self.score[self.score.count-1 - indexPath.row].score_3
        cell.textField5.text = self.score[self.score.count-1 - indexPath.row].score_4
        cell.textField6.text = self.score[self.score.count-1 - indexPath.row].score_5
        cell.textField7.text = self.score[self.score.count-1 - indexPath.row].score_6
        cell.textField_up2.text = self.score[self.score.count-1 - indexPath.row].updatedScore_1
        cell.textField_up3.text = self.score[self.score.count-1 - indexPath.row].updatedScore_2
        cell.textField_up4.text = self.score[self.score.count-1 - indexPath.row].updatedScore_3
        cell.textField_up5.text = self.score[self.score.count-1 - indexPath.row].updatedScore_4
        cell.textField_up6.text = self.score[self.score.count-1 - indexPath.row].updatedScore_5
        cell.textField_up7.text = self.score[self.score.count-1 - indexPath.row].updatedScore_6
        let total = one() + tw() + th() + fo() + fi() + six()
        switch self.score[self.score.count-1 - indexPath.row].perEnd{
        case 1 :
            firstcount_Label.text = String(total)
        case 2:
            secondcount_Lable.text = String(total)
        case 3:
            thirdcount_Label.text = String(total)
        case 4:
            foruthcount_Label.text = String(total)
        case 5:
            fifthcount_Label.text = String(total)
        case 6:
            sixthcount_Label.text = String(total)
        default:
            break
        }
        sumcount_Label.text = String(total+Int(sumcount_Label.text!)!)
        cell.textField8.text = String(total)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        print("count")
        
        return cellcount
    }
    func delscorecardEvent(sender:UIButton){
        //login出来ない時の処理
        let alert = UIAlertController(title: "確認", message: "本当に削除しますか？", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)
            
            
            
            let URLStr = "/app/personal/record/"
            let HTTPRequest = NSMutableURLRequest(URL: NSURL(string:Utility_inputs_limit().URLdataSet+URLStr+String(self.sc_id))!)
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
                        
                        dispatch_async(q_main, {
                            self.performSegueWithIdentifier("returnOldPlayDataIndex_to_cellpointviewseeUnwind", sender: self)
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
    
    var setcNew = CGFloat(1)
    var setcOld = CGFloat(1)
    var countai = 0
   
    //Cellいじるあれ
    func adaction(){
        cellcount++
        
        self.TableView.reloadData()
        
        let now_tablesize:CGRect = self.TableView.bounds
       
        
        let now_scrollsize = self.scrollview.bounds.height
        
        print(now_tablesize.height)
        
        if  CGFloat(cellcount*170)<self.TableView.bounds.height{
            notcellcount++
        }else if sizeout == 0{
            var setsize = self.TableView.frame.size.height % CGFloat(cellcount-1*170)
            print("Oldsetsize\(setsize)")
            setcOld = setsize
            setsize=170-setsize
            setcNew = setsize
            print("New_setsize\(setsize)")
            print("b\(self.scrollview.frame.height)")
            self.contentView_Layout.constant += setsize//ここで動く
            self.Scroll_Layout.constant -= setsize//ここで動く
            print("bottomoffset\(setsize)")
            print("contentsize\(self.scrollview.frame.height))")
           
            notcellcount++
            sizeout++
        }else{
            countai++
            self.Scroll_Layout.constant -= CGFloat(170)//ここで動く
            self.contentView_Layout.constant += CGFloat(170)//ここで動く
            
            let offset = CGFloat(170*countai)
          
            let bottomoffset = CGPointMake(0,offset+setcNew)//6,４ｓire
            print("bottomoffset\(bottomoffset)")
          
            
            //後半のoffsetはどうにかなってるんだけどなぁあああ
        }

    }
}


