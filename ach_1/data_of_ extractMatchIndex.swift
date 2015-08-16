//
//  data_of_ extractMatchIndex.swift
//  ach_1
//
//  Created by 早坂彪流 on 2015/07/03.
//  Copyright © 2015年 早坂彪流. All rights reserved.
//

import Foundation

class data_of_extractMatchIndex:NSObject {
    let m_id:Int
    let matchName:String
    let sponsor:String
    let created:String
    let arrows:Int
    let perEnd:Int
    let length:Int
    let players:Int
    
    
    init(_m_id:Int,_matchName:String,_sponsor:String,_created:String,_arrows:Int,_perEnd:Int,_length:Int,_players:Int){
        m_id = _m_id
        matchName = _matchName
        sponsor = _sponsor
        created = _created
        arrows = _arrows
        perEnd = _perEnd
        length = _length
        players = _players
    }
}