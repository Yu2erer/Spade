//
//  NTDate+Extensions.swift
//  spade
//
//  Created by ntian on 2017/4/8.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

private let dateFormatter = DateFormatter()
/// 当前日历对象
private let calendar = Calendar.current

extension Date {
    
    static func nt_dateString(delta: TimeInterval) -> String {
        
        let date = Date(timeIntervalSinceNow: delta)
        
        dateFormatter.dateFormat = "yyyy-MM-DD HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    /// 将获取的时间字符串转换成日期
    ///
    /// - Parameter string: Tue Sep 15 12:12:12 +0000 2017
    /// - Returns: 日期
    static func nt_Date(string: String) -> Date? {
        
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        // 转换并且返回日期
        return dateFormatter.date(from: string)
    }
    /**
     刚刚(一分钟内)
     X分钟前(一小时内)
     x小时前(当天)
     昨天 HH:mm(昨天)
    */
    var nt_dateDescription: String {
        
        if calendar.isDateInToday(self) {
            
            let delta = -Int(self.timeIntervalSinceNow)
            if delta < 60 {
                return "刚刚"
            }
            if delta < 3600 {
                return "\(delta / 60)分钟前"
            }
            return "\(delta / 3600)小时前"
        }
        var fmt = " HH:mm"
        if calendar.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        }
        
        return dateFormatter.string(from: self)
    }
}
