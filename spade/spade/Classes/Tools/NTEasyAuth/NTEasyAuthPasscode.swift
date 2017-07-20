//
//  NTEasyAuthPasscode.swift
//  NTEasyAuthDemo
//
//  Created by ntian on 2017/6/1.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

class NTEasyAuthPasscode {
    
    var hasPasscode: Bool?
    var passcode: String?
    
    init() {
        passcode = UserDefaults.standard.string(forKey: "passcode")
        hasPasscode = passcode != nil
    }
    open func deletePasscode() {
        UserDefaults.standard.removeObject(forKey: "passcode")
    }
    /// 保存密码
    ///
    /// - Parameter passcode: 密码字符串
    open func savePasscode(_ passcode: String) {
        UserDefaults.standard.set(passcode, forKey: "passcode")
    }
    
}
