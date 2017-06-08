//
//  SPLoginView.swift
//  spade
//
//  Created by ntian on 2017/4/24.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import OAuthSwift
import SVProgressHUD
//import Popover

class SPLoginView: UIView {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var logo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 停止后，隐藏菊花
        self.activity.hidesWhenStopped = true
        // 添加activity到view中
        login.addSubview(self.activity)
        activity.center = CGPoint(x: login.bounds.width / 2, y: login.bounds.height / 2)
        NotificationCenter.default.addObserver(self, selector: #selector(reset), name: NSNotification.Name(rawValue: "reset"), object: nil)
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        // layoutIfNeeded会直接按照当前的约束 更新控件位置
        // 执行之后 控件所在位置就是xib 布局的位置
        self.layoutIfNeeded()
        login.center.y += 214
        logo.center.x -= PictureViewWidth
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.logo.center.x += PictureViewWidth
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.login.center.y -= 214
            self.layoutIfNeeded()
        }, completion: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc fileprivate func reset() {
        self.activity.stopAnimating()
        self.login.isEnabled = true
    }
    class func loginView()-> SPLoginView {
        let nib = UINib(nibName: "SPLoginView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! SPLoginView
        // 指定屏幕大小
        v.frame = UIScreen.main.bounds
        return v
    }
    @IBAction func loginBtn(_ sender: UIButton) {
        login.isEnabled = false
        activity.startAnimating()
        SPNetworkManage.shared.loadToken { (isSuccess) in
            if isSuccess {
                self.layoutIfNeeded()
                UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
                    self.logo.center.x -= PictureViewWidth
                }, completion: nil)
                UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
                    self.login.center.y += 214
                    self.alpha = 0
                }, completion: { (_) in
                    self.removeFromSuperview()
                })
            } else {
                SVProgressHUD.showError(withStatus:              NSLocalizedString("NetworkUnavailable", comment: "网络错误"))
                self.activity.stopAnimating()
                self.login.isEnabled = true
            }
        }
    }
}
