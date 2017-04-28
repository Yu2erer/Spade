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

class SPLoginView: UIView {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var login: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
  
        // 停止后，隐藏菊花
        self.activity.hidesWhenStopped = true
        // 添加activity到view中
        login.addSubview(self.activity)
        activity.center = CGPoint(x: login.bounds.width / 2, y: login.bounds.height / 2)
        NotificationCenter.default.addObserver(self, selector: #selector(reset), name: NSNotification.Name(rawValue: "reset"), object: nil)
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
            print(isSuccess)
            if isSuccess {
                UIView.animate(withDuration: 0.35, animations: {
                    self.alpha = 0
                }, completion: { (_) in
                    self.removeFromSuperview()
                })
            } else {
                SVProgressHUD.showError(withStatus: "登录失败, 请检查网络连接")
                self.activity.stopAnimating()
                self.login.isEnabled = true
            }
        }
    }

}
