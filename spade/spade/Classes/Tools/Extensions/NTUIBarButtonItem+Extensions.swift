//
//  NTUIBarButtonItem+Extensions.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 创建一个图像barItem
    convenience init(imageName: String, target: Any?, action: Selector) {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView: btn)
    }
    /// 返回按钮
    convenience init(target: Any?, action: Selector) {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: "navigation-direction"), for: .normal)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView: btn)
    }

    
}
