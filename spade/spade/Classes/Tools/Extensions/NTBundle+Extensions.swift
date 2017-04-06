//
//  NTBundle+Extensions.swift
//  抽取namespace
//
//  Created by ntian on 2017/2/21.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

extension Bundle {
    
    /// 返回命名空间字符串
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    /// 返回当前版本
    var currentVerison: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
}
