//
//  NTUserDefault+Extensions.swift
//  NTUserDefault
//
//  Created by ntian on 2017/5/2.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

protocol UserDefaultsSettable {
    associatedtype defaultKeys: RawRepresentable
}
extension UserDefaults {
    struct UserSetting: UserDefaultsSettable {
        enum defaultKeys: String {
            case isHaveSetting
            case isSmallWindowOn
        }
    }
}
extension UserDefaultsSettable where defaultKeys.RawValue == String {
    
    static func set(value: Bool, forKey key: defaultKeys) {
        let key = key.rawValue
        UserDefaults.standard.set(value, forKey: key)
    }
    static func bool(forKey key: defaultKeys) -> Bool {
        let key = key.rawValue
        return UserDefaults.standard.bool(forKey: key)
    }
    static func set(value: Any?, forKey key: defaultKeys) {
        let key = key.rawValue
        UserDefaults.standard.set(value, forKey: key)
    }
    static func set(value: Int, forKey key: defaultKeys) {
        let key = key.rawValue
        UserDefaults.standard.set(value, forKey: key)
    }
    static func string(forKey key: defaultKeys) -> String? {
        let key = key.rawValue
        return UserDefaults.standard.string(forKey: key)
    }
    static func remove(forKey key: defaultKeys) {
        let key = key.rawValue
        UserDefaults.standard.removeObject(forKey: key)
    }
}
