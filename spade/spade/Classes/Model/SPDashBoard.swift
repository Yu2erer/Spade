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
    // 名字
    var blog_name: String?
    // 链接 用来取 blog 相关信息的
    var post_url: String? {
        didSet {
            // 通过String的扩展获取 前八位https://
            // 和后18位的中间 Blog 的地址
            post_url = post_url?.getBlogString()
        }
    }
    
    override var description: String {
        return yy_modelDescription()
    }
    
}
