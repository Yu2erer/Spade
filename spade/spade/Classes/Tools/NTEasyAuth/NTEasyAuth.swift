//
//  NTEasyAuth.swift
//  NTEasyAuthDemo
//
//  Created by ntian on 2017/6/1.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation
import LocalAuthentication

private let context = LAContext()

open class NTEasyAuth {
    
    lazy var passcode = NTEasyAuthPasscode()
    /// 是否开启 指纹认证 默认为 false
    open var isEnabledAuth: Bool = false {
        didSet {
            UserDefaults.standard.set(isEnabledAuth, forKey: "isEnabledAuth")
        }
    }
    private init() {
        isEnabledAuth = UserDefaults.standard.bool(forKey: "isEnabledAuth")
    }
    
    open static let shared = NTEasyAuth()
    open weak var delegate: NTEasyAuthDelegate?
    /// TouchID 是否可用
    open var isTouchIDEnabled: Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    /// TouchID验证
    ///
    /// - Parameters:
    ///   - message: 提示信息
    ///   - fallbackTitle: fallback 提示
    open func touchIDAuth(message: String, fallbackTitle: String?) {
        guard isTouchIDEnabled && isEnabledAuth else {
            return
        }
        context.localizedFallbackTitle = fallbackTitle
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: message, reply: { (isSuccess, error) in
            self.handleTouchIDResult(isSuccess, error)
        })
    }
    fileprivate func handleTouchIDResult(_ success: Bool, _ error: Error?) {
        DispatchQueue.main.async {
            if success {
                self.delegate?.touchIDAuthSuccess()
            } else if error != nil {
                switch Int32((error! as NSError).code) {
                case kLAErrorUserCancel:
                    self.delegate?.touchIDAuthCancel?()
                case kLAErrorSystemCancel:
                    self.delegate?.touchIDAuthCancel?()
                case kLAErrorUserFallback:
                    self.delegate?.touchIDAuthFallback?()
                case kLAErrorAuthenticationFailed:
                    self.delegate?.touchIDAuthFail()
                case kLAErrorTouchIDLockout:
                    self.delegate?.touchIDAuthFallback?()
                default:
                    break;
                }
            }
        }
    }
}
