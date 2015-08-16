//
//  CustomKeyboardInputView.swift
//  cell6_i
//
//  Created by 早坂彪流 on 2015/05/09.
//  Copyright (c) 2015年 TakeruHayasaka. All rights reserved.
//

import UIKit

class CustomKeyboardInputView: UIView {

    @IBOutlet weak var M_button: UIButton!
    
    @IBOutlet weak var one_button: UIButton!
    
    @IBOutlet weak var twe_button: UIButton!
    @IBOutlet weak var three_button: UIButton!
    
    @IBOutlet weak var fo_button: UIButton!
    
    @IBOutlet weak var five_button: UIButton!
    
    @IBOutlet weak var six_button: UIButton!
    @IBOutlet weak var seven_button: UIButton!
    @IBOutlet weak var eight_button: UIButton!
    @IBOutlet weak var nine_button: UIButton!
    @IBOutlet weak var ten_button: UIButton!
    @IBOutlet weak var X_button: UIButton!
    //シングルトン
       class func instance() -> CustomKeyboardInputView {
        return UINib(nibName: "CustomKeyboardInputView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! CustomKeyboardInputView
    }
}
