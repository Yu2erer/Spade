//
//  SPDashBoard.swift
//  spade
//
//  Created by ntian on 2017/4/7.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import YYModel

class SPDashBoard: NSObject {
    
    var id: Int = 0
    // 内容
    var summary: String?
    
    override var description: String {
        return yy_modelDescription()
    }
    
}
