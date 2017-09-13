//
//  SPLoginViewController.swift
//  spade
//
//  Created by ntian on 2017/6/20.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import SVProgressHUD
import Popover

class SPLoginViewController: UIViewController {


    @IBOutlet weak var serviceBtn: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.isEnabled = false
        emailText.clearsOnBeginEditing = true
        passText.clearsOnBeginEditing = true
        emailText.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passText.addTarget(self, action: #selector(passChanged), for: .editingChanged)
    }
    @IBAction func login() {
        if emailText.text == "test" && passText.text == "test" {
            dismiss(animated: true, completion: { 
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginOver"), object: nil)
            })
        } else {
            SVProgressHUD.showError(withStatus: "Incorrect password for \(String(describing: emailText.text))")
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailText.resignFirstResponder()
        passText.resignFirstResponder()
    }
    @IBAction func register() {
        let vc = SPRegisterViewController()
        present(vc, animated: true, completion: nil)
    }
    @objc fileprivate func emailChanged() {
        if emailText.text != "" && passText.text != "" {
            loginBtn.isEnabled = true
        } else {
            loginBtn.isEnabled = false
        }
    }
    @objc fileprivate func passChanged() {
        if emailText.text != "" && passText.text != "" {
            loginBtn.isEnabled = true
        } else {
            loginBtn.isEnabled = false
        }
    }
    @IBAction func service() {
        self.popover = Popover(options: popoverOptions)
        popover.show(webView, fromView: serviceBtn)
    }

}
