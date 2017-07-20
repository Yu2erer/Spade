//
//  NTEasyAuthDelegate.swift
//  NTEasyAuthDemo
//
//  Created by ntian on 2017/6/1.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

@objc public protocol NTEasyAuthDelegate: class {
    
    func touchIDAuthSuccess()
    func touchIDAuthFail()
    @objc optional func touchIDAuthLockout()
    @objc optional func touchIDAuthCancel()
    @objc optional func touchIDAuthFallback()
}
