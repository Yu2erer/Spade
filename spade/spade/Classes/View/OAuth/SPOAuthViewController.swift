//
//  SPOAuthViewController.swift
//  spade
//
//  Created by ntian on 2017/4/23.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import OAuthSwift
import SVProgressHUD

class SPOAuthViewController: OAuthWebViewController {

    fileprivate lazy var webView = UIWebView()
    fileprivate var targetURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "close"), for: .normal)
        
        btn.frame = CGRect(x: 20, y: 30, width: 20, height: 20)
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(btn)
    }
    override func loadView() {
        view = webView
        webView.delegate = self
        view.backgroundColor = UIColor(hex: 0x29354A)
        webView.scrollView.isScrollEnabled = false
    }
    // MARK: - 监听方法
    func close() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reset"), object: nil)
        SVProgressHUD.dismiss()
        self.dismissWebViewController()
    }

    override func handle(_ url: URL) {
        super.handle(url)
        targetURL = url
        loadAdressURL()
    }
    func loadAdressURL() {
        guard let url = targetURL else {
            return
        }
        let req = URLRequest(url: url)
        
        self.webView.loadRequest(req)
    }
   

}
extension SPOAuthViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.url, url.scheme == "spade" {
            print("Url \(url)")
            self.dismissWebViewController()
            SVProgressHUD.dismiss()
        }
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
