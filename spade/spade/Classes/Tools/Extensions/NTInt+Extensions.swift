//
//  NTInt+Extensions.swift
//  spade
//
//  Created by ntian on 2017/4/12.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

extension Int {
    
    /// 整数取反
    func reverse() -> Int {
        var x = self
        var result = 0
        
        while x != 0 {
            result = result * 10 + x % 10
            x /= 10
        }
        return result
    }

}
