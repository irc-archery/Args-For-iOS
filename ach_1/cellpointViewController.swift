//
//  ViewController.swift
//  cell9
//
//  Created by 早坂彪流 on 2015/06/02.
//  Copyright (c) 2015年 早坂彪流. All rights reserved.
//

import UIKit

class cellpointViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate,UIPopoverPresentationControllerDelegate{
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
        var sum:Int!
        var kakutei:Bool!
    }
    @IBAction func uptapevent(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    var chdid = false
    let picdata:Array<String>=["M","1","2","3","4","5","6","7","8","9","10","X"]
    var visitflag:Bool = false
    var sc_id:Int!
    var get_mid:Int!
    var playerName:String!
    var OrganizationName:String!
    var matchName:String!
    var created:String!
    var number:String!
    var prefectures:String!
    var length:Int!
    var lengthStr:String!
    var countPerEnd:Int!
    var ten:Int!
    var x:Int!
    var sum:Int!
    var permission:Bool!
    var maxPerEnd:Int!
    var score : Array<oldscore> = []
    var selectpickerdata:String! = "M"
        let URLStr = "/scoreCard"
    private var socket:SIOSocket! = nil
    private var indicator:MBProgressHUD! = nil
    private let see = Utility_inputs_limit().keych_access
    
    
    @IBOutlet weak var barbuttonun_button: UIButton!
    @IBOutlet weak var playname_textfield: UITextField!
    @IBOutlet weak var playerNumbar_textfield: UITextField!
    @IBOutlet weak var OrganizationName_textfield: UITextField!
    @IBOutlet weak var year_mouth_day_textfield: UITextField!
    @IBOutlet weak var playername_textfield: UITextField!
    @IBOutlet weak var prefecturesname_textfield: UITextField!
    @IBOutlet weak var playername_m_textfield: UITextField!
    @IBOutlet weak var recodername_m_textfield: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var first_la_view: UIView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var dynamic_addcell_Button: UIButton!
    @IBOutlet weak var contentview: UIView!
    @IBOutlet weak var Tencount_Lable: UILabel!
    @IBOutlet weak var Xcount_Lable: UILabel!
    @IBOutlet weak var firstcount_Label: UILabel!
    @IBOutlet weak var secondcount_Lable: UILabel!
    @IBOutlet weak var thirdcount_Label: UILabel!
    @IBOutlet weak var foruthcount_Label: UILabel!
    @IBOutlet weak var fifthcount_Label: UILabel!
    @IBOutlet weak var sixthcount_Label: UILabel!
    @IBOutlet weak var sumcount_Label: UILabel!
    @IBOutlet weak var Layout_ScrollView: NSLayoutConstraint!
    @IBOutlet weak var contentView_Layout: NSLayoutConstraint!
    @IBOutlet weak var Scroll_Layout: NSLayoutConstraint!
    
    
    
    @IBOutlet var up2_LongPress: UILongPressGestureRecognizer!
    
    @IBOutlet var up3_LongPress: UILongPressGestureRecognizer!
    @IBOutlet var up4_LongPress: UILongPressGestureRecognizer!
    
    @IBOutlet var up5_LongPress: UILongPressGestureRecognizer!
    @IBOutlet var up6_LongPress: UILongPressGestureRecognizer!
    @IBOutlet var up7_LongPress: UILongPressGestureRecognizer!
   
    @IBOutlet var m2_LongPress: UILongPressGestureRecognizer!
    @IBOutlet var m3_LongPressm: UILongPressGestureRecognizer!
    
    @IBOutlet var m4_LongPressm: UILongPressGestureRecognizer!
    @IBOutlet var m5_LongPressm: UILongPressGestureRecognizer!
    @IBOutlet var m6_LongPressm: UILongPressGestureRecognizer!
    @IBOutlet var m7_LongPressm: UILongPressGestureRecognizer!
    
    var MycheckPermission_data:Bool! = false//渡される閲覧用かどうかのあれ
    var cellcount = 0//ボタンのカウンタ変数
    var viewsize:CGRect!
    var first_tablesize:CGRect!
    var first_contentView:CGRect!
    var notcellcount = 0
    var sizeout = 0
    var set_sc_id:Int!//ここに選択されたSC_ID渡す
    
    var getPITcount:Int!=0
    
    
    /*********入れ込む*****/
    var a_a:String! = ""
    var b_a:String! = ""
    var c_a:String! = ""
    var d_a:String! = ""
    var e_a:String! = ""
    var f_a:String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //丸にする
        dynamic_addcell_Button.layer.masksToBounds = true
        dynamic_addcell_Button.layer.cornerRadius = 20
        barbuttonun_button.addTarget(self, action: "barbuttonun_buttonEvent:", forControlEvents: UIControlEvents.TouchUpInside)
        //スレッドの設定((UIKitのための
        
        let q_main: dispatch_queue_t  = dispatch_get_main_queue();
        SIOSocket.socketWithHost(Utility_inputs_limit().URLdataSet + URLStr, response:  { (_socket: SIOSocket!) in
            self.socket=_socket
            //接続の時に呼ばれる
            self.socket.onConnect = {()in
                print("connrcted of score")
                let idjs:NSDictionary = ["sc_id":self.set_sc_id,"sessionID":"sessionID=" + Utility_inputs_limit().keych_access]
                self.socket.emit("extractScoreCard", args:[idjs] as [AnyObject])
                self.socket.on("extractScoreCard", callback: {(data:[AnyObject]!) in
                    self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    self.indicator.dimBackground = true
                    self.indicator.labelText = "Loading..."
                    self.indicator.labelColor = UIColor.whiteColor()
                    print(data[0])
                    let dic = data[0] as! NSDictionary
                    self.sc_id = dic["sc_id"] as! Int
                    self.playerName = dic["playerName"] as! String
                    self.OrganizationName = dic["organizationName"] as? String
                    self.matchName = dic["matchName"] as! String
                    self.created = dic["created"] as! String
                    self.number = dic["number"] as? String
                    self.prefectures = dic["prefectures"] as? String
                    self.length = dic["length"] as? Int
                    self.countPerEnd = dic["countPerEnd"] as! Int
                    self.ten = dic["ten"] as! Int
                    self.x = dic["x"] as! Int
                    self.sum = dic["total"] as! Int
                    self.countPerEnd = dic["countPerEnd"] as! Int
                    self.permission = dic["permission"] as! Bool
                    let scoredata = dic["score"] as! NSArray
                    self.maxPerEnd = dic["maxPerEnd"] as! Int
                    
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
                    
                    for var i=0; i < self.countPerEnd;i++ {
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
                        let adddata = oldscore(score_1: score_1, score_2: score_2, score_3: score_3, score_4: score_4, score_5: score_5, score_6: score_6, updatedScore_1: updatedScore_1, updatedScore_2: updatedScore_2, updatedScore_3: updatedScore_3, updatedScore_4: updatedScore_4, updatedScore_5: updatedScore_5, updatedScore_6: updatedScore_6, subTotal: subTotal, perEnd: perEnd,sum: 0,kakutei: true)
                        self.score.insert(adddata, atIndex: 0)
                    }
                    
                    dispatch_async(q_main, {
                        
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        self.playername_textfield.text = self.playerName
                        self.playname_textfield.text = self.matchName
                        self.OrganizationName_textfield.text = self.OrganizationName
                        self.Xcount_Lable.text = String(self.x)
                        self.Tencount_Lable.text = String(self.ten)
                        self.year_mouth_day_textfield.text = self.created
                        self.OrganizationName_textfield.text = self.OrganizationName
                        self.prefecturesname_textfield.text = self.prefectures
                        self.playerNumbar_textfield.text = self.number
                        self.getPITcount = self.countPerEnd
                        self.prefecturesname_textfield.text = self.prefectures
                        self.sumcount_Label.text = String(self.sum)
                        //もしまだ一度もやってないならば
                        if self.permission == true && self.countPerEnd == 0 {
                            self.addtioncell()
                            
                        }else{
                            //表示するデータがあるならば
                            for var i = 0;i<self.countPerEnd;i++ {
                                let one = { () -> Int in
                                    if self.score[i].updatedScore_1 != ""{
                                        
                                        if self.score[i].updatedScore_1 == "X"{
                                            
                                            return 10
                                        } else if self.score[ i].updatedScore_1 == "M"{
                                            
                                            return 0
                                        }else{
                                            return Int(self.score[i].updatedScore_1)!
                                        }
                                        
                                    }
                                    else{
                                        
                                        if self.score[i].score_1 == "X"{
                                            return 10
                                        }else if self.score[i].score_1 == "M"{
                                            return 0
                                        }else{
                                            return Int(self.score[i].score_1)!                }
                                    }
                                }
                                let tw = { () -> Int in
                                    if self.score[i].updatedScore_2 != ""{
                                        
                                        if self.score[ i].updatedScore_2 == "X"{
                                            
                                            return 10
                                        } else if self.score[i].updatedScore_2 == "M"{
                                            
                                            return 0
                                            
                                        }else{
                                            return Int(self.score[i].updatedScore_2)!
                                        }
                                    }
                                    else{
                                        
                                        if self.score[i].score_2 == "X"{
                                            return 10
                                        }else if self.score[i].score_2 == "M"{
                                            return 0
                                        }else{
                                            print( self.score[i].score_2 )
                                            return Int(self.score[ i].score_2)!                }
                                    }
                                }
                                let th = { () -> Int in
                                    if self.score[i].updatedScore_3 != ""{
                                        
                                        if self.score[i].updatedScore_3 == "X"{
                                            
                                            return 10
                                        } else if self.score[i].updatedScore_3 == "M"{
                                            
                                            return 0
                                        }else{
                                            return Int(self.score[i].updatedScore_3)!
                                        }
                                    }
                                    else{
                                        
                                        if self.score[i].score_3 == "X"{
                                            return 10
                                        }else if self.score[i].score_3 == "M"{
                                            return 0
                                        }else{
                                            return Int(self.score[i].score_3)!                }
                                    }
                                }
                                let fo = { () -> Int in
                                    if self.score[i].updatedScore_4 != ""{
                                        
                                        if self.score[i].updatedScore_4 == "X"{
                                            
                                            return 10
                                        } else if self.score[ i].updatedScore_4 == "M"{
                                            return 0
                                        }else{
                                            return Int(self.score[i].updatedScore_4)!
                                        }
                                    }
                                    else{
                                        
                                        if self.score[i].score_4 == "X"{
                                            return 10
                                        }else if self.score[i].score_4 == "M"{
                                            return 0
                                        }else{
                                            return Int(self.score[i].score_4)!                }
                                    }
                                }
                                let fi = {() -> Int in
                                    if self.score[i].updatedScore_5 != ""{
                                        
                                        if self.score[i].updatedScore_5 == "X"{
                                            
                                            return 10
                                        } else if self.score[i].updatedScore_5 == "M"{
                                            return 0
                                        }else{
                                            return Int(self.score[i].updatedScore_5)!
                                        }
                                    }
                                    else{
                                        
                                        if self.score[i].score_5 == "X"{
                                            return 10
                                        }else if self.score[ i].score_5 == "M"{
                                            return 0
                                        }else{
                                            return Int(self.score[ i].score_5)!                }
                                    }
                                }
                                let six = { () -> Int in
                                    if self.score[i].updatedScore_6 != ""{
                                        
                                        if self.score[i].updatedScore_6 == "X"{
                                            
                                            return 10
                                        } else if self.score[i].updatedScore_6 == "M"{
                                            
                                            return 0
                                        }else{
                                            return Int(self.score[i].updatedScore_6)!
                                        }
                                    }
                                    else{
                                        
                                        if self.score[i].score_6 == "X"{
                                            return 10
                                        }else if self.score[i].score_6 == "M"{
                                            return 0
                                        }else{
                                            return Int(self.score[i].score_6)!                }
                                    }
                                }
                                let total = one() + tw() + th() + fo() + fi() + six()
                               
                                switch self.score[i].perEnd{
                                case 1 :
                                    self.firstcount_Label.text = String(total)
                                case 2:
                                    self.secondcount_Lable.text = String(total)
                                case 3:
                                    self.thirdcount_Label.text = String(total)
                                case 4:
                                    self.foruthcount_Label.text = String(total)
                                case 5:
                                    self.fifthcount_Label.text = String(total)
                                case 6:
                                    self.sixthcount_Label.text = String(total)
                                    
                                default:
                                    break
                                }
                                
                                self.addtioncell()
                            }
                            
                             self.sumcount_Label.text = String(self.sum)
                            //６以下であれば。
                            if self.countPerEnd<self.maxPerEnd && self.permission == true  {
                                self.addtioncell()
                                }
                        }
                        
                        //閲覧モードであればボタン使用不可にする
                        if self.permission == false{
                            self.dynamic_addcell_Button.setTitle("閲覧モード", forState: UIControlState.Normal)
                            self.dynamic_addcell_Button.enabled = false
                            
                            self.playname_textfield.enabled = false
                            self.playerNumbar_textfield.enabled = false
                            self.OrganizationName_textfield.enabled = false
                            self.year_mouth_day_textfield.enabled = false
                            self.playername_textfield.enabled = false
                            self.prefecturesname_textfield.enabled = false
                            
                            self.playername_m_textfield.enabled = false
                            self.recodername_m_textfield.enabled = false
                                                    }
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                    })
                })

            }
            //再接続の時に呼ばれる
            self.socket.onReconnect = {(attements:Int) in
                
            }
            //切断された時に呼ばれる
            self.socket.onDisconnect = {() in
                print("disconnrcted")
            }
           
            
            self.socket.on("broadcastInsertScore", callback: {(data:[AnyObject]!) in
                // アニメーションを開始する.
                self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                self.indicator.dimBackground = true
                self.indicator.labelText = "Loading..."
                self.indicator.labelColor = UIColor.whiteColor()
                print("broadcastInsertScore")
        
                print(data[0])
                if data[0] is NSDictionary == true{
                    let dic = data[0] as! NSDictionary
                    self.sc_id = dic["sc_id"] as! Int
                    let score_1 = dic["score_1"] as? String
                    let score_2 = dic["score_2"] as? String
                    let score_3 = dic["score_3"] as? String
                    let score_4 = dic["score_4"] as? String
                    let score_5 = dic["score_5"] as? String
                    let score_6 = dic["score_6"] as? String
                    
                    let subTotal = dic["subTotal"] as? Int
                    let perEnd = dic["perEnd"] as? Int
                    self.ten = dic["ten"] as? Int
                    let total = dic["total"] as? Int
                    self.x = dic["x"] as? Int
                    let adddata = oldscore(score_1: score_1, score_2: score_2, score_3: score_3, score_4: score_4, score_5: score_5, score_6: score_6, updatedScore_1: "", updatedScore_2: "", updatedScore_3: "", updatedScore_4: "", updatedScore_5: "", updatedScore_6: "", subTotal: subTotal, perEnd: perEnd, sum: total, kakutei: true)
                    self.score.insert(adddata, atIndex: 0)
                  
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    let  i = perEnd!-1
                    let one = { () -> Int in
                        if self.score[i].updatedScore_1 != ""{
                            
                            if self.score[i].updatedScore_1 == "X"{
                                
                                return 10
                            } else if self.score[ i].updatedScore_1 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_1)!
                            }
                            
                        }
                        else{
                            
                            if self.score[i].score_1 == "X"{
                                return 10
                            }else if self.score[i].score_1 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_1)!                }
                        }
                    }
                    let tw = { () -> Int in
                        if self.score[i].updatedScore_2 != ""{
                            
                            if self.score[ i].updatedScore_2 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_2 == "M"{
                                
                                return 0
                                
                            }else{
                                return Int(self.score[i].updatedScore_2)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_2 == "X"{
                                return 10
                            }else if self.score[i].score_2 == "M"{
                                return 0
                            }else{
                                print( self.score[i].score_2 )
                                return Int(self.score[ i].score_2)!                }
                        }
                    }
                    let th = { () -> Int in
                        if self.score[i].updatedScore_3 != ""{
                            
                            if self.score[i].updatedScore_3 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_3 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_3)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_3 == "X"{
                                return 10
                            }else if self.score[i].score_3 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_3)!                }
                        }
                    }
                    let fo = { () -> Int in
                        if self.score[i].updatedScore_4 != ""{
                            
                            if self.score[i].updatedScore_4 == "X"{
                                
                                return 10
                            } else if self.score[ i].updatedScore_4 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_4)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_4 == "X"{
                                return 10
                            }else if self.score[i].score_4 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_4)!                }
                        }
                    }
                    let fi = {() -> Int in
                        if self.score[i].updatedScore_5 != ""{
                            
                            if self.score[i].updatedScore_5 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_5 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_5)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_5 == "X"{
                                return 10
                            }else if self.score[ i].score_5 == "M"{
                                return 0
                            }else{
                                return Int(self.score[ i].score_5)!                }
                        }
                    }
                    let six = { () -> Int in
                        if self.score[i].updatedScore_6 != ""{
                            
                            if self.score[i].updatedScore_6 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_6 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_6)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_6 == "X"{
                                return 10
                            }else if self.score[i].score_6 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_6)!                }
                        }
                    }
                    
                    if self.permission == false{
                    let addtotal = one() + tw() + th() + fo() + fi() + six()
                    
                    
                    switch self.score[i].perEnd{
                    case 1 :
                        self.firstcount_Label.text = String(addtotal)
                    case 2:
                        self.secondcount_Lable.text = String(addtotal)
                      
                    case 3:
                        self.thirdcount_Label.text = String(addtotal)
                    case 4:
                        self.foruthcount_Label.text = String(addtotal)
                      
                    case 5:
                        self.fifthcount_Label.text = String(addtotal)
                        
                    case 6:
                        self.sixthcount_Label.text = String(addtotal)
                       
                    default:
                        break
                    }
                    
                    dispatch_async(q_main, {
                        self.Tencount_Lable.text = String(self.ten!)
                        self.Xcount_Lable.text = String(self.x!)
                        self.addtioncell()
                    })
                    }
                }
             
                
               
               
            })
            self.socket.on("broadcastInsertPrefectures", callback: {(data:[AnyObject]!) in
                print("broadcastInsertPrefectures")
                print(data[0])
                if self.permission == false{
                let dic:NSDictionary = (data[0] as? NSDictionary)!
                let prefecturesdata = dic["Prefectures"] as! String
                self.prefecturesname_textfield.text = prefecturesdata
                self.TableView.reloadData()
                }
            })
            self.socket.on("broadcastInsertNumber", callback: {(data:[AnyObject]!) in
                print(data[0])
                if self.permission == false{
                let dic:NSDictionary = (data[0] as? NSDictionary)!
                let numbardata = dic["number"] as? String
                self.playerNumbar_textfield.text = numbardata!
                self.TableView.reloadData()
                }
            })
            self.socket.on("broadcastUpdateScore", callback: {(data:[AnyObject]!) in
                print("broadcastUpdateScore")
                print(data[0])
                if self.permission == false{
                print(self.score.endIndex)
                let dic:NSDictionary = (data[0] as? NSDictionary)!
                let perEnddata = dic["perEnd"] as? Int
                let updatedScore_1 = dic["updatedScore_1"] as? String
                let updatedScore_2 = dic["updatedScore_2"] as? String
                let updatedScore_3 = dic["updatedScore_3"] as? String
                let updatedScore_4 = dic["updatedScore_4"] as? String
                let updatedScore_5 = dic["updatedScore_5"] as? String
                let updatedScore_6 = dic["updatedScore_6"] as? String
                if updatedScore_1 != nil{
                    self.score[self.score.count - perEnddata!].updatedScore_1 = updatedScore_1
                }
                else if updatedScore_2 != nil{
                    self.score[self.score.count - perEnddata!].updatedScore_2 = updatedScore_2
                }
                else if updatedScore_3 != nil{
                    self.score[self.score.count - perEnddata!].updatedScore_3 = updatedScore_3
                }
                else if  updatedScore_4 != nil{
                    self.score[self.score.count  - perEnddata!].updatedScore_4 = updatedScore_4
                }
                else if  updatedScore_5 != nil{
                    self.score[self.score.count   - perEnddata!].updatedScore_5 = updatedScore_5
                }
                else if  updatedScore_6 != nil{
                    self.score[self.score.count  - perEnddata!].updatedScore_6 = updatedScore_6
                }
                let ten = dic["ten"] as? Int
                let x = dic["x"] as? Int
                let total = dic["total"] as? Int
                dispatch_async(q_main, {
                    self.sumcount_Label.text = String(total!)
                    self.Tencount_Lable.text = String(ten!)
                    self.Xcount_Lable.text = String(x!)
                    self.TableView.reloadData()
                })
                }
            })
            
        })
        
        
        up2_LongPress.addTarget(self, action: "up2_LongPressEvent:")
        up3_LongPress.addTarget(self, action: "up3_LongPressEvent:")
        up4_LongPress.addTarget(self, action: "up4_LongPressEvent:")
        up5_LongPress.addTarget(self, action: "up5_LongPressEvent:")
        up6_LongPress.addTarget(self, action: "up6_LongPressEvent:")
        up7_LongPress.addTarget(self, action: "up7_LongPressEvent:")
        m2_LongPress.addTarget(self, action:
            "up2_LongPressEvent:")
        m3_LongPressm.addTarget(self, action: "up3_LongPressEvent:")
        m4_LongPressm.addTarget(self, action: "up4_LongPressEvent:")
        m5_LongPressm.addTarget(self, action: "up5_LongPressEvent:")
        m6_LongPressm.addTarget(self, action: "up6_LongPressEvent:")
        m7_LongPressm.addTarget(self, action: "up7_LongPressEvent:")
        
        self.TableView.allowsSelection = false//セル自体の選択を不可とする
        //set button event
        dynamic_addcell_Button.addTarget(self, action: "eventButton_add:", forControlEvents: UIControlEvents.TouchUpInside)
        self.viewsize = view.bounds
        self.first_tablesize = self.TableView.bounds
        self.first_contentView = contentview.bounds
        self.automaticallyAdjustsScrollViewInsets = false
        
        
       
        //tableviewを選択させない
        TableView.allowsSelection = false
    }
    func barbuttonun_buttonEvent(sender:UIButton){
        self.socket.close()
    }
    //pickerDatasouce
    //pickerに表示する行数を返すデータソースメソッド.
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picdata.count
    }
    //表示列
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.FullScreen
        
    }
    //pickerDelagate
    //表示させるものを返すやつ
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picdata[row] as String
    }
    
    //pickerが選択された際に呼ばれるデリゲートメソッド.
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row: \(row)")
        print("value: \(picdata[row])")
        selectpickerdata = picdata[row]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //longtapEvent
    func up2_LongPressEvent(sender:UILongPressGestureRecognizer)
    {
        print("1長押しされたよ")
        if sender.state == UIGestureRecognizerState.Began {
            let p = sender.locationInView(self.TableView)
            let indexpath = self.TableView.indexPathForRowAtPoint(p)
            
            if indexpath == nil{
                print("long press on table view but not on a row")
            }else{
              
                print("long press on table view at section \(indexpath?.section) row \(indexpath?.row)")
                if score.isEmpty {
                    return
                }
                var indexindex = indexpath!.row - 1
                if score.count == self.maxPerEnd{
                    indexindex = indexpath!.row
                }
                else if cellcount-1<indexindex || !(0<=indexindex){
                    return
                }
                
                if score[indexindex].kakutei == false{
                    return
                }
                //ここでpad切り替え
                var uialest = UIAlertControllerStyle.Alert
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone){
                 uialest = UIAlertControllerStyle.ActionSheet
                }
                
                //アラートのインスタンスを生成
                let alert = UIAlertController(title: "\(self.score[indexindex].perEnd)回目の１射目を変更します。", message: "変更内容をセレクトしてください。\n\n\n\n\n\n\n\n\n", preferredStyle: uialest)
                
                var pickerFrame:CGRect! = nil
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone){
                       alert.modalInPopover = true
                    pickerFrame = CGRectMake(0, 0,view.frame.width - 16 - 3, self.view.frame.height - 34)
                        }
                else{
                    pickerFrame = CGRectMake(alert.view.frame.origin.x,alert.view.frame.origin.y,alert.view.frame.width/3, alert.view.frame.height)
                }
                
                let picker: UIPickerView = UIPickerView(frame: pickerFrame);
                picker.delegate = self
                picker.dataSource = self
                picker.tag = 2
                alert.view.addSubview(picker)
                
                
                // AlertControllerにActionを追加
                // 基本的にはActionが追加された順序でボタンが配置される
                //ちなみに Cancelは例外的に一番下に配置される
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
                    print(action.title)
                    //ここはやることとしてはいれつinsertとのイベント
                    self.score[indexindex].updatedScore_1 = self.selectpickerdata
                    
                    let i = indexindex
                    //subtotalのやつ
                    let one = { () -> Int in
                        if self.score[i].updatedScore_1 != ""{
                            
                            if self.score[i].updatedScore_1 == "X"{
                                
                                return 10
                            } else if self.score[ i].updatedScore_1 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_1)!
                            }
                            
                        }
                        else{
                            
                            if self.score[i].score_1 == "X"{
                                return 10
                            }else if self.score[i].score_1 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_1)!                }
                        }
                    }
                    let tw = { () -> Int in
                        if self.score[i].updatedScore_2 != ""{
                            
                            if self.score[ i].updatedScore_2 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_2 == "M"{
                                
                                return 0
                                
                            }else{
                                return Int(self.score[i].updatedScore_2)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_2 == "X"{
                                return 10
                            }else if self.score[i].score_2 == "M"{
                                return 0
                            }else{
                                print( self.score[i].score_2 )
                                return Int(self.score[ i].score_2)!                }
                        }
                    }
                    let th = { () -> Int in
                        if self.score[i].updatedScore_3 != ""{
                            
                            if self.score[i].updatedScore_3 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_3 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_3)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_3 == "X"{
                                return 10
                            }else if self.score[i].score_3 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_3)!                }
                        }
                    }
                    let fo = { () -> Int in
                        if self.score[i].updatedScore_4 != ""{
                            
                            if self.score[i].updatedScore_4 == "X"{
                                
                                return 10
                            } else if self.score[ i].updatedScore_4 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_4)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_4 == "X"{
                                return 10
                            }else if self.score[i].score_4 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_4)!                }
                        }
                    }
                    let fi = {() -> Int in
                        if self.score[i].updatedScore_5 != ""{
                            
                            if self.score[i].updatedScore_5 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_5 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_5)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_5 == "X"{
                                return 10
                            }else if self.score[ i].score_5 == "M"{
                                return 0
                            }else{
                                return Int(self.score[ i].score_5)!                }
                        }
                    }
                    let six = { () -> Int in
                        if self.score[i].updatedScore_6 != ""{
                            
                            if self.score[i].updatedScore_6 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_6 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_6)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_6 == "X"{
                                return 10
                            }else if self.score[i].score_6 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_6)!                }
                        }
                    }
                    let subtotal = one() + tw() + th() + fo() + fi() + six()
                    self.sumcount_Label.text = String(subtotal + Int(self.sumcount_Label.text!)!)
                    switch self.score[i].perEnd{
                    case 1 :
                        self.firstcount_Label.text = String(subtotal)
                    case 2:
                        self.secondcount_Lable.text = String(subtotal)
                        
                    case 3:
                        self.thirdcount_Label.text = String(subtotal)
                    case 4:
                        self.foruthcount_Label.text = String(subtotal)
                    case 5:
                        self.fifthcount_Label.text = String(subtotal)
                    case 6:
                        self.sixthcount_Label.text = String(subtotal)
                        
                    default:
                        break
                    }
                    
           
                    //全てのやつ求める
                    var total:Int = 0
                    var Xcount:Int = 0
                    var tencount:Int = 0
                    var iototal = 0
                    for var count  = 0;count<self.score.count;count++ {
                        
                        let one = { () -> Int in
                            if self.score[count].updatedScore_1 != ""{
                                
                                if self.score[count].updatedScore_1 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_1 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_1 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_1)!
                                }
                                
                            }
                            else{
                                if self.score[count].score_1 == "X"{
                                    return 10
                                }else if self.score[count].score_1 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_1)!
                                }
                            }
                        }
                        let tw = { () -> Int in
                            if self.score[count].updatedScore_2 != ""{
                                
                                if self.score[count].updatedScore_2 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_2 == "M"{
                                    
                                    return 0
                                    
                                }else{
                                    if self.score[count].updatedScore_2 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_2)!
                                }
                            }
                            else{
                                if self.score[count].score_2 == "X"{
                                    return 10
                                }else if self.score[count].score_2 == "M"{
                                    return 0
                                }else{
                                    
                                    return Int(self.score[count].score_2)!
                                }
                            }
                        }
                        let th = { () -> Int in
                            if self.score[count].updatedScore_3 != "" {
                                
                                if self.score[count].updatedScore_3 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_3 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_3 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_3)!
                                }
                            }else{
                                if self.score[count].score_3 == "X" {
                                    return 10
                                }else if self.score[count].score_3=="M" {
                                    return 0
                                }else{
                                    
                                    return Int(self.score[count].score_3)!                }
                            }
                        }
                        let fo = { () -> Int in
                            if self.score[count].updatedScore_4 != ""{
                                
                                if self.score[count].updatedScore_4 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_4 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_4 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_4)!
                                }
                            }
                            else{
                                if self.score[count].score_4 == "X"{
                                    return 10
                                }else if self.score[count].score_4 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_4)!                }
                            }
                        }
                        let fi = {() -> Int in
                            if self.score[count].updatedScore_5 != ""{
                                
                                if self.score[count].updatedScore_5 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_5 == "M"{
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_5 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_5)!
                                }
                            }
                            else{
                                
                                if self.score[count].score_5 == "X"{
                                    return 10
                                }else if self.score[count].score_5 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_5)!                }
                            }
                        }
                        let six = { () -> Int in
                            if self.score[count].updatedScore_6 != ""{
                                
                                if self.score[count].updatedScore_6 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_6 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_6 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_6)!
                                }
                            }
                            else{
                                
                                if self.score[count].score_6 == "X"{
                                    return 10
                                }else if self.score[count].score_6 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_6)!               }
                            }
                        }
                        total = one() + tw() + th() + fo() + fi() + six()
                        iototal += total
                        self.sumcount_Label.text = String(total + Int(self.sumcount_Label.text!)!)
                        switch self.score[count].perEnd{
                        case 1 :
                            self.firstcount_Label.text = String(total)
                        case 2:
                            self.secondcount_Lable.text = String(total)
                            
                        case 3:
                            self.thirdcount_Label.text = String(total)
                        case 4:
                            self.foruthcount_Label.text = String(total)
                        case 5:
                            self.fifthcount_Label.text = String(total)
                        case 6:
                            self.sixthcount_Label.text = String(total)
                            
                        default:
                            print("なにもできなかった")
                        }
                        
                        
                        
                    }
                    let numin:NSDictionary = ["sc_id":self.set_sc_id,"m_id":self.get_mid,"sessionID":"sessionID=" + Utility_inputs_limit().keych_access,"updatedScore_1":self.score[indexindex].updatedScore_1,"subTotal":subtotal,"ten":tencount,"x":Xcount,"total":iototal,"perEnd":self.score[indexindex].perEnd]
                    self.socket.emit("updateScore", args:[numin] as [AnyObject])
                    self.TableView.reloadData()
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{ action in print(action.title)
                    //こっちはほじしてピッカービューのでーたけす
                    self.selectpickerdata = "M"
                }))
                
                
                // アラートを表示
                self.presentViewController(alert,
                    animated: true,
                    completion: {
                        print("Alert displayed")
                })
                
                
            }
        }
    }
    func up3_LongPressEvent(sender:UILongPressGestureRecognizer)
    {
        print("2長押しされたよ")
        if sender.state == UIGestureRecognizerState.Began {
            let p = sender.locationInView(self.TableView)
            let indexpath = self.TableView.indexPathForRowAtPoint(p)
            
            if indexpath == nil{
                print("long press on table view but not on a row")
            }else{
               
                print("long press on table view at section \(indexpath?.section) row \(indexpath?.row)")
                if score.isEmpty {
                    return
                }
                var indexindex = indexpath!.row - 1
                if score.count == self.maxPerEnd{
                    indexindex = indexpath!.row
                }
                else if cellcount-1<indexindex || !(0<=indexindex){
                    return
                }
                if score[indexindex].kakutei == false{
                    return
                }
                //ここでpad切り替え
                var uialest = UIAlertControllerStyle.Alert
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone){
                    uialest = UIAlertControllerStyle.ActionSheet
                }
                
                //アラートのインスタンスを生成
                let alert = UIAlertController(title: "\(self.score[indexindex].perEnd)回目の2射目を変更します。", message: "変更内容をセレクトしてください。\n\n\n\n\n\n\n\n\n", preferredStyle: uialest)
                
                var pickerFrame:CGRect! = nil
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone){
                    alert.modalInPopover = true
                    pickerFrame = CGRectMake(0, 0,view.frame.width - 16 - 3, self.view.frame.height - 34)
                }
                else{
                    pickerFrame = CGRectMake(alert.view.frame.origin.x,alert.view.frame.origin.y,alert.view.frame.width/3, alert.view.frame.height)
                }
                
                let picker: UIPickerView = UIPickerView(frame: pickerFrame);
                picker.delegate = self
                picker.dataSource = self
                picker.tag = 3
                alert.view.addSubview(picker)
                // AlertControllerにActionを追加
                // 基本的にはActionが追加された順序でボタンが配置される
                //ちなみに Cancelは例外的に一番下に配置される
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
                    print(action.title)
                    //ここはやることとしてはいれつinsertとSいオのイベント
                    self.score[indexindex].updatedScore_2 = self.selectpickerdata
                    
                    let i = indexindex
                    //subtotalのやつ
                    let one = { () -> Int in
                        if self.score[i].updatedScore_1 != ""{
                            
                            if self.score[i].updatedScore_1 == "X"{
                                
                                return 10
                            } else if self.score[ i].updatedScore_1 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_1)!
                            }
                            
                        }
                        else{
                            
                            if self.score[i].score_1 == "X"{
                                return 10
                            }else if self.score[i].score_1 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_1)!                }
                        }
                    }
                    let tw = { () -> Int in
                        if self.score[i].updatedScore_2 != ""{
                            
                            if self.score[ i].updatedScore_2 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_2 == "M"{
                                
                                return 0
                                
                            }else{
                                return Int(self.score[i].updatedScore_2)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_2 == "X"{
                                return 10
                            }else if self.score[i].score_2 == "M"{
                                return 0
                            }else{
                                print( self.score[i].score_2 )
                                return Int(self.score[ i].score_2)!                }
                        }
                    }
                    let th = { () -> Int in
                        if self.score[i].updatedScore_3 != ""{
                            
                            if self.score[i].updatedScore_3 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_3 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_3)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_3 == "X"{
                                return 10
                            }else if self.score[i].score_3 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_3)!                }
                        }
                    }
                    let fo = { () -> Int in
                        if self.score[i].updatedScore_4 != ""{
                            
                            if self.score[i].updatedScore_4 == "X"{
                                
                                return 10
                            } else if self.score[ i].updatedScore_4 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_4)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_4 == "X"{
                                return 10
                            }else if self.score[i].score_4 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_4)!                }
                        }
                    }
                    let fi = {() -> Int in
                        if self.score[i].updatedScore_5 != ""{
                            
                            if self.score[i].updatedScore_5 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_5 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_5)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_5 == "X"{
                                return 10
                            }else if self.score[ i].score_5 == "M"{
                                return 0
                            }else{
                                return Int(self.score[ i].score_5)!                }
                        }
                    }
                    let six = { () -> Int in
                        if self.score[i].updatedScore_6 != ""{
                            
                            if self.score[i].updatedScore_6 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_6 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_6)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_6 == "X"{
                                return 10
                            }else if self.score[i].score_6 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_6)!                }
                        }
                    }
                    let subtotal = one() + tw() + th() + fo() + fi() + six()
                    self.sumcount_Label.text = String(subtotal )
                    switch self.score[i].perEnd{
                    case 1 :
                        self.firstcount_Label.text = String(subtotal)
                    case 2:
                        self.secondcount_Lable.text = String(subtotal)
                    case 3:
                        self.thirdcount_Label.text = String(subtotal)
                    case 4:
                        self.foruthcount_Label.text = String(subtotal)
                    case 5:
                        self.fifthcount_Label.text = String(subtotal)
                    case 6:
                        self.sixthcount_Label.text = String(subtotal)
                        
                    default:
                        break
                    }
                    
                    
                    
                    
                    //全てのやつ求める
                    var total:Int = 0
                    var Xcount:Int = 0
                    var tencount:Int = 0
                    var iototal = 0
                    for var count  = 0;count<self.score.count;count++ {
                        
                        
                        let one = { () -> Int in
                            if self.score[count].updatedScore_1 != ""{
                                
                                if self.score[count].updatedScore_1 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_1 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_1 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_1)!
                                }
                                
                            }
                            else{
                                if self.score[count].score_1 == "X"{
                                    return 10
                                }else if self.score[count].score_1 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_1)!
                                }
                            }
                        }
                        let tw = { () -> Int in
                            if self.score[count].updatedScore_2 != ""{
                                
                                if self.score[count].updatedScore_2 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_2 == "M"{
                                    
                                    return 0
                                    
                                }else{
                                    if self.score[count].updatedScore_2 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_2)!
                                }
                            }
                            else{
                                if self.score[count].score_2 == "X"{
                                    return 10
                                }else if self.score[count].score_2 == "M"{
                                    return 0
                                }else{
                                    
                                    return Int(self.score[count].score_2)!
                                }
                            }
                        }
                        let th = { () -> Int in
                            if self.score[count].updatedScore_3 != "" {
                                
                                if self.score[count].updatedScore_3 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_3 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_3 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_3)!
                                }
                            }else{
                                if self.score[count].score_3 == "X" {
                                    return 10
                                }else if self.score[count].score_3=="M" {
                                    return 0
                                }else{
                                    
                                    return Int(self.score[count].score_3)!                }
                            }
                        }
                        let fo = { () -> Int in
                            if self.score[count].updatedScore_4 != ""{
                                
                                if self.score[count].updatedScore_4 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_4 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_4 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_4)!
                                }
                            }
                            else{
                                if self.score[count].score_4 == "X"{
                                    return 10
                                }else if self.score[count].score_4 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_4)!                }
                            }
                        }
                        let fi = {() -> Int in
                            if self.score[count].updatedScore_5 != ""{
                                
                                if self.score[count].updatedScore_5 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_5 == "M"{
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_5 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_5)!
                                }
                            }
                            else{
                                
                                if self.score[count].score_5 == "X"{
                                    return 10
                                }else if self.score[count].score_5 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_5)!                }
                            }
                        }
                        let six = { () -> Int in
                            if self.score[count].updatedScore_6 != ""{
                                
                                if self.score[count].updatedScore_6 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_6 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_6 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_6)!
                                }
                            }
                            else{
                                
                                if self.score[count].score_6 == "X"{
                                    return 10
                                }else if self.score[count].score_6 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_6)!               }
                            }
                        }
                        total = one() + tw() + th() + fo() + fi() + six()
                        iototal += total
                        self.sumcount_Label.text = String(total)
                        switch self.score[count].perEnd{
                        case 1 :
                            self.firstcount_Label.text = String(total)
                        case 2:
                            self.secondcount_Lable.text = String(total)
                            
                        case 3:
                            self.thirdcount_Label.text = String(total)
                        case 4:
                            self.foruthcount_Label.text = String(total)
                        case 5:
                            self.fifthcount_Label.text = String(total)
                        case 6:
                            self.sixthcount_Label.text = String(total)
                            
                        default:
                            print("なにもできなかった")
                        }
                        
                        
                        
                    }
                  
                    
                    let numin:NSDictionary = ["sc_id":self.set_sc_id,"m_id":self.get_mid,"sessionID":"sessionID=" + Utility_inputs_limit().keych_access,"updatedScore_2":self.score[indexindex].updatedScore_2,"subTotal":subtotal,"ten":tencount,"x":Xcount,"total":iototal,"perEnd":self.score[indexindex].perEnd]
                    self.socket.emit("updateScore", args:[numin] as [AnyObject])
                    self.TableView.reloadData()
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{ action in print(action.title)
                    //こっちはほじしてピッカービューのでーたけす
                    self.selectpickerdata = "M"
                }))
                
                
                // アラートを表示
                self.presentViewController(alert,
                    animated: true,
                    completion: {
                        print("Alert displayed")
                })
                
                // self.score[indexpath?.row].updatedScore_1 = //なんかで入れ込む
                //    }
                //  }
            }
        }
    }
    func up4_LongPressEvent(sender:UILongPressGestureRecognizer)
    {
        print("3長押しされたよ")
        if sender.state == UIGestureRecognizerState.Began {
            let p = sender.locationInView(self.TableView)
            let indexpath = self.TableView.indexPathForRowAtPoint(p)
            
            if indexpath == nil{
                print("long press on table view but not on a row")
            }else{
                if score.isEmpty {
                    return
                }
                var indexindex = indexpath!.row - 1
                if score.count == self.maxPerEnd{
                    indexindex = indexpath!.row
                }
                else if cellcount-1<indexindex || !(0<=indexindex){
                    return
                }
                if score[indexindex].kakutei == false{
                    return
                }
                print("long press on table view at section \(indexpath?.section) row \(indexpath?.row)")
                //ここでpad切り替え
                var uialest = UIAlertControllerStyle.Alert
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone){
                    uialest = UIAlertControllerStyle.ActionSheet
                }
                
                //アラートのインスタンスを生成
                let alert = UIAlertController(title: "\(self.score[indexindex].perEnd)回目の3射目を変更します。", message: "変更内容をセレクトしてください。\n\n\n\n\n\n\n\n\n", preferredStyle: uialest)
                
                var pickerFrame:CGRect! = nil
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone){
                    alert.modalInPopover = true
                    pickerFrame = CGRectMake(0, 0,view.frame.width - 16 - 3, self.view.frame.height - 34)
                }
                else{
                    pickerFrame = CGRectMake(alert.view.frame.origin.x,alert.view.frame.origin.y,alert.view.frame.width/3, alert.view.frame.height)
                }
                
                let picker: UIPickerView = UIPickerView(frame: pickerFrame);
                picker.delegate = self
                picker.dataSource = self
                picker.tag = 4
                alert.view.addSubview(picker)
                
                // AlertControllerにActionを追加
                // 基本的にはActionが追加された順序でボタンが配置される
                //ちなみに Cancelは例外的に一番下に配置される
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
                    print(action.title)
                    //ここはやることとしてはいれつinsertとSいオのイベント
                    self.score[indexindex].updatedScore_3 = self.selectpickerdata
                    
                    let i = indexindex
                    //subtotalのやつ
                    let one = { () -> Int in
                        if self.score[i].updatedScore_1 != ""{
                            
                            if self.score[i].updatedScore_1 == "X"{
                                
                                return 10
                            } else if self.score[ i].updatedScore_1 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_1)!
                            }
                            
                        }
                        else{
                            
                            if self.score[i].score_1 == "X"{
                                return 10
                            }else if self.score[i].score_1 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_1)!                }
                        }
                    }
                    let tw = { () -> Int in
                        if self.score[i].updatedScore_2 != ""{
                            
                            if self.score[ i].updatedScore_2 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_2 == "M"{
                                
                                return 0
                                
                            }else{
                                return Int(self.score[i].updatedScore_2)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_2 == "X"{
                                return 10
                            }else if self.score[i].score_2 == "M"{
                                return 0
                            }else{
                                print( self.score[i].score_2 )
                                return Int(self.score[ i].score_2)!                }
                        }
                    }
                    let th = { () -> Int in
                        if self.score[i].updatedScore_3 != ""{
                            
                            if self.score[i].updatedScore_3 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_3 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_3)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_3 == "X"{
                                return 10
                            }else if self.score[i].score_3 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_3)!                }
                        }
                    }
                    let fo = { () -> Int in
                        if self.score[i].updatedScore_4 != ""{
                            
                            if self.score[i].updatedScore_4 == "X"{
                                
                                return 10
                            } else if self.score[ i].updatedScore_4 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_4)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_4 == "X"{
                                return 10
                            }else if self.score[i].score_4 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_4)!                }
                        }
                    }
                    let fi = {() -> Int in
                        if self.score[i].updatedScore_5 != ""{
                            
                            if self.score[i].updatedScore_5 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_5 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_5)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_5 == "X"{
                                return 10
                            }else if self.score[ i].score_5 == "M"{
                                return 0
                            }else{
                                return Int(self.score[ i].score_5)!                }
                        }
                    }
                    let six = { () -> Int in
                        if self.score[i].updatedScore_6 != ""{
                            
                            if self.score[i].updatedScore_6 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_6 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_6)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_6 == "X"{
                                return 10
                            }else if self.score[i].score_6 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_6)!                }
                        }
                    }
                    let subtotal = one() + tw() + th() + fo() + fi() + six()
                    self.sumcount_Label.text = String(subtotal)
                    switch self.score[i].perEnd{
                    case 1 :
                        self.firstcount_Label.text = String(subtotal)
                    case 2:
                        self.secondcount_Lable.text = String(subtotal)
                        
                    case 3:
                        self.thirdcount_Label.text = String(subtotal)
                    case 4:
                        self.foruthcount_Label.text = String(subtotal)
                    case 5:
                        self.fifthcount_Label.text = String(subtotal)
                    case 6:
                        self.sixthcount_Label.text = String(subtotal)
                        
                    default:
                        break
                    }
                    
                    
                    
                    
                    //全てのやつ求める
                    var total:Int = 0
                    var Xcount:Int = 0
                    var tencount:Int = 0
                    var iomax = 0
                    for var count  = 0;count<self.score.count;count++ {
                        let one = { () -> Int in
                            if self.score[count].updatedScore_1 != ""{
                                
                                if self.score[count].updatedScore_1 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_1 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_1 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_1)!
                                }
                                
                            }
                            else{
                                if self.score[count].score_1 == "X"{
                                    return 10
                                }else if self.score[count].score_1 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_1)!
                                }
                            }
                        }
                        let tw = { () -> Int in
                            if self.score[count].updatedScore_2 != ""{
                                
                                if self.score[count].updatedScore_2 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_2 == "M"{
                                    
                                    return 0
                                    
                                }else{
                                    if self.score[count].updatedScore_2 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_2)!
                                }
                            }
                            else{
                                if self.score[count].score_2 == "X"{
                                    return 10
                                }else if self.score[count].score_2 == "M"{
                                    return 0
                                }else{
                                    
                                    return Int(self.score[count].score_2)!
                                }
                            }
                        }
                        let th = { () -> Int in
                            if self.score[count].updatedScore_3 != "" {
                                
                                if self.score[count].updatedScore_3 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_3 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_3 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_3)!
                                }
                            }else{
                                if self.score[count].score_3 == "X" {
                                    return 10
                                }else if self.score[count].score_3=="M" {
                                    return 0
                                }else{
                                    
                                    return Int(self.score[count].score_3)!                }
                            }
                        }
                        let fo = { () -> Int in
                            if self.score[count].updatedScore_4 != ""{
                                
                                if self.score[count].updatedScore_4 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_4 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_4 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_4)!
                                }
                            }
                            else{
                                if self.score[count].score_4 == "X"{
                                    return 10
                                }else if self.score[count].score_4 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_4)!                }
                            }
                        }
                        let fi = {() -> Int in
                            if self.score[count].updatedScore_5 != ""{
                                
                                if self.score[count].updatedScore_5 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_5 == "M"{
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_5 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_5)!
                                }
                            }
                            else{
                                
                                if self.score[count].score_5 == "X"{
                                    return 10
                                }else if self.score[count].score_5 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_5)!                }
                            }
                        }
                        let six = { () -> Int in
                            if self.score[count].updatedScore_6 != ""{
                                
                                if self.score[count].updatedScore_6 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_6 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_6 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_6)!
                                }
                            }
                            else{
                                
                                if self.score[count].score_6 == "X"{
                                    return 10
                                }else if self.score[count].score_6 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_6)!               }
                            }
                        }
                        total = one() + tw() + th() + fo() + fi() + six()
                        iomax += total
                        self.sumcount_Label.text = String(total)
                        switch self.score[count].perEnd{
                        case 1 :
                            self.firstcount_Label.text = String(total)
                        case 2:
                            self.secondcount_Lable.text = String(total)
                            
                        case 3:
                            self.thirdcount_Label.text = String(total)
                        case 4:
                            self.foruthcount_Label.text = String(total)
                        case 5:
                            self.fifthcount_Label.text = String(total)
                        case 6:
                            self.sixthcount_Label.text = String(total)
                            
                        default:
                            print("なにもできなかった")
                        }
                        
                        
                        
                    }
                    let maxtotal = Int(self.firstcount_Label.text!)! + Int(self.secondcount_Lable.text!)! + Int(self.thirdcount_Label.text!)! + Int(self.foruthcount_Label.text!)! + Int(self.fifthcount_Label.text!)! + Int(self.sixthcount_Label.text!)!
                    
                    let numin:NSDictionary = ["sc_id":self.set_sc_id,"m_id":self.get_mid,"sessionID":"sessionID=" + Utility_inputs_limit().keych_access,"updatedScore_3":self.score[indexindex].updatedScore_3,"subTotal":subtotal,"ten":tencount,"x":Xcount,"total":iomax,"perEnd":self.score[indexindex].perEnd]
                    self.socket.emit("updateScore", args:[numin] as [AnyObject])
                    self.TableView.reloadData()
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{ action in print(action.title)
                    //こっちはほじしてピッカービューのでーたけす
                    self.selectpickerdata = "M"
                }))
                
                
                // アラートを表示
                self.presentViewController(alert,
                    animated: true,
                    completion: {
                        print("Alert displayed")
                })
                
                // self.score[indexpath?.row].updatedScore_1 = //なんかで入れ込む
                //    }
                //  }
            }
        }
        
    }
    func up5_LongPressEvent(sender:UILongPressGestureRecognizer)
    {
        print("4長押しされたよ")
        if sender.state == UIGestureRecognizerState.Began {
            let p = sender.locationInView(self.TableView)
            let indexpath = self.TableView.indexPathForRowAtPoint(p)
            
            if indexpath == nil{
                print("long press on table view but not on a row")
            }else{
               
                print("long press on table view at section \(indexpath?.section) row \(indexpath?.row)")
                if score.isEmpty {
                    return
                }
                var indexindex = indexpath!.row - 1
                if score.count == self.maxPerEnd{
                    indexindex = indexpath!.row
                }
                else if cellcount-1<indexindex || !(0<=indexindex){
                    return
                }
                if score[indexindex].kakutei == false{
                    return
                }
                //ここでpad切り替え
                var uialest = UIAlertControllerStyle.Alert
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone){
                    uialest = UIAlertControllerStyle.ActionSheet
                }
                
                //アラートのインスタンスを生成
                let alert = UIAlertController(title: "\(self.score[indexindex].perEnd)回目の4射目を変更します。", message: "変更内容をセレクトしてください。\n\n\n\n\n\n\n\n\n", preferredStyle: uialest)
                
                var pickerFrame:CGRect! = nil
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone){
                    alert.modalInPopover = true
                    pickerFrame = CGRectMake(0, 0,view.frame.width - 16 - 3, self.view.frame.height - 34)
                }
                else{
                    pickerFrame = CGRectMake(alert.view.frame.origin.x,alert.view.frame.origin.y,alert.view.frame.width/3, alert.view.frame.height)
                }
                
                let picker: UIPickerView = UIPickerView(frame: pickerFrame);
                picker.delegate = self
                picker.dataSource = self
                picker.tag = 5
                alert.view.addSubview(picker)
                // AlertControllerにActionを追加
                // 基本的にはActionが追加された順序でボタンが配置される
                //ちなみに Cancelは例外的に一番下に配置される
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
                    print(action.title)
                    //ここはやることとしてはいれつinsertとSいオのイベント
                    self.score[indexindex].updatedScore_4 = self.selectpickerdata
                    
                    let i = indexindex
                    //subtotalのやつ
                    let one = { () -> Int in
                        if self.score[i].updatedScore_1 != ""{
                            
                            if self.score[i].updatedScore_1 == "X"{
                                
                                return 10
                            } else if self.score[ i].updatedScore_1 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_1)!
                            }
                            
                        }
                        else{
                            
                            if self.score[i].score_1 == "X"{
                                return 10
                            }else if self.score[i].score_1 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_1)!                }
                        }
                    }
                    let tw = { () -> Int in
                        if self.score[i].updatedScore_2 != ""{
                            
                            if self.score[ i].updatedScore_2 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_2 == "M"{
                                
                                return 0
                                
                            }else{
                                return Int(self.score[i].updatedScore_2)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_2 == "X"{
                                return 10
                            }else if self.score[i].score_2 == "M"{
                                return 0
                            }else{
                                print( self.score[i].score_2 )
                                return Int(self.score[ i].score_2)!                }
                        }
                    }
                    let th = { () -> Int in
                        if self.score[i].updatedScore_3 != ""{
                            
                            if self.score[i].updatedScore_3 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_3 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_3)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_3 == "X"{
                                return 10
                            }else if self.score[i].score_3 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_3)!                }
                        }
                    }
                    let fo = { () -> Int in
                        if self.score[i].updatedScore_4 != ""{
                            
                            if self.score[i].updatedScore_4 == "X"{
                                
                                return 10
                            } else if self.score[ i].updatedScore_4 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_4)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_4 == "X"{
                                return 10
                            }else if self.score[i].score_4 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_4)!                }
                        }
                    }
                    let fi = {() -> Int in
                        if self.score[i].updatedScore_5 != ""{
                            
                            if self.score[i].updatedScore_5 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_5 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_5)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_5 == "X"{
                                return 10
                            }else if self.score[ i].score_5 == "M"{
                                return 0
                            }else{
                                return Int(self.score[ i].score_5)!                }
                        }
                    }
                    let six = { () -> Int in
                        if self.score[i].updatedScore_6 != ""{
                            
                            if self.score[i].updatedScore_6 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_6 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_6)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_6 == "X"{
                                return 10
                            }else if self.score[i].score_6 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_6)!                }
                        }
                    }
                    let subtotal = one() + tw() + th() + fo() + fi() + six()
                    self.sumcount_Label.text = String(subtotal )
                    switch self.score[i].perEnd{
                    case 1 :
                        self.firstcount_Label.text = String(subtotal)
                    case 2:
                        self.secondcount_Lable.text = String(subtotal)
                        
                    case 3:
                        self.thirdcount_Label.text = String(subtotal)
                    case 4:
                        self.foruthcount_Label.text = String(subtotal)
                    case 5:
                        self.fifthcount_Label.text = String(subtotal)
                    case 6:
                        self.sixthcount_Label.text = String(subtotal)
                        
                    default:
                        break
                    }
                    
                    
                    
                    
                    //全てのやつ求める
                    var total:Int = 0
                    var Xcount:Int = 0
                    var tencount:Int = 0
                    var iototal = 0
                    for var count  = 0;count<self.score.count;count++ {
                        
                        
                        let one = { () -> Int in
                            if self.score[count].updatedScore_1 != ""{
                                
                                if self.score[count].updatedScore_1 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_1 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_1 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_1)!
                                }
                                
                            }
                            else{
                                if self.score[count].score_1 == "X"{
                                    return 10
                                }else if self.score[count].score_1 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_1)!
                                }
                            }
                        }
                        let tw = { () -> Int in
                            if self.score[count].updatedScore_2 != ""{
                                
                                if self.score[count].updatedScore_2 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_2 == "M"{
                                    
                                    return 0
                                    
                                }else{
                                    if self.score[count].updatedScore_2 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_2)!
                                }
                            }
                            else{
                                if self.score[count].score_2 == "X"{
                                    return 10
                                }else if self.score[count].score_2 == "M"{
                                    return 0
                                }else{
                                    
                                    return Int(self.score[count].score_2)!
                                }
                            }
                        }
                        let th = { () -> Int in
                            if self.score[count].updatedScore_3 != "" {
                                
                                if self.score[count].updatedScore_3 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_3 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_3 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_3)!
                                }
                            }else{
                                if self.score[count].score_3 == "X" {
                                    return 10
                                }else if self.score[count].score_3=="M" {
                                    return 0
                                }else{
                                    
                                    return Int(self.score[count].score_3)!                }
                            }
                        }
                        let fo = { () -> Int in
                            if self.score[count].updatedScore_4 != ""{
                                
                                if self.score[count].updatedScore_4 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_4 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_4 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_4)!
                                }
                            }
                            else{
                                if self.score[count].score_4 == "X"{
                                    return 10
                                }else if self.score[count].score_4 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_4)!                }
                            }
                        }
                        let fi = {() -> Int in
                            if self.score[count].updatedScore_5 != ""{
                                
                                if self.score[count].updatedScore_5 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_5 == "M"{
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_5 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_5)!
                                }
                            }
                            else{
                                
                                if self.score[count].score_5 == "X"{
                                    return 10
                                }else if self.score[count].score_5 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_5)!                }
                            }
                        }
                        let six = { () -> Int in
                            if self.score[count].updatedScore_6 != ""{
                                
                                if self.score[count].updatedScore_6 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_6 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_6 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_6)!
                                }
                            }
                            else{
                                
                                if self.score[count].score_6 == "X"{
                                    return 10
                                }else if self.score[count].score_6 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_6)!               }
                            }
                        }
                        total = one() + tw() + th() + fo() + fi() + six()
                        iototal += total
                        self.sumcount_Label.text = String(total)
                        switch self.score[count].perEnd{
                        case 1 :
                            self.firstcount_Label.text = String(total)
                        case 2:
                            self.secondcount_Lable.text = String(total)
                            
                        case 3:
                            self.thirdcount_Label.text = String(total)
                        case 4:
                            self.foruthcount_Label.text = String(total)
                        case 5:
                            self.fifthcount_Label.text = String(total)
                        case 6:
                            self.sixthcount_Label.text = String(total)
                            
                        default:
                            print("なにもできなかった")
                        }
                        
                        
                        
                    }
                let numin:NSDictionary = ["sc_id":self.set_sc_id,"m_id":self.get_mid,"sessionID":"sessionID=" + Utility_inputs_limit().keych_access,"updatedScore_4":self.score[indexindex].updatedScore_4,"subTotal":subtotal,"ten":tencount,"x":Xcount,"total":iototal,"perEnd":self.score[indexindex].perEnd]
                    self.socket.emit("updateScore", args:[numin] as [AnyObject])
                    self.TableView.reloadData()
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{ action in print(action.title)
                    //こっちはほじしてピッカービューのでーたけす
                    self.selectpickerdata = "M"
                }))
                
                
                // アラートを表示
                self.presentViewController(alert,
                    animated: true,
                    completion: {
                        print("Alert displayed")
                })
                
                // self.score[indexpath?.row].updatedScore_1 = //なんかで入れ込む
                //    }
                //  }
            }
        }
        
    }
    func up6_LongPressEvent(sender:UILongPressGestureRecognizer)
    {
        print("5長押しされたよ")
        if sender.state == UIGestureRecognizerState.Began {
            let p = sender.locationInView(self.TableView)
            let indexpath = self.TableView.indexPathForRowAtPoint(p)
            
            if indexpath == nil{
                print("long press on table view but not on a row")
            }else{
                
                print("long press on table view at section \(indexpath?.section) row \(indexpath?.row)")
                if score.isEmpty {
                    return
                }
                var indexindex = indexpath!.row - 1
                if score.count == self.maxPerEnd{
                    indexindex = indexpath!.row
                }
                else if cellcount-1<indexindex || !(0<=indexindex){
                    return
                }
                if score[indexindex].kakutei == false{
                    return
                }
                //ここでpad切り替え
                var uialest = UIAlertControllerStyle.Alert
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone){
                    uialest = UIAlertControllerStyle.ActionSheet
                }
                
                //アラートのインスタンスを生成
                let alert = UIAlertController(title: "\(self.score[indexindex].perEnd)回目の5射目を変更します。", message: "変更内容をセレクトしてください。\n\n\n\n\n\n\n\n\n", preferredStyle: uialest)
                
                var pickerFrame:CGRect! = nil
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone){
                    alert.modalInPopover = true
                    pickerFrame = CGRectMake(0, 0,view.frame.width - 16 - 3, self.view.frame.height - 34)
                }
                else{
                    pickerFrame = CGRectMake(alert.view.frame.origin.x,alert.view.frame.origin.y,alert.view.frame.width/3, alert.view.frame.height)
                }
                
                let picker: UIPickerView = UIPickerView(frame: pickerFrame);
                picker.delegate = self
                picker.dataSource = self
                picker.tag = 6
                alert.view.addSubview(picker)

                
                // AlertControllerにActionを追加
                // 基本的にはActionが追加された順序でボタンが配置される
                //ちなみに Cancelは例外的に一番下に配置される
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
                    print(action.title)
                    //ここはやることとしてはいれつinsertとSいオのイベント
                    self.score[indexindex].updatedScore_5 = self.selectpickerdata
                    
                    let i = indexindex
                    
                    //subtotalのやつ
                    let one = { () -> Int in
                        if self.score[i].updatedScore_1 != ""{
                            
                            if self.score[i].updatedScore_1 == "X"{
                                
                                return 10
                            } else if self.score[ i].updatedScore_1 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_1)!
                            }
                            
                        }
                        else{
                            
                            if self.score[i].score_1 == "X"{
                                return 10
                            }else if self.score[i].score_1 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_1)!                }
                        }
                    }
                    let tw = { () -> Int in
                        if self.score[i].updatedScore_2 != ""{
                            
                            if self.score[ i].updatedScore_2 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_2 == "M"{
                                
                                return 0
                                
                            }else{
                                return Int(self.score[i].updatedScore_2)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_2 == "X"{
                                return 10
                            }else if self.score[i].score_2 == "M"{
                                return 0
                            }else{
                                print( self.score[i].score_2 )
                                return Int(self.score[ i].score_2)!                }
                        }
                    }
                    let th = { () -> Int in
                        if self.score[i].updatedScore_3 != ""{
                            
                            if self.score[i].updatedScore_3 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_3 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_3)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_3 == "X"{
                                return 10
                            }else if self.score[i].score_3 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_3)!                }
                        }
                    }
                    let fo = { () -> Int in
                        if self.score[i].updatedScore_4 != ""{
                            
                            if self.score[i].updatedScore_4 == "X"{
                                
                                return 10
                            } else if self.score[ i].updatedScore_4 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_4)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_4 == "X"{
                                return 10
                            }else if self.score[i].score_4 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_4)!                }
                        }
                    }
                    let fi = {() -> Int in
                        if self.score[i].updatedScore_5 != ""{
                            
                            if self.score[i].updatedScore_5 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_5 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_5)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_5 == "X"{
                                return 10
                            }else if self.score[ i].score_5 == "M"{
                                return 0
                            }else{
                                return Int(self.score[ i].score_5)!                }
                        }
                    }
                    let six = { () -> Int in
                        if self.score[i].updatedScore_6 != ""{
                            
                            if self.score[i].updatedScore_6 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_6 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_6)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_6 == "X"{
                                return 10
                            }else if self.score[i].score_6 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_6)!                }
                        }
                    }
                    let subtotal = one() + tw() + th() + fo() + fi() + six()
                    self.sumcount_Label.text = String(subtotal)
                    switch self.score[i].perEnd{
                    case 1 :
                        self.firstcount_Label.text = String(subtotal)
                    case 2:
                        self.secondcount_Lable.text = String(subtotal)
                        
                    case 3:
                        self.thirdcount_Label.text = String(subtotal)
                    case 4:
                        self.foruthcount_Label.text = String(subtotal)
                    case 5:
                        self.fifthcount_Label.text = String(subtotal)
                    case 6:
                        self.sixthcount_Label.text = String(subtotal)
                        
                    default:
                        break
                    }
                    
                    
                    
                    
                    //全てのやつ求める
                    var total:Int = 0
                    var Xcount:Int = 0
                    var tencount:Int = 0
                    var iototal = 0
                    for var count  = 0;count<self.score.count;count++ {
                        
                        
                        let one = { () -> Int in
                            if self.score[count].updatedScore_1 != ""{
                                
                                if self.score[count].updatedScore_1 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_1 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_1 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_1)!
                                }
                                
                            }
                            else{
                                if self.score[count].score_1 == "X"{
                                    return 10
                                }else if self.score[count].score_1 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_1)!
                                }
                            }
                        }
                        let tw = { () -> Int in
                            if self.score[count].updatedScore_2 != ""{
                                
                                if self.score[count].updatedScore_2 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_2 == "M"{
                                    
                                    return 0
                                    
                                }else{
                                    if self.score[count].updatedScore_2 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_2)!
                                }
                            }
                            else{
                                if self.score[count].score_2 == "X"{
                                    return 10
                                }else if self.score[count].score_2 == "M"{
                                    return 0
                                }else{
                                    
                                    return Int(self.score[count].score_2)!
                                }
                            }
                        }
                        let th = { () -> Int in
                            if self.score[count].updatedScore_3 != "" {
                                
                                if self.score[count].updatedScore_3 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_3 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_3 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_3)!
                                }
                            }else{
                                if self.score[count].score_3 == "X" {
                                    return 10
                                }else if self.score[count].score_3=="M" {
                                    return 0
                                }else{
                                    
                                    return Int(self.score[count].score_3)!                }
                            }
                        }
                        let fo = { () -> Int in
                            if self.score[count].updatedScore_4 != ""{
                                
                                if self.score[count].updatedScore_4 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_4 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_4 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_4)!
                                }
                            }
                            else{
                                if self.score[count].score_4 == "X"{
                                    return 10
                                }else if self.score[count].score_4 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_4)!                }
                            }
                        }
                        let fi = {() -> Int in
                            if self.score[count].updatedScore_5 != ""{
                                
                                if self.score[count].updatedScore_5 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_5 == "M"{
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_5 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_5)!
                                }
                            }
                            else{
                                
                                if self.score[count].score_5 == "X"{
                                    return 10
                                }else if self.score[count].score_5 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_5)!                }
                            }
                        }
                        let six = { () -> Int in
                            if self.score[count].updatedScore_6 != ""{
                                
                                if self.score[count].updatedScore_6 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_6 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_6 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_6)!
                                }
                            }
                            else{
                                
                                if self.score[count].score_6 == "X"{
                                    return 10
                                }else if self.score[count].score_6 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_6)!               }
                            }
                        }
                        total = one() + tw() + th() + fo() + fi() + six()
                        iototal += total
                        self.sumcount_Label.text = String(total)
                        switch self.score[count].perEnd{
                        case 1 :
                            self.firstcount_Label.text = String(total)
                        case 2:
                            self.secondcount_Lable.text = String(total)
                            
                        case 3:
                            self.thirdcount_Label.text = String(total)
                        case 4:
                            self.foruthcount_Label.text = String(total)
                        case 5:
                            self.fifthcount_Label.text = String(total)
                        case 6:
                            self.sixthcount_Label.text = String(total)
                            
                        default:
                            print("なにもできなかった")
                        }
                        
                        
                        
                    }
                    
                   
                    let numin:NSDictionary = ["sc_id":self.set_sc_id,"m_id":self.get_mid,"sessionID":"sessionID=" + Utility_inputs_limit().keych_access,"updatedScore_5":self.score[indexindex].updatedScore_5,"subTotal":subtotal,"ten":tencount,"x":Xcount,"total":iototal,"perEnd":self.score[indexindex].perEnd]
                    self.socket.emit("updateScore", args:[numin] as [AnyObject])
                    self.TableView.reloadData()
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{ action in print(action.title)
                    //こっちはほじしてピッカービューのでーたけす
                    self.selectpickerdata = "M"
                }))
                
                
                // アラートを表示
                self.presentViewController(alert,
                    animated: true,
                    completion: {
                        print("Alert displayed")
                })
                
                
            }
        }
        
    }
    func up7_LongPressEvent(sender:UILongPressGestureRecognizer)
    {
        print("6長押しされたよ")
        if sender.state == UIGestureRecognizerState.Began {
            let p = sender.locationInView(self.TableView)
            let indexpath = self.TableView.indexPathForRowAtPoint(p)
            
            if indexpath == nil{
                print("long press on table view but not on a row")
            }else{
                
                print("long press on table view at section \(indexpath?.section) row \(indexpath?.row)")
                var indexindex = indexpath!.row - 1
                if score.isEmpty{
                    return
                }
                
                if score.count == self.maxPerEnd{
                    indexindex = indexpath!.row
                }
                else if cellcount-1<indexindex || !(0<=indexindex){
                    return
                }
                
                if score[indexindex].kakutei == false{
                    return
                }
                //ここでpad切り替え
                var uialest = UIAlertControllerStyle.Alert
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone){
                    uialest = UIAlertControllerStyle.ActionSheet
                }
                
                //アラートのインスタンスを生成
                let alert = UIAlertController(title: "\(self.score[indexindex].perEnd)回目の6射目を変更します。", message: "変更内容をセレクトしてください。\n\n\n\n\n\n\n\n\n", preferredStyle: uialest)
                
                var pickerFrame:CGRect! = nil
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone){
                    alert.modalInPopover = true
                    pickerFrame = CGRectMake(0, 0,view.frame.width - 16 - 3, self.view.frame.height - 34)
                }
                else{
                    pickerFrame = CGRectMake(alert.view.frame.origin.x,alert.view.frame.origin.y,alert.view.frame.width/3, alert.view.frame.height)
                }
                
                let picker: UIPickerView = UIPickerView(frame: pickerFrame);
                picker.delegate = self
                picker.dataSource = self
                picker.tag = 7
                alert.view.addSubview(picker)
                
                // AlertControllerにActionを追加
                // 基本的にはActionが追加された順序でボタンが配置される
                //ちなみに Cancelは例外的に一番下に配置される
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
                    print(action.title)
                    //ここはやることとしてはいれつinsertとSいオのイベント
                    self.score[indexindex].updatedScore_6 = self.selectpickerdata
                    
                    let i = indexindex
                    //subtotalのやつ
                    let one = { () -> Int in
                        if self.score[i].updatedScore_1 != ""{
                            
                            if self.score[i].updatedScore_1 == "X"{
                                
                                return 10
                            } else if self.score[ i].updatedScore_1 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_1)!
                            }
                            
                        }
                        else{
                            
                            if self.score[i].score_1 == "X"{
                                return 10
                            }else if self.score[i].score_1 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_1)!                }
                        }
                    }
                    let tw = { () -> Int in
                        if self.score[i].updatedScore_2 != ""{
                            
                            if self.score[ i].updatedScore_2 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_2 == "M"{
                                
                                return 0
                                
                            }else{
                                return Int(self.score[i].updatedScore_2)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_2 == "X"{
                                return 10
                            }else if self.score[i].score_2 == "M"{
                                return 0
                            }else{
                                print( self.score[i].score_2 )
                                return Int(self.score[ i].score_2)!                }
                        }
                    }
                    let th = { () -> Int in
                        if self.score[i].updatedScore_3 != ""{
                            
                            if self.score[i].updatedScore_3 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_3 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_3)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_3 == "X"{
                                return 10
                            }else if self.score[i].score_3 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_3)!                }
                        }
                    }
                    let fo = { () -> Int in
                        if self.score[i].updatedScore_4 != ""{
                            
                            if self.score[i].updatedScore_4 == "X"{
                                
                                return 10
                            } else if self.score[ i].updatedScore_4 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_4)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_4 == "X"{
                                return 10
                            }else if self.score[i].score_4 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_4)!                }
                        }
                    }
                    let fi = {() -> Int in
                        if self.score[i].updatedScore_5 != ""{
                            
                            if self.score[i].updatedScore_5 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_5 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_5)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_5 == "X"{
                                return 10
                            }else if self.score[ i].score_5 == "M"{
                                return 0
                            }else{
                                return Int(self.score[ i].score_5)!                }
                        }
                    }
                    let six = { () -> Int in
                        if self.score[i].updatedScore_6 != ""{
                            
                            if self.score[i].updatedScore_6 == "X"{
                                
                                return 10
                            } else if self.score[i].updatedScore_6 == "M"{
                                
                                return 0
                            }else{
                                return Int(self.score[i].updatedScore_6)!
                            }
                        }
                        else{
                            
                            if self.score[i].score_6 == "X"{
                                return 10
                            }else if self.score[i].score_6 == "M"{
                                return 0
                            }else{
                                return Int(self.score[i].score_6)!                }
                        }
                    }
                    let subtotal = one() + tw() + th() + fo() + fi() + six()
                    self.sumcount_Label.text = String(subtotal )
                    switch self.score[i].perEnd{
                    case 1 :
                        self.firstcount_Label.text = String(subtotal)
                    case 2:
                        self.secondcount_Lable.text = String(subtotal)
                    case 3:
                        self.thirdcount_Label.text = String(subtotal)
                    case 4:
                        self.foruthcount_Label.text = String(subtotal)
                    case 5:
                        self.fifthcount_Label.text = String(subtotal)
                    case 6:
                        self.sixthcount_Label.text = String(subtotal)
                        
                    default:
                        break
                    }
                    
                    
                    
                    
                    //全てのやつ求める
                    var total:Int = 0
                    var Xcount:Int = 0
                    var tencount:Int = 0
                    var iototal = 0
                    for var count  = 0;count<self.score.count;count++ {
                        
                        let one = { () -> Int in
                            if self.score[count].updatedScore_1 != ""{
                                
                                if self.score[count].updatedScore_1 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_1 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_1 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_1)!
                                }
                                
                            }
                            else{
                                if self.score[count].score_1 == "X"{
                                    return 10
                                }else if self.score[count].score_1 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_1)!
                                }
                            }
                        }
                        let tw = { () -> Int in
                            if self.score[count].updatedScore_2 != ""{
                                
                                if self.score[count].updatedScore_2 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_2 == "M"{
                                    
                                    return 0
                                    
                                }else{
                                    if self.score[count].updatedScore_2 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_2)!
                                }
                            }
                            else{
                                if self.score[count].score_2 == "X"{
                                    return 10
                                }else if self.score[count].score_2 == "M"{
                                    return 0
                                }else{
                                    
                                    return Int(self.score[count].score_2)!
                                }
                            }
                        }
                        let th = { () -> Int in
                            if self.score[count].updatedScore_3 != "" {
                                
                                if self.score[count].updatedScore_3 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_3 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_3 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_3)!
                                }
                            }else{
                                if self.score[count].score_3 == "X" {
                                    return 10
                                }else if self.score[count].score_3=="M" {
                                    return 0
                                }else{
                                    
                                    return Int(self.score[count].score_3)!                }
                            }
                        }
                        let fo = { () -> Int in
                            if self.score[count].updatedScore_4 != ""{
                                
                                if self.score[count].updatedScore_4 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_4 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_4 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_4)!
                                }
                            }
                            else{
                                if self.score[count].score_4 == "X"{
                                    return 10
                                }else if self.score[count].score_4 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_4)!                }
                            }
                        }
                        let fi = {() -> Int in
                            if self.score[count].updatedScore_5 != ""{
                                
                                if self.score[count].updatedScore_5 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_5 == "M"{
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_5 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_5)!
                                }
                            }
                            else{
                                
                                if self.score[count].score_5 == "X"{
                                    return 10
                                }else if self.score[count].score_5 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_5)!                }
                            }
                        }
                        let six = { () -> Int in
                            if self.score[count].updatedScore_6 != ""{
                                
                                if self.score[count].updatedScore_6 == "X"{
                                    Xcount++
                                    return 10
                                } else if self.score[count].updatedScore_6 == "M"{
                                    
                                    return 0
                                }else{
                                    if self.score[count].updatedScore_6 == "10"{
                                        tencount++
                                    }
                                    return Int(self.score[count].updatedScore_6)!
                                }
                            }
                            else{
                                
                                if self.score[count].score_6 == "X"{
                                    return 10
                                }else if self.score[count].score_6 == "M"{
                                    return 0
                                }else{
                                    return Int(self.score[count].score_6)!               }
                            }
                        }
                        total = one() + tw() + th() + fo() + fi() + six()
                        iototal+=total
                        self.sumcount_Label.text = String(total)
                        switch self.score[count].perEnd{
                        case 1 :
                            self.firstcount_Label.text = String(total)
                        case 2:
                            self.secondcount_Lable.text = String(total)
                        case 3:
                            self.thirdcount_Label.text = String(total)
                        case 4:
                            self.foruthcount_Label.text = String(total)
                        case 5:
                            self.fifthcount_Label.text = String(total)
                        case 6:
                            self.sixthcount_Label.text = String(total)
                            
                        default:
                            print("なにもできなかった")
                        }
                        
                        
                        
                    }
                    
                  
                    let numin:NSDictionary = ["sc_id":self.set_sc_id,"m_id":self.get_mid,"sessionID":"sessionID=" + Utility_inputs_limit().keych_access,"updatedScore_6":self.score[indexindex].updatedScore_6,"subTotal":subtotal,"ten":tencount,"x":Xcount,"total":iototal,"perEnd":self.score[indexindex].perEnd]
                    self.socket.emit("updateScore", args:[numin] as [AnyObject])
                    self.TableView.reloadData()
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{ action in print(action.title)
                    //こっちはほじしてピッカービューのでーたけす
                    self.selectpickerdata = "M"
                }))
                
                
                // アラートを表示
                self.presentViewController(alert,
                    animated: true,
                    completion: {
                        print("Alert displayed")
                })
                
            }
        }
        
    }
    //target
    func textField2endEvent(sender:UITextField){
        a_a = sender.text!
    }
    func textField3endEvent(sender:UITextField){
        b_a = sender.text!
    }
    func textField4endEvent(sender:UITextField){
        c_a = sender.text
    }
    func textField5endEvent(sender:UITextField){
        d_a = sender.text
    }
    func textField6endEvent(sender:UITextField){
        e_a = sender.text
    }
    func textField7endEvent(sender:UITextField){
        f_a = sender.text
        if a_a != "" && b_a != "" && c_a != "" && d_a != "" && e_a != "" && f_a != ""{
            if score.count<self.cellcount{
                self.score.insert(oldscore(score_1: a_a, score_2: b_a, score_3: c_a, score_4: d_a, score_5: e_a, score_6: f_a, updatedScore_1: "", updatedScore_2: "", updatedScore_3: "", updatedScore_4: "", updatedScore_5: "", updatedScore_6: "", subTotal: 0, perEnd: score.count, sum: 0, kakutei: false), atIndex: 0)
                visitflag = true
                
                a_a = ""
                b_a = ""
                c_a = ""
                d_a = ""
                e_a = ""
                f_a = ""
            }else {
                self.score.removeAtIndex(0)
                self.score.insert(oldscore(score_1: a_a, score_2: b_a, score_3: c_a, score_4: d_a, score_5: e_a, score_6: f_a, updatedScore_1: "", updatedScore_2: "", updatedScore_3: "", updatedScore_4: "", updatedScore_5: "", updatedScore_6: "", subTotal: 0, perEnd: score.count, sum: 0, kakutei: false), atIndex: 0)
                visitflag = true
                
                a_a = ""
                b_a = ""
                c_a = ""
                d_a = ""
                e_a = ""
                f_a = ""
            }
        }
    }
    
    // --tabelViewDatasouce
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        print("cell")
        
        let cell:cells = self.TableView.dequeueReusableCellWithIdentifier("Ccell",forIndexPath: indexPath) as! cells
        cell.textField1.text =  self.playerNumbar_textfield.text
        cell.textField.enabled = false
        cell.textField1.enabled = false
        cell.textField_up1.enabled = false
        cell.textField_up8.enabled = false
        cell.textField8.enabled = false
        /**************/
        //なんｍか
        cell.textField.text = self.lengthStr
        NSNotificationCenter.defaultCenter().addObserver(cell, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(cell, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        
        func keyboardDidHide(notification: NSNotification){
            
        }
        cell.textField2.addTarget(self, action: "textField2endEvent:", forControlEvents: UIControlEvents.EditingDidEnd)
        cell.textField3.addTarget(self, action: "textField3endEvent:", forControlEvents: UIControlEvents.EditingDidEnd)
        cell.textField4.addTarget(self, action: "textField4endEvent:", forControlEvents: UIControlEvents.EditingDidEnd)
        cell.textField5.addTarget(self, action: "textField5endEvent:", forControlEvents: UIControlEvents.EditingDidEnd)
        cell.textField6.addTarget(self, action: "textField6endEvent:", forControlEvents: UIControlEvents.EditingDidEnd)
        cell.textField7.addTarget(self, action: "textField7endEvent:", forControlEvents: UIControlEvents.EditingDidEnd)
        cell.textField2.inputView = cell.KeyboardInput
        cell.textField3.inputView = cell.KeyboardInput
        cell.textField4.inputView = cell.KeyboardInput
        cell.textField5.inputView = cell.KeyboardInput
        cell.textField6.inputView = cell.KeyboardInput
        cell.textField7.inputView = cell.KeyboardInput
        //動作のindex
        cell.KeyboardInput.one_button.tag = 1
        cell.KeyboardInput.twe_button.tag = 2
        cell.KeyboardInput.three_button.tag = 3
        cell.KeyboardInput.fo_button.tag = 4
        cell.KeyboardInput.five_button.tag = 5
        cell.KeyboardInput.six_button.tag = 6
        cell.KeyboardInput.seven_button.tag = 7
        cell.KeyboardInput.eight_button.tag = 8
        cell.KeyboardInput.nine_button.tag = 9
        cell.KeyboardInput.ten_button.tag = 10
        cell.KeyboardInput.M_button.tag = 0
        cell.KeyboardInput.X_button.tag = 11
        cell.textField1.tag = 1
        cell.textField2.tag = 2
        cell.textField3.tag = 3
        cell.textField4.tag = 4
        cell.textField5.tag = 5
        cell.textField6.tag = 6
        cell.textField7.tag = 7
        cell.textField8.tag = 8
        cell.textField_up1.tag = 11
        cell.textField_up2.tag = 12
        cell.textField_up3.tag = 13
        cell.textField_up4.tag = 14
        cell.textField_up5.tag = 15
        cell.textField_up6.tag = 16
        cell.textField_up7.tag = 17
        cell.textField_up8.tag = 18
        //未使用以外は使わせない。
        cell.textField1.enabled = false
        cell.textField8.enabled = false
        cell.textField_up1.enabled = false
        cell.textField_up2.enabled = false
        cell.textField_up3.enabled = false
        cell.textField_up4.enabled = false
        cell.textField_up5.enabled = false
        cell.textField_up6.enabled = false
        cell.textField_up7.enabled = false
        cell.KeyboardInput.one_button.addTarget(cell, action:"keyboardInputIO:" , forControlEvents: UIControlEvents.TouchUpInside)
        cell.KeyboardInput.twe_button.addTarget(cell, action:"keyboardInputIO:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.KeyboardInput.three_button.addTarget(cell, action:"keyboardInputIO:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.KeyboardInput.fo_button.addTarget(cell, action:"keyboardInputIO:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.KeyboardInput.five_button.addTarget(cell, action:"keyboardInputIO:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.KeyboardInput.six_button.addTarget(cell, action:"keyboardInputIO:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.KeyboardInput.seven_button.addTarget(cell, action:"keyboardInputIO:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.KeyboardInput.eight_button.addTarget(cell, action:"keyboardInputIO:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.KeyboardInput.nine_button.addTarget(cell, action:"keyboardInputIO:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.KeyboardInput.ten_button.addTarget(cell, action:"keyboardInputIO:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.KeyboardInput.M_button.addTarget(cell, action:"keyboardInputIO:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.KeyboardInput.X_button.addTarget(cell, action:"keyboardInputIO:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.textField1.delegate = cell
        cell.textField2.delegate = cell
        cell.textField2.delegate = cell
        cell.textField3.delegate = cell
        cell.textField4.delegate = cell
        cell.textField5.delegate = cell
        cell.textField6.delegate = cell
        cell.textField7.delegate = cell
        cell.textField8.delegate = cell
        cell.textField_up1.delegate = cell
        cell.textField_up2.delegate = cell
        cell.textField_up3.delegate = cell
        cell.textField_up4.delegate = cell
        cell.textField_up5.delegate = cell
        cell.textField_up6.delegate = cell
        cell.textField_up7.delegate = cell
        cell.textField_up8.delegate = cell
        cell.textField1.backgroundColor = UIColor.whiteColor()
        cell.textField2.backgroundColor = UIColor.whiteColor()
        cell.textField3.backgroundColor = UIColor.whiteColor()
        cell.textField4.backgroundColor = UIColor.whiteColor()
        cell.textField5.backgroundColor = UIColor.whiteColor()
        cell.textField6.backgroundColor = UIColor.whiteColor()
        cell.textField7.backgroundColor = UIColor.whiteColor()
        cell.textField8.backgroundColor = UIColor.whiteColor()
        cell.textField_up1.backgroundColor = UIColor.whiteColor()
        cell.textField_up2.backgroundColor = UIColor.whiteColor()
        cell.textField_up3.backgroundColor = UIColor.whiteColor()
        cell.textField_up4.backgroundColor = UIColor.whiteColor()
        cell.textField_up5.backgroundColor = UIColor.whiteColor()
        cell.textField_up6.backgroundColor = UIColor.whiteColor()
        cell.textField_up7.backgroundColor = UIColor.whiteColor()
        cell.textField_up8.backgroundColor = UIColor.whiteColor()
        
        
        cell.textField_up2.userInteractionEnabled = true
        cell.textField_up3.userInteractionEnabled = true
        cell.textField_up4.userInteractionEnabled = true
        cell.textField_up5.userInteractionEnabled = true
        cell.textField_up6.userInteractionEnabled = true
        cell.textField_up7.userInteractionEnabled = true
        
        
        print("nowindex:\(indexPath.row)")
        //何セット目か
        print("scorecount:\(self.score.count)")
        
        //閲覧モード
        if self.permission == false{
            let indexindexrow = indexPath.row
            self.dynamic_addcell_Button.setTitle("閲覧モード", forState: UIControlState.Normal)
            self.dynamic_addcell_Button.enabled = false
            
            cell.textField.enabled = false
            
            
            cell.textField2.enabled = false
            cell.textField3.enabled = false
            cell.textField4.enabled = false
            cell.textField5.enabled = false
            cell.textField6.enabled = false
            cell.textField7.enabled = false
            
            cell.textField_up2.enabled = false
            cell.textField_up3.enabled = false
            cell.textField_up4.enabled = false
            cell.textField_up5.enabled = false
            cell.textField_up6.enabled = false
            cell.textField_up7.enabled = false
            
            let one = { () -> Int in
                
                if self.score[indexindexrow].updatedScore_1 != ""{
                     cell.textField2.backgroundColor = UIColor.redColor()
                    if self.score[indexindexrow].updatedScore_1 == "X"{
                        cell.textField_up2.backgroundColor = UIColor.redColor()
                        return 10
                    } else if self.score[ indexindexrow].updatedScore_1 == "M"{
                        cell.textField_up2.backgroundColor = UIColor.redColor()
                        
                        return 0
                    }else{
                        cell.textField_up2.backgroundColor = UIColor.redColor()
                        return Int(self.score[indexindexrow].updatedScore_1)!
                    }
                    
                }
                else{
                     cell.textField2.backgroundColor = UIColor.whiteColor()
                    cell.textField_up2.backgroundColor = UIColor.whiteColor()
                    if self.score[indexindexrow].score_1 == "X"{
                        return 10
                    }else if self.score[ indexindexrow].score_1 == "M"{
                        return 0
                    }else{
                        return Int(self.score[indexindexrow].score_1)!                }
                }
            }
            let tw = { () -> Int in
                if self.score[indexindexrow].updatedScore_2 != ""{
                     cell.textField3.backgroundColor = UIColor.redColor()
                    if self.score[indexindexrow].updatedScore_2 == "X"{
                        cell.textField_up3.backgroundColor = UIColor.redColor()
                        return 10
                    } else if self.score[indexindexrow].updatedScore_2 == "M"{
                        cell.textField_up3.backgroundColor = UIColor.redColor()
                        return 0
                        
                    }else{
                        cell.textField_up3.backgroundColor = UIColor.redColor()
                        return Int(self.score[indexindexrow].updatedScore_2)!
                    }
                }
                else{
                    cell.textField3.backgroundColor = UIColor.whiteColor()
                    cell.textField_up3.backgroundColor = UIColor.whiteColor()
                    if self.score[indexindexrow].score_2 == "X"{
                        return 10
                    }else if self.score[indexindexrow].score_2 == "M"{
                        return 0
                    }else{
                        return Int(self.score[indexindexrow].score_2)!                }
                }
            }
            let th = { () -> Int in
                if self.score[indexindexrow].updatedScore_3 != ""{
                    cell.textField4.backgroundColor = UIColor.redColor()
                    if self.score[indexindexrow].updatedScore_3 == "X"{
                        cell.textField_up4.backgroundColor = UIColor.redColor()
                        return 10
                    } else if self.score[indexindexrow].updatedScore_3 == "M"{
                        cell.textField_up4.backgroundColor = UIColor.redColor()
                        return 0
                    }else{
                        cell.textField_up4.backgroundColor = UIColor.redColor()
                        return Int(self.score[indexindexrow].updatedScore_3)!
                    }
                }
                else{
                     cell.textField4.backgroundColor = UIColor.whiteColor()
                    cell.textField_up4.backgroundColor = UIColor.whiteColor()
                    if self.score[indexindexrow].score_3 == "X"{
                        return 10
                    }else if self.score[indexindexrow].score_3 == "M"{
                        return 0
                    }else{
                        return Int(self.score[indexindexrow].score_3)!                }
                }
            }
            let fo = { () -> Int in
                if self.score[indexindexrow].updatedScore_4 != ""{
                     cell.textField5.backgroundColor = UIColor.redColor()
                    if self.score[indexindexrow].updatedScore_4 == "X"{
                        cell.textField_up5.backgroundColor = UIColor.redColor()
                        return 10
                    } else if self.score[indexindexrow].updatedScore_4 == "M"{
                        cell.textField_up5.backgroundColor = UIColor.redColor()
                        return 0
                    }else{
                        cell.textField_up5.backgroundColor = UIColor.redColor()
                        return Int(self.score[indexindexrow].updatedScore_4)!
                    }
                }
                else{
                    cell.textField5.backgroundColor = UIColor.whiteColor()
                    cell.textField_up5.backgroundColor = UIColor.whiteColor()
                    if self.score[indexindexrow].score_4 == "X"{
                        return 10
                    }else if self.score[indexindexrow].score_4 == "M"{
                        return 0
                    }else{
                        return Int(self.score[indexindexrow].score_4)!                }
                }
            }
            let fi = {() -> Int in
                if self.score[indexindexrow].updatedScore_5 != ""{
                    cell.textField6.backgroundColor = UIColor.redColor()

                    if self.score[indexindexrow].updatedScore_5 == "X"{
                        cell.textField_up6.backgroundColor = UIColor.redColor()
                        return 10
                    } else if self.score[indexindexrow].updatedScore_5 == "M"{
                        cell.textField_up6.backgroundColor = UIColor.redColor()
                        return 0
                    }else{
                        cell.textField_up6.backgroundColor = UIColor.redColor()
                        return Int(self.score[indexindexrow].updatedScore_5)!
                    }
                }
                else{
                     cell.textField6.backgroundColor = UIColor.whiteColor()
                    cell.textField_up6.backgroundColor = UIColor.whiteColor()
                    if self.score[indexindexrow].score_5 == "X"{
                        return 10
                    }else if self.score[ indexindexrow].score_5 == "M"{
                        return 0
                    }else{
                        return Int(self.score[ indexindexrow].score_5)!                }
                }
            }
            let six = { () -> Int in
                if self.score[indexindexrow].updatedScore_6 != ""{
                    cell.textField7.backgroundColor = UIColor.redColor()
                    if self.score[ indexindexrow].updatedScore_6 == "X"{
                        cell.textField_up7.backgroundColor = UIColor.redColor()
                        return 10
                    } else if self.score[indexindexrow].updatedScore_6 == "M"{
                        cell.textField_up7.backgroundColor = UIColor.redColor()
                        return 0
                    }else{
                        cell.textField_up7.backgroundColor = UIColor.redColor()
                        return Int(self.score[indexindexrow].updatedScore_6)!
                    }
                }
                else{
                     cell.textField7.backgroundColor = UIColor.whiteColor()
                    cell.textField_up7.backgroundColor = UIColor.whiteColor()
                    if self.score[indexindexrow].score_6 == "X"{
                        return 10
                    }else if self.score[indexindexrow].score_6 == "M"{
                        return 0
                    }else{
                        return Int(self.score[indexindexrow].score_6)!                }
                }
            }
            cell.perend_Label.text = String(self.score[ indexindexrow].perEnd) + "回目"
            cell.textField2.text = self.score[indexindexrow].score_1
            cell.textField3.text = self.score[indexindexrow].score_2
            cell.textField4.text = self.score[indexindexrow].score_3
            cell.textField5.text = self.score[indexindexrow].score_4
            cell.textField6.text = self.score[indexindexrow].score_5
            cell.textField7.text = self.score[indexindexrow].score_6
            cell.textField_up2.text = self.score[indexindexrow].updatedScore_1
            cell.textField_up3.text = self.score[indexindexrow].updatedScore_2
            cell.textField_up4.text = self.score[indexindexrow].updatedScore_3
            cell.textField_up5.text = self.score[indexindexrow].updatedScore_4
            cell.textField_up6.text = self.score[indexindexrow].updatedScore_5
            cell.textField_up7.text = self.score[indexindexrow].updatedScore_6
            let total = one() + tw() + th() + fo() + fi() + six()
            
            switch self.score[indexindexrow].perEnd{
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
            
            cell.textField8.text = String(total)
            self.score[indexindexrow].sum = total
            
            var sumdata:Int = 0
            for var i = 0;i<score.count;i++ {
                sumdata += score[i].sum
            }
            
            self.sumcount_Label.text = String(sumdata)
        }
            //editモード
        else{
            playname_textfield.enabled = false
            
            OrganizationName_textfield.enabled = false
            year_mouth_day_textfield.enabled = false
            playername_textfield.enabled = false
          
            cell.textField_up1.enabled = true
            cell.textField_up2.enabled = true
            cell.textField_up3.enabled = true
            cell.textField_up4.enabled = true
            cell.textField_up5.enabled = true
            cell.textField_up6.enabled = true
            cell.textField_up7.enabled = true
            //indexpathのindex
            var mk_indexPathdata = indexPath.row-1
            //初めてやる時
            if indexPath.row == 0 && score.count == 0{
                print(indexPath.row)
                cell.perend_Label.text = String(1) + "回目"
                if indexPath.row == 0{
                    cell.textField2.enabled = true
                    cell.textField3.enabled = true
                    cell.textField4.enabled = true
                    cell.textField4.enabled = true
                    cell.textField5.enabled = true
                    cell.textField6.enabled = true
                    cell.textField7.enabled = true
                    cell.textField_up2.enabled = false
                    cell.textField_up3.enabled = false
                    cell.textField_up4.enabled = false
                    cell.textField_up5.enabled = false
                    cell.textField_up6.enabled = false
                    cell.textField_up7.enabled = false
                }
                
            }
                //一番最初のcellはcellcount回目指定
            else if (indexPath.row == 0&&score.count != self.maxPerEnd){
                print("indexPath.row\(indexPath.row)")
                cell.textField2.text = ""
                cell.textField3.text = ""
                cell.textField4.text = ""
                cell.textField5.text = ""
                cell.textField6.text = ""
                cell.textField7.text = ""
                cell.textField8.text = ""
                cell.textField_up1.text = ""
                cell.textField_up2.text = ""
                cell.textField_up3.text = ""
                cell.textField_up5.text = ""
                cell.textField_up6.text = ""
                cell.textField_up7.text = ""
                cell.textField2.enabled = true
                cell.textField3.enabled = true
                cell.textField4.enabled = true
                cell.textField4.enabled = true
                cell.textField5.enabled = true
                cell.textField6.enabled = true
                cell.textField7.enabled = true
                cell.textField_up2.enabled = false
                cell.textField_up3.enabled = false
                cell.textField_up4.enabled = false
                cell.textField_up5.enabled = false
                cell.textField_up6.enabled = false
                cell.textField_up7.enabled = false
                
                cell.perend_Label.text = String(cellcount) + "回目"
            }
                //それ以外のやつ(maxPerEndとscore数同じなら)
            else {
                //アクセスするインデックスを変換
                if (score.count == self.maxPerEnd){
                    mk_indexPathdata = indexPath.row
                }
                else if (cellcount-1<=mk_indexPathdata ){
                    mk_indexPathdata = indexPath.row
                }
                //もし確定されていて
                if self.score[mk_indexPathdata].kakutei==true&&indexPath.row != 0  {
                    cell.textField2.enabled = true
                    cell.textField3.enabled = true
                    cell.textField4.enabled = true
                    cell.textField5.enabled = true
                    cell.textField6.enabled = true
                    cell.textField7.enabled = true
                    cell.endkeyio = true
                   
                }
                if indexPath.row == 0&&cellcount == score.count  {
                    cell.textField2.enabled = true
                    cell.textField3.enabled = true
                    cell.textField4.enabled = true
                    cell.textField5.enabled = true
                    cell.textField6.enabled = true
                    cell.textField7.enabled = true
                    cell.endkeyio = true
                    
                }else if indexPath.row != 0{
                    cell.textField2.enabled = true
                    cell.textField3.enabled = true
                    cell.textField4.enabled = true
                    cell.textField5.enabled = true
                    cell.textField6.enabled = true
                    cell.textField7.enabled = true
                    cell.endkeyio = true
                    cell.textField_up1.enabled = true
                    cell.textField_up2.enabled = true
                    cell.textField_up3.enabled = true
                    cell.textField_up4.enabled = true
                    cell.textField_up5.enabled = true
                    cell.textField_up6.enabled = true
                    cell.textField_up7.enabled = true
                }
//                if indexPath.row == 0&& self.maxPerEnd == score.count {
//                    cell.textField2.enabled = true
//                    cell.textField3.enabled = true
//                    cell.textField4.enabled = true
//                    cell.textField5.enabled = true
//                    cell.textField6.enabled = true
//                    cell.textField7.enabled = true
//                    cell.endkeyio = true
//                    
//                }
                let one = { () -> Int in
                    if self.score[mk_indexPathdata].updatedScore_1 != ""{
                         cell.textField2.backgroundColor = UIColor.redColor()
                        if self.score[mk_indexPathdata].updatedScore_1 == "X"{
                            cell.textField_up2.backgroundColor = UIColor.redColor()
                            return 10
                        } else if self.score[mk_indexPathdata].updatedScore_1 == "M"{
                            cell.textField_up2.backgroundColor = UIColor.redColor()
                            
                            return 0
                        }else{
                            cell.textField_up2.backgroundColor = UIColor.redColor()
                            return Int(self.score[mk_indexPathdata].updatedScore_1)!
                        }
                        
                    }
                    else{
                        cell.textField2.backgroundColor = UIColor.whiteColor()
                        cell.textField_up2.backgroundColor = UIColor.whiteColor()
                        if self.score[mk_indexPathdata].score_1 == "X"{
                            return 10
                        }else if self.score[mk_indexPathdata].score_1 == "M"{
                            return 0
                        }else{
                            return Int(self.score[mk_indexPathdata].score_1)!                }
                    }
                }
                let tw = { () -> Int in
                    if self.score[mk_indexPathdata].updatedScore_2 != ""{
                        cell.textField3.backgroundColor = UIColor.redColor()
                        if self.score[mk_indexPathdata].updatedScore_2 == "X"{
                            cell.textField_up3.backgroundColor = UIColor.redColor()
                            return 10
                        } else if self.score[mk_indexPathdata].updatedScore_2 == "M"{
                            cell.textField_up3.backgroundColor = UIColor.redColor()
                            return 0
                            
                        }else{
                            cell.textField_up3.backgroundColor = UIColor.redColor()
                            return Int(self.score[mk_indexPathdata].updatedScore_2)!
                        }
                    }
                    else{
                        cell.textField3.backgroundColor = UIColor.whiteColor()
                        cell.textField_up3.backgroundColor = UIColor.whiteColor()
                        if self.score[mk_indexPathdata].score_2 == "X"{
                            return 10
                        }else if self.score[mk_indexPathdata].score_2 == "M"{
                            return 0
                        }else{
                            print( self.score[mk_indexPathdata].score_2 )
                            return Int(self.score[mk_indexPathdata].score_2)!                }
                    }
                }
                let th = { () -> Int in
                    if self.score[mk_indexPathdata].updatedScore_3 != ""{
                        cell.textField4.backgroundColor = UIColor.redColor()
                        if self.score[mk_indexPathdata].updatedScore_3 == "X"{
                            cell.textField_up4.backgroundColor = UIColor.redColor()
                            return 10
                        } else if self.score[mk_indexPathdata].updatedScore_3 == "M"{
                            cell.textField_up4.backgroundColor = UIColor.redColor()
                            return 0
                        }else{
                            cell.textField_up4.backgroundColor = UIColor.redColor()
                            return Int(self.score[mk_indexPathdata].updatedScore_3)!
                        }
                    }
                    else{
                        cell.textField4.backgroundColor = UIColor.whiteColor()
                        cell.textField_up4.backgroundColor = UIColor.whiteColor()
                        if self.score[mk_indexPathdata].score_3 == "X"{
                            return 10
                        }else if self.score[mk_indexPathdata].score_3 == "M"{
                            return 0
                        }else{
                            return Int(self.score[mk_indexPathdata].score_3)!                }
                    }
                }
                let fo = { () -> Int in
                    if self.score[mk_indexPathdata].updatedScore_4 != ""{
                        cell.textField5.backgroundColor = UIColor.redColor()
                        if self.score[mk_indexPathdata].updatedScore_4 == "X"{
                            cell.textField_up5.backgroundColor = UIColor.redColor()
                            return 10
                        } else if self.score[mk_indexPathdata].updatedScore_4 == "M"{
                            cell.textField_up5.backgroundColor = UIColor.redColor()
                            return 0
                        }else{
                            cell.textField_up5.backgroundColor = UIColor.redColor()
                            return Int(self.score[mk_indexPathdata].updatedScore_4)!
                        }
                    }
                    else{
                        cell.textField5.backgroundColor = UIColor.whiteColor()
                        cell.textField_up5.backgroundColor = UIColor.whiteColor()
                        if self.score[mk_indexPathdata].score_4 == "X"{
                            return 10
                        }else if self.score[mk_indexPathdata].score_4 == "M"{
                            return 0
                        }else{
                            return Int(self.score[mk_indexPathdata].score_4)!                }
                    }
                }
                let fi = {() -> Int in
                    if self.score[mk_indexPathdata].updatedScore_5 != ""{
                        cell.textField6.backgroundColor = UIColor.redColor()
                        if self.score[ mk_indexPathdata].updatedScore_5 == "X"{
                            cell.textField_up6.backgroundColor = UIColor.redColor()
                            return 10
                        } else if self.score[mk_indexPathdata].updatedScore_5 == "M"{
                            cell.textField_up6.backgroundColor = UIColor.redColor()
                            return 0
                        }else{
                            cell.textField_up6.backgroundColor = UIColor.redColor()
                            return Int(self.score[mk_indexPathdata].updatedScore_5)!
                        }
                    }
                    else{
                        cell.textField6.backgroundColor = UIColor.whiteColor()
                        cell.textField_up6.backgroundColor = UIColor.whiteColor()
                        if self.score[mk_indexPathdata].score_5 == "X"{
                            return 10
                        }else if self.score[mk_indexPathdata].score_5 == "M"{
                            return 0
                        }else{
                            return Int(self.score[mk_indexPathdata].score_5)!                }
                    }
                }
                let six = { () -> Int in
                    if self.score[mk_indexPathdata].updatedScore_6 != ""{
                          cell.textField7.backgroundColor = UIColor.redColor()
                        if self.score[mk_indexPathdata].updatedScore_6 == "X"{
                            cell.textField_up7.backgroundColor = UIColor.redColor()
                            return 10
                        } else if self.score[mk_indexPathdata].updatedScore_6 == "M"{
                            cell.textField_up7.backgroundColor = UIColor.redColor()
                            return 0
                        }else{
                            cell.textField_up7.backgroundColor = UIColor.redColor()
                            return Int(self.score[mk_indexPathdata].updatedScore_6)!
                        }
                    }
                    else{
                          cell.textField7.backgroundColor = UIColor.whiteColor()
                        cell.textField_up7.backgroundColor = UIColor.whiteColor()
                        if self.score[mk_indexPathdata].score_6 == "X"{
                            return 10
                        }else if self.score[mk_indexPathdata].score_6 == "M"{
                            return 0
                        }else{
                            return Int(self.score[mk_indexPathdata].score_6)!                }
                    }
                }
                
                //何セット目か
                print(indexPath.row)
                print(self.score.count)
                print(self.score.count-1 - indexPath.row)
                print("\(self.score[mk_indexPathdata].perEnd) 回目")
                //      print(score[mk_indexPathdata])
                cell.perend_Label.text = String(self.score[mk_indexPathdata].perEnd) + "回目"
                cell.textField2.text = self.score[mk_indexPathdata].score_1
                cell.textField3.text = self.score[mk_indexPathdata].score_2
                cell.textField4.text = self.score[mk_indexPathdata].score_3
                cell.textField5.text = self.score[mk_indexPathdata].score_4
                cell.textField6.text = self.score[mk_indexPathdata].score_5
                cell.textField7.text = self.score[mk_indexPathdata].score_6
                cell.textField_up2.text = self.score[mk_indexPathdata].updatedScore_1
                cell.textField_up3.text = self.score[mk_indexPathdata].updatedScore_2
                cell.textField_up4.text = self.score[mk_indexPathdata].updatedScore_3
                cell.textField_up5.text = self.score[mk_indexPathdata].updatedScore_4
                cell.textField_up6.text = self.score[mk_indexPathdata].updatedScore_5
                cell.textField_up7.text = self.score[mk_indexPathdata].updatedScore_6
                let total = one() + tw() + th() + fo() + fi() + six()
                
                switch self.score[mk_indexPathdata].perEnd{
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
                
                cell.textField8.text = String(total)
                
                //全てのやつ求める
                var totalio:Int = 0
                var Xcount:Int = 0
                var tencount:Int = 0
                var iototal = 0
                if self.score.isEmpty{
                    return cell
                }
                for var count  = 0;count<self.score.count;count++ {
                    
                    let one = { () -> Int in
                        if self.score[count].updatedScore_1 != ""{
                            
                            if self.score[count].updatedScore_1 == "X"{
                                Xcount++
                                return 10
                            } else if self.score[count].updatedScore_1 == "M"{
                                
                                return 0
                            }else{
                                if self.score[count].updatedScore_1 == "10"{
                                    tencount++
                                }
                                return Int(self.score[count].updatedScore_1)!
                            }
                            
                        }
                        else{
                            if self.score[count].score_1 == "X"{
                                return 10
                            }else if self.score[count].score_1 == "M"{
                                return 0
                            }else{
                                return Int(self.score[count].score_1)!
                            }
                        }
                    }
                    let tw = { () -> Int in
                        if self.score[count].updatedScore_2 != ""{
                            
                            if self.score[count].updatedScore_2 == "X"{
                                Xcount++
                                return 10
                            } else if self.score[count].updatedScore_2 == "M"{
                                
                                return 0
                                
                            }else{
                                if self.score[count].updatedScore_2 == "10"{
                                    tencount++
                                }
                                return Int(self.score[count].updatedScore_2)!
                            }
                        }
                        else{
                            if self.score[count].score_2 == "X"{
                                return 10
                            }else if self.score[count].score_2 == "M"{
                                return 0
                            }else{
                                
                                return Int(self.score[count].score_2)!
                            }
                        }
                    }
                    let th = { () -> Int in
                        if self.score[count].updatedScore_3 != "" {
                            
                            if self.score[count].updatedScore_3 == "X"{
                                Xcount++
                                return 10
                            } else if self.score[count].updatedScore_3 == "M"{
                                
                                return 0
                            }else{
                                if self.score[count].updatedScore_3 == "10"{
                                    tencount++
                                }
                                return Int(self.score[count].updatedScore_3)!
                            }
                        }else{
                            if self.score[count].score_3 == "X" {
                                return 10
                            }else if self.score[count].score_3=="M" {
                                return 0
                            }else{
                                
                                return Int(self.score[count].score_3)!                }
                        }
                    }
                    let fo = { () -> Int in
                        if self.score[count].updatedScore_4 != ""{
                            
                            if self.score[count].updatedScore_4 == "X"{
                                Xcount++
                                return 10
                            } else if self.score[count].updatedScore_4 == "M"{
                                
                                return 0
                            }else{
                                if self.score[count].updatedScore_4 == "10"{
                                    tencount++
                                }
                                return Int(self.score[count].updatedScore_4)!
                            }
                        }
                        else{
                            if self.score[count].score_4 == "X"{
                                return 10
                            }else if self.score[count].score_4 == "M"{
                                return 0
                            }else{
                                return Int(self.score[count].score_4)!                }
                        }
                    }
                    let fi = {() -> Int in
                        if self.score[count].updatedScore_5 != ""{
                            
                            if self.score[count].updatedScore_5 == "X"{
                                Xcount++
                                return 10
                            } else if self.score[count].updatedScore_5 == "M"{
                                return 0
                            }else{
                                if self.score[count].updatedScore_5 == "10"{
                                    tencount++
                                }
                                return Int(self.score[count].updatedScore_5)!
                            }
                        }
                        else{
                            
                            if self.score[count].score_5 == "X"{
                                return 10
                            }else if self.score[count].score_5 == "M"{
                                return 0
                            }else{
                                return Int(self.score[count].score_5)!                }
                        }
                    }
                    let six = { () -> Int in
                        if self.score[count].updatedScore_6 != ""{
                            
                            if self.score[count].updatedScore_6 == "X"{
                                Xcount++
                                return 10
                            } else if self.score[count].updatedScore_6 == "M"{
                                
                                return 0
                            }else{
                                if self.score[count].updatedScore_6 == "10"{
                                    tencount++
                                }
                                return Int(self.score[count].updatedScore_6)!
                            }
                        }
                        else{
                            
                            if self.score[count].score_6 == "X"{
                                return 10
                            }else if self.score[count].score_6 == "M"{
                                return 0
                            }else{
                                return Int(self.score[count].score_6)!               }
                        }
                    }
                    totalio = one() + tw() + th() + fo() + fi() + six()
                    iototal+=totalio
                   
                    switch self.score[count].perEnd{
                    case 1 :
                        self.firstcount_Label.text = String(totalio)
                    case 2:
                        self.secondcount_Lable.text = String(totalio)
                    case 3:
                        self.thirdcount_Label.text = String(totalio)
                    case 4:
                        self.foruthcount_Label.text = String(totalio)
                    case 5:
                        self.fifthcount_Label.text = String(totalio)
                    case 6:
                        self.sixthcount_Label.text = String(totalio)
                        
                    default:
                        print("なにもできなかった")
                    }
                }
                 self.sumcount_Label.text = String(iototal)
            }
            
        }
        if self.chdid == false{
            chdid = true
            self.sumcount_Label.text = String(sum)
        }
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        print("count")
        print(self.score.count)
        
        return cellcount
    }
    
    //UITextFieldDel
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField.tag == 2){
            if playerNumbar_textfield.text != ""{
                
                //アラートのインスタンスを生成
                let alert = UIAlertController(title: "確認", message: "ゼッケン名は\(playerNumbar_textfield.text!)で確定しますか？", preferredStyle: UIAlertControllerStyle.Alert)
                //Actionadd
                addActionsToAlertController_forNumbar(alert)
                // アラートを表示
                self.presentViewController(alert,
                    animated: true,
                    completion: {
                        print("Alert displayed")
                })
            }
        }
        else if textField.tag == 6{
            if prefecturesname_textfield.text != ""{
                
                //アラートのインスタンスを生成
                let alert = UIAlertController(title: "確認", message: "都道府県名は\(prefecturesname_textfield.text!)で確定しますか？", preferredStyle: UIAlertControllerStyle.Alert)
                //Actionadd
                addActionsToAlertController_forprefecturesname(alert)
                // アラートを表示
                self.presentViewController(alert,
                    animated: true,
                    completion: {
                        print("Alert displayed")
                        
                })
            }
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // AlertControllerにActionを追加
    func addActionsToAlertController_forNumbar(controller: UIAlertController) {
        // 基本的にはActionが追加された順序でボタンが配置される
        //ちなみに Cancelは例外的に一番下に配置される
        controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
            print(action.title)
            let numin:NSDictionary = ["sc_id":self.set_sc_id,"sessionID":"sessionID=" + Utility_inputs_limit().keych_access,"number":self.playerNumbar_textfield.text!]
            self.socket.emit("insertNumber", args:[numin] as [AnyObject])
            self.TableView.reloadData()
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{ action in print(action.title)}))
    }
    func addActionsToAlertController_forprefecturesname(controller: UIAlertController) {
        // 基本的にはActionが追加された順序でボタンが配置される
        //ちなみに Cancelは例外的に一番下に配置される
        controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
            print(action.title)
            let numin:NSDictionary = ["sc_id":self.set_sc_id,"sessionID":"sessionID=" + Utility_inputs_limit().keych_access,"prefectures":self.prefecturesname_textfield.text!]
            self.socket.emit("insertPrefectures", args:[numin] as [AnyObject])
            self.TableView.reloadData()
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{ action in print(action.title)}))
    }
    
    
    var setcNew = CGFloat(1)
    var setcOld = CGFloat(1)
    var countai = 0
    //cell増やす時の関数
    func addtioncell(){
        if cellcount<6{
            cellcount++
            
            
           
            self.TableView.reloadData()
            
            let now_tablesize:CGRect = self.TableView.bounds
          
            
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
               
                sizeout++
            }else{
                countai++
                self.Scroll_Layout.constant -= CGFloat(170)//ここで動く
                self.contentView_Layout.constant += CGFloat(170)//ここで動く
                
                let offset = CGFloat(170*countai)
                
                let bottomoffset = CGPointMake(0,offset+setcNew)//6,４ｓire
                print("bottomoffset\(bottomoffset)")
           
            }
        }else{
            self.TableView.reloadData()
        }
    }
    //buttonEvent
    func eventButton_add(sender:UIButton!){
        
        if self.score.count <= maxPerEnd&&self.visitflag != false {
            
            let count=0
            
            if self.visitflag == true{
                var Xcount = 0
                var tencount = 0
                
                let one = { () -> Int in
                    if self.score[count].score_1 != ""{
                        
                        if self.score[count].score_1 == "X"{
                            Xcount++
                            return 10
                        } else if self.score[count].score_1 == "M"{
                            
                            return 0
                        }else{
                            if self.score[count].score_1 == "10"{
                                tencount++
                            }
                            return Int(self.score[count].score_1)!
                        }
                        
                    }
                    else{
                        if self.score[count].score_1 == "X"{
                            return 10
                        }else if self.score[count].score_1 == "M"{
                            return 0
                        }else{
                            return Int(self.score[count].score_1)!
                        }
                    }
                }
                let tw = { () -> Int in
                    if self.score[count].score_2 != ""{
                        
                        if self.score[count].score_2 == "X"{
                            Xcount++
                            return 10
                        } else if self.score[count].score_2 == "M"{
                            
                            return 0
                            
                        }else{
                            if self.score[count].score_2 == "10"{
                                tencount++
                            }
                            return Int(self.score[count].score_2)!
                        }
                    }
                    else{
                        if self.score[count].score_2 == "X"{
                            return 10
                        }else if self.score[count].score_2 == "M"{
                            return 0
                        }else{
                            
                            return Int(self.score[count].score_2)!                }
                    }
                }
                let th = { () -> Int in
                    if self.score[count].score_3 != "" {
                        
                        if self.score[count].score_3 == "X"{
                            Xcount++
                            return 10
                        } else if self.score[count].score_3 == "M"{
                            
                            return 0
                        }else{
                            if self.score[count].score_3 == "10"{
                                tencount++
                            }
                            return Int(self.score[count].score_3)!
                        }
                    }else{
                        if self.score[count].score_3 == "X" {
                            return 10
                        }else if self.score[count].score_3=="M" {
                            return 0
                        }else{
                            
                            return Int(self.score[count].score_3)!                }
                    }
                }
                let fo = { () -> Int in
                    if self.score[count].score_4 != ""{
                        
                        if self.score[count].score_4 == "X"{
                            Xcount++
                            return 10
                        } else if self.score[count].score_4 == "M"{
                            
                            return 0
                        }else{
                            if self.score[count].score_4 == "10"{
                                tencount++
                            }
                            return Int(self.score[count].score_4)!
                        }
                    }
                    else{
                        if self.score[count].score_4 == "X"{
                            return 10
                        }else if self.score[count].score_4 == "M"{
                            return 0
                        }else{
                            return Int(self.score[count].score_4)!                }
                    }
                }
                let fi = {() -> Int in
                    if self.score[count].score_5 != ""{
                        
                        if self.score[count].score_5 == "X"{
                            Xcount++
                            return 10
                        } else if self.score[count].score_5 == "M"{
                            return 0
                        }else{
                            if self.score[count].score_5 == "10"{
                                tencount++
                            }
                            return Int(self.score[count].score_5)!
                        }
                    }
                    else{
                        
                        if self.score[count].score_5 == "X"{
                            return 10
                        }else if self.score[count].score_5 == "M"{
                            return 0
                        }else{
                            return Int(self.score[count].score_5)!                }
                    }
                }
                let six = { () -> Int in
                    if self.score[count].score_6 != ""{
                        
                        if self.score[count].score_6 == "X"{
                            Xcount++
                            return 10
                        } else if self.score[count].score_6 == "M"{
                            
                            return 0
                        }else{
                            if self.score[count].score_6 == "10"{
                                tencount++
                            }
                            return Int(self.score[count].score_6)!
                        }
                    }
                    else{
                        
                        if self.score[count].score_6 == "X"{
                            return 10
                        }else if self.score[count].score_6 == "M"{
                            return 0
                        }else{
                            return Int(self.score[count].score_6)!               }
                    }
                }
                
                let total = one() + tw() + th() + fo() + fi() + six()
                self.Tencount_Lable.text = String(Int(Tencount_Lable.text!)!+tencount)
                self.Xcount_Lable.text = String(Int(Xcount_Lable.text!)!+Xcount)
                self.sumcount_Label.text = String(total + Int(self.sumcount_Label.text!)!)
                
                self.score[count].perEnd = cellcount
                self.score[count].subTotal = total
                switch self.score[count].perEnd{
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
                let numin:NSDictionary = ["sc_id":self.set_sc_id,"m_id":self.get_mid,
                    "sessionID":"sessionID=" + Utility_inputs_limit().keych_access,
                    "perEnd":cellcount,
                    "score_1":self.score[count].score_1,
                    "score_2":self.score[count].score_2,
                    "score_3":self.score[count].score_3,
                    "score_4":self.score[count].score_4,
                    "score_5":self.score[count].score_5,
                    "score_6":self.score[count].score_6,
                    "subTotal":total,
                    "ten":Int(self.Tencount_Lable.text!)!,
                    "x":Int(Xcount_Lable.text!)!,
                    "total": Int(self.sumcount_Label.text!)!]
                self.socket.emit("insertScore", args:[numin] as [AnyObject])
                self.score[count].kakutei = true
                //追加動作
                self.addtioncell()
                self.visitflag = false
                
            }
                
            else if self.score[count].kakutei==true{
                let alert = UIAlertController(title: "確認", message: "すでに確定済みです。新しく得点をセレクトしてください。", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in print(alert.title)}))
                // アラートを表示
                self.presentViewController(alert,
                    animated: true,
                    completion: {
                        print("Alert displayed")
                })
                
            }
            
        }else {
            let alert = UIAlertController(title: "確認", message: "\(maxPerEnd)セットまでです", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in print(alert.title)}))
            // アラートを表示
            self.presentViewController(alert,
                animated: true,
                completion: {
                    print("Alert displayed")
            })
        }
        
    }

}
struct mainscore {
    var score_1:String!
    var score_2:String!
    var score_3:String!
    var score_4:String!
    var score_5:String!
    var score_6:String!
}
