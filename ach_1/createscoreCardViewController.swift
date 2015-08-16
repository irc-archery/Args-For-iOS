//
//  createscoreCardViewController.swift
//  ach_1
//
//  Created by 早坂彪流 on 2015/07/07.
//  Copyright © 2015年 早坂彪流. All rights reserved.
//

import UIKit


class createscoreCardViewController: UIViewController,UITextFieldDelegate {
    deinit{
        print("kill for createscoreCardViewController")
    }
  let URLStr = "/scoreCardIndex"
    @IBOutlet weak var myselect_button: UIButton!
    @IBOutlet weak var otherselect_button: UIButton!
    @IBOutlet weak var email_textfield: UITextField!
    @IBOutlet weak var pass_textfield: UITextField!
    @IBOutlet weak var createscore_button: UIButton!
    
    //チェックボックスのフラグ
    var myselect_flag:Bool = false
    var otherselect_button_flag:Bool = false
     private var socket:SIOSocket! = nil
    private let see = LUKeychainAccess.standardKeychainAccess().stringForKey("sessionID")
     private var indicator:MBProgressHUD! = nil
    var m_id:Int!
    var retsc_id:Int!
    var checkflag:Bool!
    var permission_of_data:Int = 0
    var checkoff:UIImage! = UIImage(named:"checkbox_off_background.png")
    var checkon:UIImage!  = UIImage(named:"checkbox_on_background.png")
    override func viewDidLoad() {
        super.viewDidLoad()
        SIOSocket.socketWithHost(Utility_inputs_limit().URLdataSet + URLStr, response:  { (_socket: SIOSocket!) in
            self.socket=_socket
            //接続の時に呼ばれる
            self.socket.onConnect = {()in
                
                print("The first SocketCall!")
            }
            //再接続の時に呼ばれる
            self.socket.onReconnect = {(attements:Int) in
                
            }
            //切断された時に呼ばれる
            self.socket.onDisconnect = {() in
                print("disconnrcted")
            }
            
        })
        self.myselect_button.addTarget(self, action: "myselect_button_event:", forControlEvents: UIControlEvents.TouchUpInside)
        self.otherselect_button.addTarget(self, action: "otherselect_button_event:", forControlEvents: UIControlEvents.TouchUpInside)
        self.createscore_button.addTarget(self, action: "createscore_event:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "CreateScoreCard_to_Cellpoint") {
            let nextViewController: cellpointViewController = segue.destinationViewController as! cellpointViewController
            nextViewController.set_sc_id = retsc_id
            nextViewController.get_mid = self.m_id
            self.socket = nil
        }
    }
    
    //mybutton_event
    func myselect_button_event(sender:UIButton){
        if myselect_flag == false{
            myselect_flag = true
            myselect_button.setImage(checkon, forState: UIControlState.Normal)
            permission_of_data = 0
            //他のを解除
            otherselect_button_flag = false
            otherselect_button.setImage(checkoff, forState: UIControlState.Normal)
            checkflag = true
            email_textfield.hidden = true
            pass_textfield.hidden = true
        }else{
            checkflag = false
            myselect_flag = false
            self.myselect_button.setImage(checkoff, forState: UIControlState.Normal)
            email_textfield.hidden = false
            pass_textfield.hidden = false
        }

    }
    func otherselect_button_event(sender:UIButton){
        if otherselect_button_flag == false{
            otherselect_button_flag = true
            otherselect_button.setImage(checkon, forState: UIControlState.Normal)
            permission_of_data = 1
            //他のを解除
            myselect_flag = false
            myselect_button.setImage(checkoff, forState: UIControlState.Normal)
            checkflag = true
            email_textfield.hidden = false
            pass_textfield.hidden = false
        }else{
            checkflag = false
            otherselect_button_flag = false
            self.otherselect_button.setImage(checkoff, forState: UIControlState.Normal)
            email_textfield.hidden = true
            pass_textfield.hidden = true
        }
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 1{
            pass_textfield.becomeFirstResponder()
        }
        return true
    }
    func createscore_event(sender:UIButton){
         let q_main: dispatch_queue_t  = dispatch_get_main_queue();
        if  myselect_flag == true{
            //自分のとき
            // アニメーションを開始する.
            self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.indicator.dimBackground = true
            self.indicator.labelText = "Loading..."
            self.indicator.labelColor = UIColor.whiteColor()
            let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)

            let senddata = ["sessionID":"sessionID=" + self.see,"m_id":m_id]
            self.socket.emit("insertOwnScoreCard", args: [senddata] as [AnyObject])
            self.socket.on("insertScoreCard") { (data:[AnyObject]!) in
                let dic:NSDictionary = data[0] as! NSDictionary
                self.retsc_id = dic["sc_id"] as? Int
                dispatch_async(q_main, {
                    timer.invalidate()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.performSegueWithIdentifier("CreateScoreCard_to_Cellpoint", sender: self)
                })
            }
            
        } else if email_textfield.text != "" && pass_textfield.text != "" && otherselect_button_flag == true{
            // アニメーションを開始する.
            self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.indicator.dimBackground = true
            self.indicator.labelText = "Loading..."
            self.indicator.labelColor = UIColor.whiteColor()
            let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)

            let senddata = ["sessionID":"sessionID=" + self.see,"m_id":m_id,"email": email_textfield.text!,"password":pass_textfield.text!]
            self.socket.emit("insertScoreCard", args: [senddata] as [AnyObject])
            self.socket.on("insertScoreCard") { (data:[AnyObject]!) in
                let dic:NSDictionary = data[0] as! NSDictionary
                self.retsc_id = dic["sc_id"] as? Int
                dispatch_async(q_main, {
                    timer.invalidate()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.performSegueWithIdentifier("CreateScoreCard_to_Cellpoint", sender: self)
                })
            }

        }else{
            //login出来ない時の処理
            let alert = UIAlertController(title: "エラー", message: "記述が足りません確認して下さい。", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ action in print(action.title)}))
            // アラートを表示
            self.presentViewController(alert,
                animated: true,
                completion: {
                    print("Alert displayed")
            })

        }
    }

}
