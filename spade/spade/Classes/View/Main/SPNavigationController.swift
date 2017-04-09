//
//  SPNavigationController.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true

    }
    // 重写 push 方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(target: self, action: #selector(popToParent))
        super.pushViewController(viewController, animated: animated)
    }
    /// POP 返回到上一级 控制器
    @objc fileprivate func popToParent() {
        popViewController(animated: true)
    }
}

// MARK: - 侧滑手势
extension SPNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return childViewControllers.count > 1
    }
}
