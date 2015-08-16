//
//  allbaTableCell.swift
//  ach_1
//
//  Created by 早坂彪流 on 2015/05/20.
//  Copyright (c) 2015年 早坂彪流. All rights reserved.
//

import UIKit

class allbaTableCell: UITableViewCell {

    @IBOutlet weak var game_name_label: UILabel!
    
    @IBOutlet weak var game_master_label: UILabel!
    
    @IBOutlet weak var gotonext: UIButton!
    
    private var data_extractMatchIndex:data_of_extractMatchIndex?
    
    func input_of_extractMatchIndex(sender:data_of_extractMatchIndex,indexPath_row:Int){
        self.data_extractMatchIndex = sender as data_of_extractMatchIndex
        self.game_name_label.text = data_extractMatchIndex?.matchName
        self.game_master_label.text = data_extractMatchIndex?.sponsor
        self.gotonext.tag = indexPath_row
    }
    
    
}
