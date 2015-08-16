//
//  cell.swift
//  cell6_i
//
//  Created by 早坂彪流 on 2015/05/01.
//  Copyright (c) 2015年 TakeruHayasaka. All rights reserved.
//

import UIKit

class cells: UITableViewCell,UITextFieldDelegate{
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var perend_Label: UILabel!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var textField7: UITextField!
    @IBOutlet weak var textField8: UITextField!
   
    @IBOutlet weak var textField_up1: UITextField!
    @IBOutlet weak var textField_up2: UITextField!
    @IBOutlet weak var textField_up3: UITextField!
    @IBOutlet weak var textField_up4: UITextField!
    @IBOutlet weak var textField_up5: UITextField!
    @IBOutlet weak var textField_up6: UITextField!
    @IBOutlet weak var textField_up7: UITextField!
    @IBOutlet weak var textField_up8: UITextField!
   
    
    var endkeyio:Bool! = false
    
    var KeyboardInput:CustomKeyboardInputView! = CustomKeyboardInputView.instance()
    //入力されたりのフラグ
    var ja_flag = [Bool](count: 19, repeatedValue: false)
    //入力したかどうかのフラグ
    var write_flag:Bool = false
    //buttonのハンドラ
    func keyboardInputIO(sender:UIButton){
        
        if write_flag == false{
            textField2.becomeFirstResponder()
        }
        
        if sender.tag == 1{
            if ja_flag[1] == true{ textField1.text = "1"
                ja_flag[1] = false
                
            }
            else if ja_flag[2] == true{ textField2.text = "1"
                ja_flag[2] = false
                write_flag = true
                textField3.becomeFirstResponder()
            }
            else if ja_flag[3] == true{ textField3.text = "1"
                ja_flag[3] = false
                textField4.becomeFirstResponder()
            }
            else if ja_flag[4] == true{ textField4.text = "1"
                ja_flag[4] = false
                textField5.becomeFirstResponder()
            }
            else if ja_flag[5] == true{ textField5.text = "1"
                ja_flag[5] = false
                textField6.becomeFirstResponder()
            }
            else if ja_flag[6] == true{ textField6.text = "1"
                ja_flag[6] = false
                textField7.becomeFirstResponder()
            }
            else if ja_flag[7] == true{ textField7.text = "1"
                ja_flag[7] == false
                write_flag = false
                textField7.resignFirstResponder()
                var point = [Int](count: 6, repeatedValue: 0)
                if textField2.text == "X"{
                    point[0] = 10
                }else if textField2.text == "M"{
                    point [0] = 0
                }else {
                    point[0] = Int(textField2.text!)!
                }
                if textField3.text == "X"{
                    point[1] = 10
                }else if textField3.text == "M"{
                    point [1] = 0
                }else {
                    point[1] = Int(textField3.text!)!
                }
                if textField4.text == "X"{
                    point[2] = 10
                }else if textField4.text == "M"{
                    point [2] = 0
                }else {
                    point[2] = Int(textField4.text!)!
                }
                if textField5.text == "X"{
                    point[3] = 10
                }else if textField5.text == "M"{
                    point [3] = 0
                }else {
                    point[3] = Int(textField5.text!)!
                }
                if textField6.text == "X"{
                    point[4] = 10
                }else if textField6.text == "M"{
                    point [4] = 0
                }else {
                    point[4] = Int(textField6.text!)!
                }
                if textField7.text == "X"{
                    point[5] = 10
                }else if textField7.text == "M"{
                    point [5] = 0
                }else {
                    point[5] = Int(textField7.text!)!
                }
                let total = point[0] + point[1] + point[2] + point[3] + point[4] + point[5]
                textField8.text = String(total)
            }
            else if ja_flag[8] == true{textField8.text = "1"
                ja_flag[8] = false
            }
            else if ja_flag[11] == true{textField_up1.text = "1"
                ja_flag[11] = false
            }
            else if ja_flag[12] == true{textField_up2.text = "1"
                ja_flag[12] = false
            }
            else if ja_flag[13] == true{textField_up3.text = "1"
                ja_flag[13] = false
            }
            else if ja_flag[14] == true{textField_up4.text = "1"
                ja_flag[14] = false
            }
            else if ja_flag[15] == true{textField_up5.text = "1"
                ja_flag[15] = false
            }
            else if ja_flag[16] == true{textField_up6.text = "1"
                ja_flag[16] = false
            }
            else if ja_flag[17] == true{textField_up7.text = "1"
                ja_flag[17] = false
            }
            else if ja_flag[18] == true{textField_up8.text = "1"
                ja_flag[18] = false
            }
        }
        else if sender.tag == 2{
            if ja_flag[1] == true{ textField1.text = "2"
                ja_flag[1] = false
                
            }
            else if ja_flag[2] == true{ textField2.text = "2"
                ja_flag[2] = false
                write_flag = true
                textField3.becomeFirstResponder()
            }
            else if ja_flag[3] == true{ textField3.text = "2"
                ja_flag[3] = false
                textField4.becomeFirstResponder()
            }
            else if ja_flag[4] == true{ textField4.text = "2"
                ja_flag[4] = false
                textField5.becomeFirstResponder()
            }
            else if ja_flag[5] == true{ textField5.text = "2"
                ja_flag[5] = false
                textField6.becomeFirstResponder()
            }
            else if ja_flag[6] == true{ textField6.text = "2"
                ja_flag[6] = false
                textField7.becomeFirstResponder()
            }
            else if ja_flag[7] == true{ textField7.text = "2"
                ja_flag[7] = false
                textField7.resignFirstResponder()
                var point = [Int](count: 6, repeatedValue: 0)
                if textField2.text == "X"{
                    point[0] = 10
                }else if textField2.text == "M"{
                    point [0] = 0
                }else {
                    point[0] = Int(textField2.text!)!
                }
                if textField3.text == "X"{
                    point[1] = 10
                }else if textField3.text == "M"{
                    point [1] = 0
                }else {
                    point[1] = Int(textField3.text!)!
                }
                if textField4.text == "X"{
                    point[2] = 10
                }else if textField4.text == "M"{
                    point [2] = 0
                }else {
                    point[2] = Int(textField4.text!)!
                }
                if textField5.text == "X"{
                    point[3] = 10
                }else if textField5.text == "M"{
                    point [3] = 0
                }else {
                    point[3] = Int(textField5.text!)!
                }
                if textField6.text == "X"{
                    point[4] = 10
                }else if textField6.text == "M"{
                    point [4] = 0
                }else {
                    point[4] = Int(textField6.text!)!
                }
                if textField7.text == "X"{
                    point[5] = 10
                }else if textField7.text == "M"{
                    point [5] = 0
                }else {
                    point[5] = Int(textField7.text!)!
                }
                let total = point[0] + point[1] + point[2] + point[3] + point[4] + point[5]
                textField8.text = String(total)
            }
            else if ja_flag[8] == true{textField8.text = "2"
                ja_flag[8] = false
            }
            else if ja_flag[11] == true{textField_up1.text = "2"
                ja_flag[11] = false
            }
            else if ja_flag[12] == true{textField_up2.text = "2"
                ja_flag[12] = false
            }
            else if ja_flag[13] == true{textField_up3.text = "2"
                ja_flag[13] = false
            }
            else if ja_flag[14] == true{textField_up4.text = "2"
                ja_flag[14] = false
            }
            else if ja_flag[15] == true{textField_up5.text = "2"
                ja_flag[15] = false
            }
            else if ja_flag[16] == true{textField_up6.text = "2"
                ja_flag[16] = false
            }
            else if ja_flag[17] == true{textField_up7.text = "2"
                ja_flag[17] = false
            }
            else if ja_flag[18] == true{textField_up8.text = "2"
                ja_flag[18] = false
            }
            
        }
        else if sender.tag == 3{
            if ja_flag[1] == true{ textField1.text = "3"
                ja_flag[1] = false
                
            }
            else if ja_flag[2] == true{ textField2.text = "3"
                ja_flag[2] = false
                write_flag = true
                textField3.becomeFirstResponder()
            }
            else if ja_flag[3] == true{ textField3.text = "3"
                ja_flag[3] = false
                textField4.becomeFirstResponder()
            }
            else if ja_flag[4] == true{ textField4.text = "3"
                ja_flag[4] = false
                textField5.becomeFirstResponder()
            }
            else if ja_flag[5] == true{ textField5.text = "3"
                ja_flag[5] = false
                textField6.becomeFirstResponder()
            }
            else if ja_flag[6] == true{ textField6.text = "3"
                ja_flag[6] = false
                textField7.becomeFirstResponder()
            }
            else if ja_flag[7] == true{ textField7.text = "3"
                ja_flag[7] = false
                write_flag = false
                textField7.resignFirstResponder()
                var point = [Int](count: 6, repeatedValue: 0)
                if textField2.text == "X"{
                    point[0] = 10
                }else if textField2.text == "M"{
                    point [0] = 0
                }else {
                    point[0] = Int(textField2.text!)!
                }
                if textField3.text == "X"{
                    point[1] = 10
                }else if textField3.text == "M"{
                    point [1] = 0
                }else {
                    point[1] = Int(textField3.text!)!
                }
                if textField4.text == "X"{
                    point[2] = 10
                }else if textField4.text == "M"{
                    point [2] = 0
                }else {
                    point[2] = Int(textField4.text!)!
                }
                if textField5.text == "X"{
                    point[3] = 10
                }else if textField5.text == "M"{
                    point [3] = 0
                }else {
                    point[3] = Int(textField5.text!)!
                }
                if textField6.text == "X"{
                    point[4] = 10
                }else if textField6.text == "M"{
                    point [4] = 0
                }else {
                    point[4] = Int(textField6.text!)!
                }
                if textField7.text == "X"{
                    point[5] = 10
                }else if textField7.text == "M"{
                    point [5] = 0
                }else {
                    point[5] = Int(textField7.text!)!
                }
                let total = point[0] + point[1] + point[2] + point[3] + point[4] + point[5]
                textField8.text = String(total)
            }
            else if ja_flag[8] == true{textField8.text = "3"
                ja_flag[8] = false
            }
            else if ja_flag[11] == true{textField_up1.text = "3"
                ja_flag[11] = false
            }
            else if ja_flag[12] == true{textField_up2.text = "3"
                ja_flag[12] = false
            }
            else if ja_flag[13] == true{textField_up3.text = "3"
                ja_flag[13] = false
            }
            else if ja_flag[14] == true{textField_up4.text = "3"
                ja_flag[14] = false
            }
            else if ja_flag[15] == true{textField_up5.text = "3"
                ja_flag[15] = false
            }
            else if ja_flag[16] == true{textField_up6.text = "3"
                ja_flag[16] = false
            }
            else if ja_flag[17] == true{textField_up7.text = "3"
                ja_flag[17] = false
            }
            else if ja_flag[18] == true{textField_up8.text = "3"
                ja_flag[18] = false
            }
            
        }
        else if sender.tag == 4{
            if ja_flag[1] == true{ textField1.text = "4"
                ja_flag[1] = false
                
            }
            else if ja_flag[2] == true{ textField2.text = "4"
                ja_flag[2] = false
                write_flag = true
                textField3.becomeFirstResponder()
            }
            else if ja_flag[3] == true{ textField3.text = "4"
                ja_flag[3] = false
                textField4.becomeFirstResponder()
            }
            else if ja_flag[4] == true{ textField4.text = "4"
                ja_flag[4] = false
                textField5.becomeFirstResponder()
            }
            else if ja_flag[5] == true{ textField5.text = "4"
                ja_flag[5] = false
                textField6.becomeFirstResponder()
            }
            else if ja_flag[6] == true{ textField6.text = "4"
                ja_flag[6] = false
                textField7.becomeFirstResponder()
            }
            else if ja_flag[7] == true{ textField7.text = "4"
                ja_flag[7] = false
                write_flag = false
                textField7.resignFirstResponder()
            }
            else if ja_flag[8] == true{textField8.text = "4"
                ja_flag[8] = false
            }
            else if ja_flag[11] == true{textField_up1.text = "4"
                ja_flag[11] = false
            }
            else if ja_flag[12] == true{textField_up2.text = "4"
                ja_flag[12] = false
            }
            else if ja_flag[13] == true{textField_up3.text = "4"
                ja_flag[13] = false
            }
            else if ja_flag[14] == true{textField_up4.text = "4"
                ja_flag[14] = false
            }
            else if ja_flag[15] == true{textField_up5.text = "4"
                ja_flag[15] = false
            }
            else if ja_flag[16] == true{textField_up6.text = "4"
                ja_flag[16] = false
            }
            else if ja_flag[17] == true{textField_up7.text = "4"
                ja_flag[17] = false
            }
            else if ja_flag[18] == true{textField_up8.text = "4"
                ja_flag[18] = false
            }
            
        }
        else if sender.tag == 5{
            
            
            if ja_flag[1] == true{ textField1.text = "5"
                ja_flag[1] = false
                
            }
            else if ja_flag[2] == true{ textField2.text = "5"
                ja_flag[2] = false
                write_flag = true
                textField3.becomeFirstResponder()
            }
            else if ja_flag[3] == true{ textField3.text = "5"
                ja_flag[3] = false
                textField4.becomeFirstResponder()
            }
            else if ja_flag[4] == true{ textField4.text = "5"
                ja_flag[4] = false
                textField5.becomeFirstResponder()
            }
            else if ja_flag[5] == true{ textField5.text = "5"
                ja_flag[5] = false
                textField6.becomeFirstResponder()
            }
            else if ja_flag[6] == true{ textField6.text = "5"
                ja_flag[6] = false
                textField7.becomeFirstResponder()
            }
            else if ja_flag[7] == true{ textField7.text = "5"
                ja_flag[7] = false
                write_flag = false
                textField7.resignFirstResponder()
                var point = [Int](count: 6, repeatedValue: 0)
                if textField2.text == "X"{
                    point[0] = 10
                }else if textField2.text == "M"{
                    point [0] = 0
                }else {
                    point[0] = Int(textField2.text!)!
                }
                if textField3.text == "X"{
                    point[1] = 10
                }else if textField3.text == "M"{
                    point [1] = 0
                }else {
                    point[1] = Int(textField3.text!)!
                }
                if textField4.text == "X"{
                    point[2] = 10
                }else if textField4.text == "M"{
                    point [2] = 0
                }else {
                    point[2] = Int(textField4.text!)!
                }
                if textField5.text == "X"{
                    point[3] = 10
                }else if textField5.text == "M"{
                    point [3] = 0
                }else {
                    point[3] = Int(textField5.text!)!
                }
                if textField6.text == "X"{
                    point[4] = 10
                }else if textField6.text == "M"{
                    point [4] = 0
                }else {
                    point[4] = Int(textField6.text!)!
                }
                if textField7.text == "X"{
                    point[5] = 10
                }else if textField7.text == "M"{
                    point [5] = 0
                }else {
                    point[5] = Int(textField7.text!)!
                }
                let total = point[0] + point[1] + point[2] + point[3] + point[4] + point[5]
                textField8.text = String(total)
            }
            else if ja_flag[8] == true{textField8.text = "5"
                ja_flag[8] = false
            }
            else if ja_flag[11] == true{textField_up1.text = "5"
                ja_flag[11] = false
            }
            else if ja_flag[12] == true{textField_up2.text = "5"
                ja_flag[12] = false
            }
            else if ja_flag[13] == true{textField_up3.text = "5"
                ja_flag[13] = false
            }
            else if ja_flag[14] == true{textField_up4.text = "5"
                ja_flag[14] = false
            }
            else if ja_flag[15] == true{textField_up5.text = "5"
                ja_flag[15] = false
            }
            else if ja_flag[16] == true{textField_up6.text = "5"
                ja_flag[16] = false
            }
            else if ja_flag[17] == true{textField_up7.text = "5"
                ja_flag[17] = false
            }
            else if ja_flag[18] == true{textField_up8.text = "5"
                ja_flag[18] = false
            }
            
        }
        else if sender.tag == 6{
            if ja_flag[1] == true{ textField1.text = "6"
                ja_flag[1] = false
            }
            else if ja_flag[2] == true{ textField2.text = "6"
                ja_flag[2] = false
                write_flag = true
                textField3.becomeFirstResponder()
            }
            else if ja_flag[3] == true{ textField3.text = "6"
                ja_flag[3] = false
                textField4.becomeFirstResponder()
            }
            else if ja_flag[4] == true{ textField4.text = "6"
                ja_flag[4] = false
                textField5.becomeFirstResponder()
            }
            else if ja_flag[5] == true{ textField5.text = "6"
                ja_flag[5] = false
                textField6.becomeFirstResponder()
            }
            else if ja_flag[6] == true{ textField6.text = "6"
                ja_flag[6] = false
                textField7.becomeFirstResponder()
            }
            else if ja_flag[7] == true{ textField7.text = "6"
                ja_flag[7] = false
                write_flag = false
                textField7.resignFirstResponder()
                var point = [Int](count: 6, repeatedValue: 0)
                if textField2.text == "X"{
                    point[0] = 10
                }else if textField2.text == "M"{
                    point [0] = 0
                }else {
                    point[0] = Int(textField2.text!)!
                }
                if textField3.text == "X"{
                    point[1] = 10
                }else if textField3.text == "M"{
                    point [1] = 0
                }else {
                    point[1] = Int(textField3.text!)!
                }
                if textField4.text == "X"{
                    point[2] = 10
                }else if textField4.text == "M"{
                    point [2] = 0
                }else {
                    point[2] = Int(textField4.text!)!
                }
                if textField5.text == "X"{
                    point[3] = 10
                }else if textField5.text == "M"{
                    point [3] = 0
                }else {
                    point[3] = Int(textField5.text!)!
                }
                if textField6.text == "X"{
                    point[4] = 10
                }else if textField6.text == "M"{
                    point [4] = 0
                }else {
                    point[4] = Int(textField6.text!)!
                }
                if textField7.text == "X"{
                    point[5] = 10
                }else if textField7.text == "M"{
                    point [5] = 0
                }else {
                    point[5] = Int(textField7.text!)!
                }
                let total = point[0] + point[1] + point[2] + point[3] + point[4] + point[5]
                textField8.text = String(total)
            }
            else if ja_flag[8] == true{textField8.text = "6"
                ja_flag[8] = false
            }
            else if ja_flag[11] == true{textField_up1.text = "6"
                ja_flag[11] = false
            }
            else if ja_flag[12] == true{textField_up2.text = "6"
                ja_flag[12] = false
            }
            else if ja_flag[13] == true{textField_up3.text = "6"
                ja_flag[13] = false
            }
            else if ja_flag[14] == true{textField_up4.text = "6"
                ja_flag[14] = false
            }
            else if ja_flag[15] == true{textField_up5.text = "6"
                ja_flag[15] = false
            }
            else if ja_flag[16] == true{textField_up6.text = "6"
                ja_flag[16] = false
            }
            else if ja_flag[17] == true{textField_up7.text = "6"
                ja_flag[17] = false
            }
            else if ja_flag[18] == true{textField_up8.text = "6"
                ja_flag[18] = false
            }
            
        }
        else if sender.tag == 7{
            if ja_flag[1] == true{ textField1.text = "7"
                ja_flag[1] = false
                
            }
            else if ja_flag[2] == true{ textField2.text = "7"
                ja_flag[2] = false
                write_flag = true
                textField3.becomeFirstResponder()
            }
            else if ja_flag[3] == true{ textField3.text = "7"
                ja_flag[3] = false
                textField4.becomeFirstResponder()
            }
            else if ja_flag[4] == true{ textField4.text = "7"
                ja_flag[4] = false
                textField5.becomeFirstResponder()
            }
            else if ja_flag[5] == true{ textField5.text = "7"
                ja_flag[5] = false
                textField6.becomeFirstResponder()
            }
            else if ja_flag[6] == true{ textField6.text = "7"
                ja_flag[6] = false
                textField7.becomeFirstResponder()
            }
            else if ja_flag[7] == true{ textField7.text = "7"
                ja_flag[7] = false
                write_flag = false
                textField7.resignFirstResponder()
                var point = [Int](count: 6, repeatedValue: 0)
                if textField2.text == "X"{
                    point[0] = 10
                }else if textField2.text == "M"{
                    point [0] = 0
                }else {
                    point[0] = Int(textField2.text!)!
                }
                if textField3.text == "X"{
                    point[1] = 10
                }else if textField3.text == "M"{
                    point [1] = 0
                }else {
                    point[1] = Int(textField3.text!)!
                }
                if textField4.text == "X"{
                    point[2] = 10
                }else if textField4.text == "M"{
                    point [2] = 0
                }else {
                    point[2] = Int(textField4.text!)!
                }
                if textField5.text == "X"{
                    point[3] = 10
                }else if textField5.text == "M"{
                    point [3] = 0
                }else {
                    point[3] = Int(textField5.text!)!
                }
                if textField6.text == "X"{
                    point[4] = 10
                }else if textField6.text == "M"{
                    point [4] = 0
                }else {
                    point[4] = Int(textField6.text!)!
                }
                if textField7.text == "X"{
                    point[5] = 10
                }else if textField7.text == "M"{
                    point [5] = 0
                }else {
                    point[5] = Int(textField7.text!)!
                }
                let total = point[0] + point[1] + point[2] + point[3] + point[4] + point[5]
                textField8.text = String(total)
            }
            else if ja_flag[8] == true{textField8.text = "7"
                ja_flag[8] = false
            }
            else if ja_flag[11] == true{textField_up1.text = "7"
                ja_flag[11] = false
            }
            else if ja_flag[12] == true{textField_up2.text = "7"
                ja_flag[12] = false
            }
            else if ja_flag[13] == true{textField_up3.text = "7"
                ja_flag[13] = false
            }
            else if ja_flag[14] == true{textField_up4.text = "7"
                ja_flag[14] = false
            }
            else if ja_flag[15] == true{textField_up5.text = "7"
                ja_flag[15] = false
            }
            else if ja_flag[16] == true{textField_up6.text = "7"
                ja_flag[16] = false
            }
            else if ja_flag[17] == true{textField_up7.text = "7"
                ja_flag[17] = false
            }
            else if ja_flag[18] == true{textField_up8.text = "7"
                ja_flag[18] = false
            }
            
        }
        else if sender.tag == 8{
            if ja_flag[1] == true{ textField1.text = "8"
                ja_flag[1] = false
                
            }
            else if ja_flag[2] == true{ textField2.text = "8"
                ja_flag[2] = false
                write_flag = true
                textField3.becomeFirstResponder()
            }
            else if ja_flag[3] == true{ textField3.text = "8"
                ja_flag[3] = false
                textField4.becomeFirstResponder()
            }
            else if ja_flag[4] == true{ textField4.text = "8"
                ja_flag[4] = false
                textField5.becomeFirstResponder()
            }
            else if ja_flag[5] == true{ textField5.text = "8"
                ja_flag[5] = false
                textField6.becomeFirstResponder()
            }
            else if ja_flag[6] == true{ textField6.text = "8"
                ja_flag[6] = false
                textField7.becomeFirstResponder()
            }
            else if ja_flag[7] == true{ textField7.text = "8"
                ja_flag[7] = false
                write_flag = false
                textField7.resignFirstResponder()
                var point = [Int](count: 6, repeatedValue: 0)
                if textField2.text == "X"{
                    point[0] = 10
                }else if textField2.text == "M"{
                    point [0] = 0
                }else {
                    point[0] = Int(textField2.text!)!
                }
                if textField3.text == "X"{
                    point[1] = 10
                }else if textField3.text == "M"{
                    point [1] = 0
                }else {
                    point[1] = Int(textField3.text!)!
                }
                if textField4.text == "X"{
                    point[2] = 10
                }else if textField4.text == "M"{
                    point [2] = 0
                }else {
                    point[2] = Int(textField4.text!)!
                }
                if textField5.text == "X"{
                    point[3] = 10
                }else if textField5.text == "M"{
                    point [3] = 0
                }else {
                    point[3] = Int(textField5.text!)!
                }
                if textField6.text == "X"{
                    point[4] = 10
                }else if textField6.text == "M"{
                    point [4] = 0
                }else {
                    point[4] = Int(textField6.text!)!
                }
                if textField7.text == "X"{
                    point[5] = 10
                }else if textField7.text == "M"{
                    point [5] = 0
                }else {
                    point[5] = Int(textField7.text!)!
                }
                let total = point[0] + point[1] + point[2] + point[3] + point[4] + point[5]
                textField8.text = String(total)
            }
            else if ja_flag[8] == true{textField8.text = "8"
                ja_flag[8] = false
            }
            else if ja_flag[11] == true{textField_up1.text = "8"
                ja_flag[11] = false
            }
            else if ja_flag[12] == true{textField_up2.text = "8"
                ja_flag[12] = false
            }
            else if ja_flag[13] == true{textField_up3.text = "8"
                ja_flag[13] = false
            }
            else if ja_flag[14] == true{textField_up4.text = "8"
                ja_flag[14] = false
            }
            else if ja_flag[15] == true{textField_up5.text = "8"
                ja_flag[15] = false
            }
            else if ja_flag[16] == true{textField_up6.text = "8"
                ja_flag[16] = false
            }
            else if ja_flag[17] == true{textField_up7.text = "8"
                ja_flag[17] = false
            }
            else if ja_flag[18] == true{textField_up8.text = "8"
                ja_flag[18] = false
            }
            
        }
        else if sender.tag == 9{
            if ja_flag[1] == true{ textField1.text = "9"
                ja_flag[1] = false
                
            }
            else if ja_flag[2] == true{ textField2.text = "9"
                ja_flag[2] = false
                write_flag = true
                textField3.becomeFirstResponder()
            }
            else if ja_flag[3] == true{ textField3.text = "9"
                ja_flag[3] = false
                textField4.becomeFirstResponder()
            }
            else if ja_flag[4] == true{ textField4.text = "9"
                ja_flag[4] = false
                textField5.becomeFirstResponder()
            }
            else if ja_flag[5] == true{ textField5.text = "9"
                ja_flag[5] = false
                textField6.becomeFirstResponder()
            }
            else if ja_flag[6] == true{ textField6.text = "9"
                ja_flag[6] = false
                textField7.becomeFirstResponder()
            }
            else if ja_flag[7] == true{ textField7.text = "9"
                ja_flag[7] = false
                write_flag = false
                textField7.resignFirstResponder()
                var point = [Int](count: 6, repeatedValue: 0)
                if textField2.text == "X"{
                    point[0] = 10
                }else if textField2.text == "M"{
                    point [0] = 0
                }else {
                    point[0] = Int(textField2.text!)!
                }
                if textField3.text == "X"{
                    point[1] = 10
                }else if textField3.text == "M"{
                    point [1] = 0
                }else {
                    point[1] = Int(textField3.text!)!
                }
                if textField4.text == "X"{
                    point[2] = 10
                }else if textField4.text == "M"{
                    point [2] = 0
                }else {
                    point[2] = Int(textField4.text!)!
                }
                if textField5.text == "X"{
                    point[3] = 10
                }else if textField5.text == "M"{
                    point [3] = 0
                }else {
                    point[3] = Int(textField5.text!)!
                }
                if textField6.text == "X"{
                    point[4] = 10
                }else if textField6.text == "M"{
                    point [4] = 0
                }else {
                    point[4] = Int(textField6.text!)!
                }
                if textField7.text == "X"{
                    point[5] = 10
                }else if textField7.text == "M"{
                    point [5] = 0
                }else {
                    point[5] = Int(textField7.text!)!
                }
                let total = point[0] + point[1] + point[2] + point[3] + point[4] + point[5]
                textField8.text = String(total)
            }
            else if ja_flag[8] == true{textField8.text = "9"
                ja_flag[8] = false
            }
            else if ja_flag[11] == true{textField_up1.text = "9"
                ja_flag[11] = false
            }
            else if ja_flag[12] == true{textField_up2.text = "9"
                ja_flag[12] = false
            }
            else if ja_flag[13] == true{textField_up3.text = "9"
                ja_flag[13] = false
            }
            else if ja_flag[14] == true{textField_up4.text = "9"
                ja_flag[14] = false
            }
            else if ja_flag[15] == true{textField_up5.text = "9"
                ja_flag[15] = false
            }
            else if ja_flag[16] == true{textField_up6.text = "9"
                ja_flag[16] = false
            }
            else if ja_flag[17] == true{textField_up7.text = "9"
                ja_flag[17] = false
            }
            else if ja_flag[18] == true{textField_up8.text = "9"
                ja_flag[18] = false
            }
            
        }
        else if sender.tag == 10{
            if ja_flag[1] == true{ textField1.text = "10"
                ja_flag[1] = false
                
            }
            else if ja_flag[2] == true{ textField2.text = "10"
                ja_flag[2] = false
                write_flag = true
                textField3.becomeFirstResponder()
            }
            else if ja_flag[3] == true{ textField3.text = "10"
                ja_flag[3] = false
                textField4.becomeFirstResponder()
            }
            else if ja_flag[4] == true{ textField4.text = "10"
                ja_flag[4] = false
                textField5.becomeFirstResponder()
            }
            else if ja_flag[5] == true{ textField5.text = "10"
                ja_flag[5] = false
                textField6.becomeFirstResponder()
            }
            else if ja_flag[6] == true{ textField6.text = "10"
                ja_flag[6] = false
                textField7.becomeFirstResponder()
            }
            else if ja_flag[7] == true{ textField7.text = "10"
                ja_flag[7] = false
                write_flag = false
                textField7.resignFirstResponder()
                var point = [Int](count: 6, repeatedValue: 0)
                if textField2.text == "X"{
                    point[0] = 10
                }else if textField2.text == "M"{
                    point [0] = 0
                }else {
                    point[0] = Int(textField2.text!)!
                }
                if textField3.text == "X"{
                    point[1] = 10
                }else if textField3.text == "M"{
                    point [1] = 0
                }else {
                    point[1] = Int(textField3.text!)!
                }
                if textField4.text == "X"{
                    point[2] = 10
                }else if textField4.text == "M"{
                    point [2] = 0
                }else {
                    point[2] = Int(textField4.text!)!
                }
                if textField5.text == "X"{
                    point[3] = 10
                }else if textField5.text == "M"{
                    point [3] = 0
                }else {
                    point[3] = Int(textField5.text!)!
                }
                if textField6.text == "X"{
                    point[4] = 10
                }else if textField6.text == "M"{
                    point [4] = 0
                }else {
                    point[4] = Int(textField6.text!)!
                }
                if textField7.text == "X"{
                    point[5] = 10
                }else if textField7.text == "M"{
                    point [5] = 0
                }else {
                    point[5] = Int(textField7.text!)!
                }
                let total = point[0] + point[1] + point[2] + point[3] + point[4] + point[5]
                textField8.text = String(total)
            }
            else if ja_flag[8] == true{textField8.text = "10"
                ja_flag[8] = false
            }
            else if ja_flag[11] == true{textField_up1.text = "10"
                ja_flag[11] = false
            }
            else if ja_flag[12] == true{textField_up2.text = "10"
                ja_flag[12] = false
            }
            else if ja_flag[13] == true{textField_up3.text = "10"
                ja_flag[13] = false
            }
            else if ja_flag[14] == true{textField_up4.text = "10"
                ja_flag[14] = false
            }
            else if ja_flag[15] == true{textField_up5.text = "10"
                ja_flag[15] = false
            }
            else if ja_flag[16] == true{textField_up6.text = "10"
                ja_flag[16] = false
            }
            else if ja_flag[17] == true{textField_up7.text = "10"
                ja_flag[17] = false
            }
            else if ja_flag[18] == true{textField_up8.text = "10"
                ja_flag[18] = false
            }
            
        }
        else if sender.tag == 11{
            if ja_flag[1] == true{ textField1.text = "X"
                ja_flag[1] = false
            }
            else if ja_flag[2] == true{ textField2.text = "X"
                ja_flag[2] = false
                write_flag = true
                textField3.becomeFirstResponder()
            }
            else if ja_flag[3] == true{ textField3.text = "X"
                ja_flag[3] = false
                textField4.becomeFirstResponder()
            }
            else if ja_flag[4] == true{ textField4.text = "X"
                ja_flag[4] = false
                textField5.becomeFirstResponder()
            }
            else if ja_flag[5] == true{ textField5.text = "X"
                ja_flag[5] = false
                textField6.becomeFirstResponder()
            }
            else if ja_flag[6] == true{ textField6.text = "X"
                ja_flag[6] = false
                textField7.becomeFirstResponder()
            }
            else if ja_flag[7] == true{ textField7.text = "X"
                ja_flag[7] = false
                write_flag = false
                textField7.resignFirstResponder()
                var point = [Int](count: 6, repeatedValue: 0)
                if textField2.text == "X"{
                    point[0] = 10
                }else if textField2.text == "M"{
                    point [0] = 0
                }else {
                    point[0] = Int(textField2.text!)!
                }
                if textField3.text == "X"{
                    point[1] = 10
                }else if textField3.text == "M"{
                    point [1] = 0
                }else {
                    point[1] = Int(textField3.text!)!
                }
                if textField4.text == "X"{
                    point[2] = 10
                }else if textField4.text == "M"{
                    point [2] = 0
                }else {
                    point[2] = Int(textField4.text!)!
                }
                if textField5.text == "X"{
                    point[3] = 10
                }else if textField5.text == "M"{
                    point [3] = 0
                }else {
                    point[3] = Int(textField5.text!)!
                }
                if textField6.text == "X"{
                    point[4] = 10
                }else if textField6.text == "M"{
                    point [4] = 0
                }else {
                    point[4] = Int(textField6.text!)!
                }
                if textField7.text == "X"{
                    point[5] = 10
                }else if textField7.text == "M"{
                    point [5] = 0
                }else {
                    point[5] = Int(textField7.text!)!
                }
                let total = point[0] + point[1] + point[2] + point[3] + point[4] + point[5]
                textField8.text = String(total)
            }
            else if ja_flag[8] == true{textField8.text = "X"
                ja_flag[8] = false
            }
            else if ja_flag[11] == true{textField_up1.text = "X"
                ja_flag[11] = false
            }
            else if ja_flag[12] == true{textField_up2.text = "X"
                ja_flag[12] = false
            }
            else if ja_flag[13] == true{textField_up3.text = "X"
                ja_flag[13] = false
            }
            else if ja_flag[14] == true{textField_up4.text = "X"
                ja_flag[14] = false
            }
            else if ja_flag[15] == true{textField_up5.text = "X"
                ja_flag[15] = false
            }
            else if ja_flag[16] == true{textField_up6.text = "X"
                ja_flag[16] = false
            }
            else if ja_flag[17] == true{textField_up7.text = "X"
                ja_flag[17] = false
            }
            else if ja_flag[18] == true{textField_up8.text = "X"
                ja_flag[18] = false
            }

        }
        else if sender.tag == 0{
            
        
            if ja_flag[1] == true{ textField1.text = "M"
                ja_flag[1] = false
                
            }
            else if ja_flag[2] == true{ textField2.text = "M"
                ja_flag[2] = false
                write_flag = true
                textField3.becomeFirstResponder()
            }
            else if ja_flag[3] == true{ textField3.text = "M"
                ja_flag[3] = false
                textField4.becomeFirstResponder()
            }
            else if ja_flag[4] == true{ textField4.text = "M"
                ja_flag[4] = false
                textField5.becomeFirstResponder()
            }
            else if ja_flag[5] == true{ textField5.text = "M"
                ja_flag[5] = false
                textField6.becomeFirstResponder()
            }
            else if ja_flag[6] == true{ textField6.text = "M"
                ja_flag[6] = false
                textField7.becomeFirstResponder()
            }
            else if ja_flag[7] == true{ textField7.text = "M"
                ja_flag[7] = false
                write_flag = false
                textField7.resignFirstResponder()
                var point = [Int](count: 6, repeatedValue: 0)
                if textField2.text == "X"{
                    point[0] = 10
                }else if textField2.text == "M"{
                    point [0] = 0
                }else {
                    point[0] = Int(textField2.text!)!
                }
                if textField3.text == "X"{
                    point[1] = 10
                }else if textField3.text == "M"{
                    point [1] = 0
                }else {
                    point[1] = Int(textField3.text!)!
                }
                if textField4.text == "X"{
                    point[2] = 10
                }else if textField4.text == "M"{
                    point [2] = 0
                }else {
                    point[2] = Int(textField4.text!)!
                }
                if textField5.text == "X"{
                    point[3] = 10
                }else if textField5.text == "M"{
                    point [3] = 0
                }else {
                    point[3] = Int(textField5.text!)!
                }
                if textField6.text == "X"{
                    point[4] = 10
                }else if textField6.text == "M"{
                    point [4] = 0
                }else {
                    point[4] = Int(textField6.text!)!
                }
                if textField7.text == "X"{
                    point[5] = 10
                }else if textField7.text == "M"{
                    point [5] = 0
                }else {
                    point[5] = Int(textField7.text!)!
                }
                let total = point[0] + point[1] + point[2] + point[3] + point[4] + point[5]
                textField8.text = String(total)
            }
            else if ja_flag[8] == true{textField8.text = "M"
                ja_flag[8] = false
            }
            else if ja_flag[11] == true{textField_up1.text = "M"
                ja_flag[11] = false
            }
            else if ja_flag[12] == true{textField_up2.text = "M"
                ja_flag[12] = false
            }
            else if ja_flag[13] == true{textField_up3.text = "M"
                ja_flag[13] = false
            }
            else if ja_flag[14] == true{textField_up4.text = "M"
                ja_flag[14] = false
            }
            else if ja_flag[15] == true{textField_up5.text = "M"
                ja_flag[15] = false
            }
            else if ja_flag[16] == true{textField_up6.text = "M"
                ja_flag[16] = false
            }
            else if ja_flag[17] == true{textField_up7.text = "M"
                ja_flag[17] = false
            }
            else if ja_flag[18] == true{textField_up8.text = "M"
                ja_flag[18] = false
            }
            
        }
        
    }
    func textFieldDidBeginEditing(textFieldi: UITextField) {
        
        if textFieldi.tag == 1{
           
        }
        else if textFieldi.tag == 2{
            
            for var i = 0;i<ja_flag.count;i++ {
                ja_flag[i] = false
            }
            ja_flag[2] = true
            
        }
        else if textFieldi.tag == 3{
            
            for var i = 0;i<ja_flag.count;i++ {
                ja_flag[i] = false
            }
            ja_flag[3] = true
            if write_flag == false{
                
            }
        }
        else if textFieldi.tag == 4{
            
            for var i = 0;i<ja_flag.count;i++ {
                ja_flag[i] = false
            }
            ja_flag[4] = true
            if write_flag == false{
                
            }
        }
        else if textFieldi.tag == 5{
            
            for var i = 0;i<ja_flag.count;i++ {
                ja_flag[i] = false
            }
            ja_flag[5] = true
            if write_flag == false{
               
            }
        }
        else if textFieldi.tag == 6{
            
            for var i = 0;i<ja_flag.count;i++ {
                ja_flag[i] = false
            }
            ja_flag[6] = true
            if write_flag == false{
               
            }
        }
        else if textFieldi.tag == 7{
            
            for var i = 0;i<ja_flag.count;i++ {
                ja_flag[i] = false
            }
            ja_flag[7] = true
            if write_flag == false{
                
            }
        }
        else if textFieldi.tag == 8{
            for var i = 0;i<ja_flag.count;i++ {
                ja_flag[i] = false
            }
           
        }
        else if textFieldi.tag == 11{
            textField_up1.inputView = self.KeyboardInput
            for var i = 0;i<ja_flag.count;i++ {
                ja_flag[i] = false
            }
            ja_flag[11] = true
        }
        else if textFieldi.tag == 12{
            textField_up2.inputView = KeyboardInput
            for var i = 0;i<ja_flag.count;i++ {
                ja_flag[i] = false
            }
            ja_flag[12] = true
        }
        else if textFieldi.tag == 13 {
            textField_up3.inputView = KeyboardInput
            for var i = 0;i<ja_flag.count;i++ {
                ja_flag[i] = false
            }
            ja_flag[13] = true
        }
        else if textFieldi.tag == 14 {
            textField_up4.inputView = KeyboardInput
            for var i = 0;i<ja_flag.count;i++ {
                ja_flag[i] = false
            }
            ja_flag[14] = true
        }
        else if textFieldi.tag == 15{
            textField_up5.inputView = KeyboardInput
            for var i = 0;i<ja_flag.count;i++ {
                ja_flag[i] = false
            }
            ja_flag[15] = true
        }
        else if textFieldi.tag == 16{
            textField_up6.inputView = KeyboardInput
            for var i = 0;i<ja_flag.count;i++ {
                ja_flag[i] = false
            }
            ja_flag[16] = true
        }
        else if textFieldi.tag == 17{
            textField_up7.inputView = KeyboardInput
            for var i = 0;i<ja_flag.count;i++ {
                ja_flag[i] = false
            }
            ja_flag[17] = true
        }
        else if textFieldi.tag == 18{
           
            
        }
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == 11 {
            return false
        }else if textField.tag == 12{
            return false
        }else if textField.tag == 13{
            return false
        }
        else if textField.tag == 14{
            return false
        }
        else if textField.tag == 15{
            return false
        }
        else if textField.tag == 16{
            return false
        }
        else if textField.tag == 17{
            return false
        }
        else if textField.tag == 18{
            return false
        }
            
        else if textField.tag == 2 &&  endkeyio ==  true {
            return false
        }else if textField.tag == 3  &&  endkeyio == true {
            return false
        }
        else if textField.tag == 4 &&  endkeyio == true{
            return false
        }
        else if textField.tag == 5 &&  endkeyio == true{
            return false
        }
        else if textField.tag == 6 &&  endkeyio == true{
            return false
        }
        else if textField.tag == 7 &&  endkeyio == true {
            return false
        }
        else if textField.tag == 8 &&  endkeyio == true{
            return false
        }
       
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("a")
    }
    func keyboardDidHide(notification: NSNotification) {
        print("z")
    }
}