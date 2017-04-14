//
//  NTString+Extensions.swift
//  spade
//
//  Created by ntian on 2017/4/8.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

private let dateFormatter = DateFormatter()

extension String {
    
    /// 获取 Blog 中间字符串地址
    func getBlogString() -> String {
        let range1 = self.range(of: "://")
        let range2 = self.range(of: "/post/")
        return self.substring(with: (range1?.upperBound)!..<(range2?.lowerBound)!)
        
    }
  
    

}
