
//
//  createMatchviewcontroller.swift
//  ach_1
//
//  Created by 早坂彪流 on 2015/07/03.
//  Copyright © 2015年 早坂彪流. All rights reserved.
//

import UIKit
class createMatchviewcontroller: UIViewController,UITextFieldDelegate,UIToolbarDelegate,UIPickerViewDelegate {
      let URLStr = "/matchIndex"
    deinit{
        print("killcreatematchview")
    }
    var arrowsArr: NSArray = ["1","2","3","4","5","6"]
    var perendArr: NSArray = ["1","2","3","4","5","6"]
    var lengthArr: NSArray = ["90m","70m","60m","50m","40m","30m","70m前","70m後"]
    @IBOutlet weak var matchname_textfield: UITextField!
    @IBOutlet weak var sponsor_textfield: UITextField!

    @IBOutlet weak var length_textfield: UITextField!
    @IBOutlet weak var permission_full_button: UIButton!
    @IBOutlet weak var permission_local_button: UIButton!
    @IBOutlet weak var permission_local_Label: UILabel!
    
    @IBOutlet weak var gocreate_button: UIButton!
     var getm_id:Int!
      private var indicator:MBProgressHUD! = nil
     var _checkOrganization_flag:Bool! = nil
    //ツール達
    var perend_ToolBar:UIToolbar!
    var length_ToolBar:UIToolbar!
    var arrows_ToolBar:UIToolbar!
    private let see = LUKeychainAccess.standardKeychainAccess().stringForKey("sessionID")
    var socket:SIOSocket!
    private var perendPicker: UIPickerView!
    private var lengthPicker: UIPickerView!
     private var arrowsPicker: UIPickerView!
    var permission_of_data:Int = 0
    //チェックボックスのフラグ
    var full_button_flag:Bool = false
    var local_button_flag:Bool = false
    var checkOrganization_flag:Bool = false
    var checkflag:Bool = false
    var checkoff:UIImage! = UIImage(named: "checkbox_off_background.png")
    var checkon:UIImage!  = UIImage(named: "checkbox_on_background.png")

    override func viewDidLoad() {
        super.viewDidLoad()
        let q_main:dispatch_queue_t = dispatch_get_main_queue();
        SIOSocket.socketWithHost(Utility_inputs_limit().URLdataSet + URLStr, response:  { (_socket: SIOSocket!) in
            self.socket=_socket
            //接続の時に呼ばれる
            self.socket.onConnect = {()in
            
            }
            //再接続の時に呼ばれる
            self.socket.onReconnect = {(attements:Int) in
                
            }
            //切断された時に呼ばれる
            self.socket.onDisconnect = {() in
                print("disconnrcted")
            }
           
            let idjs:NSDictionary = ["sessionID":"sessionID="+Utility_inputs_limit().keych_access]
            self.socket.emit("checkOrganization", args:[idjs] as [AnyObject])
            
             self.socket.on("checkOrganization", callback: {(data:[AnyObject]!) in
                let dic:NSDictionary = (data[0] as? NSDictionary)!
                self._checkOrganization_flag = dic["belongs"] as? Bool
            
                if self._checkOrganization_flag == false{
                    dispatch_async(q_main, {
                        self.permission_local_button.hidden = true
                        self.permission_local_Label.hidden = true
                    })
                }
            })
            
        })
        //tagzuke
        matchname_textfield.tag = 1
        sponsor_textfield.tag = 2
      
        length_textfield.tag = 5
      
        permission_full_button.addTarget(self, action: "full_button_event:", forControlEvents: UIControlEvents.TouchUpInside)
        permission_local_button.addTarget(self, action: "local_button_event:", forControlEvents: UIControlEvents.TouchUpInside)
        gocreate_button.addTarget(self, action: "gocreate_event:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //PickerView作成
        perendPicker = UIPickerView()
        perendPicker.tag = 1
        perendPicker.showsSelectionIndicator = true
        perendPicker.delegate = self
        lengthPicker = UIPickerView()
        lengthPicker.showsSelectionIndicator = true
        lengthPicker.tag = 2
        lengthPicker.delegate = self
        arrowsPicker = UIPickerView()
        arrowsPicker.showsSelectionIndicator = true
        arrowsPicker.tag = 3
        arrowsPicker.delegate = self
    //Tool_perend
        perend_ToolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.width, 40))
        perend_ToolBar.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.size.height-20)
        perend_ToolBar.backgroundColor = UIColor.blackColor()
        perend_ToolBar.barStyle = UIBarStyle.Black
        perend_ToolBar.tintColor = UIColor.blackColor()
        perend_ToolBar.delegate = self
    //Tool_length
        length_ToolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.width, 40))
        length_ToolBar.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.size.height-20)
        length_ToolBar.backgroundColor = UIColor.blackColor()
        length_ToolBar.barStyle = UIBarStyle.Black
        length_ToolBar.tintColor = UIColor.blackColor()
        length_ToolBar.delegate = self
    //Tool_arrows
        arrows_ToolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.width, 40))
        arrows_ToolBar.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.size.height-20)
        arrows_ToolBar.backgroundColor = UIColor.blackColor()
        arrows_ToolBar.barStyle = UIBarStyle.Black
        arrows_ToolBar.tintColor = UIColor.blackColor()
        arrows_ToolBar.delegate = self
    
        
        
        
        //閉じるボタンを追加など
        let length_ToolBarButton = UIBarButtonItem(title: "close", style: UIBarButtonItemStyle.Done, target: self, action: "length_onClick_close:")
        length_ToolBarButton.tag = 1
        length_ToolBarButton.tintColor = UIColor.whiteColor()
        length_ToolBar.items = [length_ToolBarButton]
        length_textfield.inputView = lengthPicker
        length_textfield.inputAccessoryView = length_ToolBar
        
        matchname_textfield.becomeFirstResponder()

        length_textfield.text = lengthArr[0] as? String
    }
    override func viewWillDisappear(animated: Bool) {
    }

    //arrows_textfield
    //perend_textfield
    //length_textfieldのためのもの↓
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 1{
            sponsor_textfield.becomeFirstResponder()
        }else if textField.tag == 2{
            length_textfield.becomeFirstResponder()
        }
              return true
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return perendArr.count
        }else if pickerView.tag == 3{
            return arrowsArr.count
        }else{
            return lengthArr.count
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            return perendArr[row] as? String
        }else if pickerView.tag == 3{
            return arrowsArr[row] as? String
        }else {
            return lengthArr[row] as? String
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

            if pickerView.tag == 2{
            self.length_textfield.text = self.lengthArr[row] as? String
        }
    }
    
    //toolbarのボタンイベントたち
    func length_onClick_close(sender:AnyObject){
        length_textfield.resignFirstResponder()
    }
    func perend_onClick_close(sender:AnyObject){
       // perend_textfield.resignFirstResponder()
    }
    func arrows_onClick_close(sender:AnyObject){
     //   arrows_textfield.resignFirstResponder()
    }
    func perend_onClick_next(sender:AnyObject){
        length_textfield.becomeFirstResponder()
    }
    func arrows_onClick_next(sender:AnyObject){
      //  perend_textfield.becomeFirstResponder()
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
    //buttonclickevent
    func gocreate_event(sender:UIButton){
        let q_main: dispatch_queue_t  = dispatch_get_main_queue();
        if matchname_textfield.text != "" && sponsor_textfield.text != "" &&  length_textfield.text != ""&&checkflag==true{
            
            // アニメーションを開始する.
            self.indicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.indicator.dimBackground = true
            self.indicator.labelText = "Loading..."
            self.indicator.labelColor = UIColor.whiteColor()
            let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)
            let seeR = "sessionID=" + self.see
            let mn = matchname_textfield.text!
            let sp = sponsor_textfield.text!

            let arrow:Int = 6
            let perEnd:Int = 6

            var length :Int = 0
            switch length_textfield.text!{
            case"90m":
                length = 0
            case"70m":
                length = 1
            case"60m":
                length = 2
            case"50m":
                length = 3
            case"40m":
                length = 4
            case"30m":
                length = 5
            case"70m前":
                length = 6
            case"70m後":
                length = 7
            default:
                break
            }
            
            let per = permission_of_data
            //データを付属させる
            let emdata:[String:AnyObject] = ["sessionID":seeR, "matchName":mn, "sponsor":sp,
                "arrows":arrow, "perEnd":perEnd, "length":length, "permission":per]
          checkflag = false
          self.socket.emit("insertMatch", args: [emdata] )
            
            self.socket.on("insertMatch", callback: {(data:[AnyObject]!)in
                
                let  dic = data[0] as! NSDictionary
                let cre_data_id = dic["m_id"] as! Int
                self.getm_id = cre_data_id
                dispatch_async(q_main, {
                    timer.invalidate()
                     MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.performSegueWithIdentifier("creatematch_ to_siitra", sender: self)

                })
                
            })
            
            
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
    func full_button_event(sender:UIButton){
        
        if full_button_flag == false{
            full_button_flag = true
            permission_full_button.setImage(checkon, forState: UIControlState.Normal)
            permission_of_data = 0
            
            //他のを解除
            local_button_flag = false
            permission_local_button.setImage(checkoff, forState: UIControlState.Normal)
            checkflag = true
        }else{
            checkflag = false
            full_button_flag = false
            self.permission_full_button.setImage(checkoff, forState: UIControlState.Normal)
        }
        
    }
    func local_button_event(sender:UIButton){
        if _checkOrganization_flag == true{
            if local_button_flag == false{
                local_button_flag = true
                permission_local_button.setImage(checkon, forState: UIControlState.Normal)
                permission_of_data = 1
                //他のを解除
                full_button_flag = false
                permission_full_button.setImage(checkoff, forState: UIControlState.Normal)
                checkflag = true
            }else{
                checkflag = false
                local_button_flag = false
                self.permission_local_button.setImage(checkoff, forState: UIControlState.Normal)
            }
        }
    }
    //画面タッチのイベント(フォーカス戻すやつ)
    @IBAction func uptapevent(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "unwind_seg") {
       
        }else if segue.identifier == "creatematch_ to_siitra"{
             let nextViewController: siitira_ViewController = segue.destinationViewController as! siitira_ViewController
            nextViewController.pleyid = getm_id
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
