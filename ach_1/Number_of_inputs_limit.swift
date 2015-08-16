//
//  Number_of_inputs_limit.swift
//  ach_1
//
//  Created by 早坂彪流 on 2015/07/09.
//  Copyright © 2015年 早坂彪流. All rights reserved.
//

import UIKit

class Utility_inputs_limit{
  
    func limitstring(str:String?) -> Bool {
        if let trimmedStr = str?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) {
            if (Int(trimmedStr) > 0) {
                return true
            }
        }
        return false
    }
    internal var keych_access:String!{
        get{
            return LUKeychainAccess.standardKeychainAccess().stringForKey("sessionID")
        }set(newdata){
            LUKeychainAccess.standardKeychainAccess().setString(newdata, forKey: "sessionID")
        }
    
    }
    var URLdataSet:String{
        get{
        //return "http://192.168.7.222"
        return "http://49.212.91.93"

        }
    }
}
