//
//  SPUserDetailViewController.swift
//  spade
//
//  Created by ntian on 2017/4/19.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPUserDetailViewController: UIViewController {

    var user: SPDashBoard? {
        didSet {
            guard let user = user else {
                return
            }
            navigationItem.title = user.blog_name
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}
extension SPUserDetailViewController {
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
    }
}
