//
//  SPServiceViewController.swift
//  spade
//
//  Created by ntian on 2017/6/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPServiceViewController: UIViewController {

    fileprivate lazy var webView: UIWebView = {
        let webView = UIWebView(frame: UIScreen.main.bounds)
        webView.backgroundColor = UIColor.white
        let path = Bundle.main.path(forResource: "service", ofType: "html")
        let htmlString = try! String(contentsOfFile: path!)
        webView.loadHTMLString(htmlString, baseURL: nil)
        return webView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}
extension SPServiceViewController {
    fileprivate func setupUI() {
        title = NSLocalizedString("Service", comment: "服务协议")
        view.backgroundColor = UIColor.white
        view.addSubview(webView)
    }
}
