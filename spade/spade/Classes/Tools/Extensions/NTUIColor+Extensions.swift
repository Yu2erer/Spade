//
//  NTUIColor+Extensions.swift
//  spade
//
//  Created by ntian on 2017/4/13.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    convenience init(hex: UInt) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}
