//
//  SPRegisterViewController.swift
//  spade
//
//  Created by ntian on 2017/6/20.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import SVProgressHUD

class SPRegisterViewController: UIViewController {

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerBtn.isEnabled = false
        emailText.clearsOnBeginEditing = true
        passText.clearsOnBeginEditing = true
        emailText.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passText.addTarget(self, action: #selector(passChanged), for: .editingChanged)
    }
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func register() {
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.dismiss(animated: true, completion: nil)
            SVProgressHUD.dismiss()
        }
    }
    @objc fileprivate func emailChanged() {
        if emailText.text != "" && passText.text != "" {
            registerBtn.isEnabled = true
        } else {
            registerBtn.isEnabled = false
        }
    }
    @objc fileprivate func passChanged() {
        if emailText.text != "" && passText.text != "" {
            registerBtn.isEnabled = true
        } else {
            registerBtn.isEnabled = false
        }
    }


}
