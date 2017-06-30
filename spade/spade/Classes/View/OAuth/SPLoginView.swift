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
import Popover

class SPLoginView: UIView {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var serviceBtn: UIButton!
    fileprivate var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
        .type(.up),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    fileprivate lazy var webView: UIWebView = {
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: PictureViewWidth - 40, height: PictureViewHeight - 100))
        let path = Bundle.main.path(forResource: "service", ofType: "html")
        let htmlString = try! String(contentsOfFile: path!)
        webView.loadHTMLString(htmlString, baseURL: nil)
        return webView
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 停止后，隐藏菊花
        self.activity.hidesWhenStopped = true
        serviceBtn.alpha = 0
        // 添加activity到view中
        login.addSubview(self.activity)
        activity.center = CGPoint(x: login.bounds.width / 2, y: login.bounds.height / 2)
        NotificationCenter.default.addObserver(self, selector: #selector(reset), name: NSNotification.Name(rawValue: "reset"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginOver), name: NSNotification.Name(rawValue: "loginOver"), object: nil)
        

    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        // layoutIfNeeded会直接按照当前的约束 更新控件位置
        // 执行之后 控件所在位置就是xib 布局的位置
        self.layoutIfNeeded()
        login.center.y += 214
        logo.center.x -= PictureViewWidth
        UIView.animate(withDuration: 0.6, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.logo.center.x += PictureViewWidth
        }, completion: nil)
        UIView.animate(withDuration: 0.6, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.login.center.y -= 214
            self.layoutIfNeeded()
            self.serviceBtn.alpha = 1
        }, completion: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc fileprivate func reset() {
        self.activity.stopAnimating()
        self.login.isEnabled = true
        self.serviceBtn.alpha = 0
    }
    @objc fileprivate func loginOver() {
        if !inReview {
            return
        }
        self.layoutIfNeeded()
        SPNetworkManage.shared.userAccount.oauthToken = "dwwtBRxbTuKf7g0zYc6C37LRdzAe5Omwc64SWlsVNoIKEz2OCh"
        SPNetworkManage.shared.userAccount.oauthTokenSecret = "8YkxYHppXJGdQhVSlT7sC3LMLAVNNN2ZPWSXTzeca3g6kRTtmd"
        SPNetworkManage.shared.userAccount.saveAccount()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SPUserLoginSuccessedNotification), object: nil)
        UIView.animate(withDuration: 0.6, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.logo.center.x -= PictureViewWidth
        }, completion: nil)
        UIView.animate(withDuration: 0.6, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.login.center.y += 214
            self.serviceBtn.alpha = 0
            self.alpha = 0
        }, completion: { (_) in
            self.removeFromSuperview()
        })
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
        if inReview {
            let vc = SPLoginViewController()
            let next = self.superview
            let nextResponse = next?.next
            if nextResponse?.isKind(of: UIViewController.self) == true {
                _ = (nextResponse as! UIViewController).present(vc, animated: true, completion: nil)
            }
            return
        }
        SPNetworkManage.shared.loadToken { (isSuccess) in
            if isSuccess {
                self.layoutIfNeeded()
                UIView.animate(withDuration: 0.6, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
                    self.logo.center.x -= PictureViewWidth
                }, completion: nil)
                UIView.animate(withDuration: 0.6, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
                    self.login.center.y += 214
                    self.serviceBtn.alpha = 0
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
    @IBAction func service() {
        self.popover = Popover(options: popoverOptions)
        popover.show(webView, fromView: serviceBtn)
    }
}
