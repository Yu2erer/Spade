//
//  SPHomeViewController.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        SPNetworkManage.shared.request(urlString: "https://api.tumblr.com/v2/user/dashboard", method: .GET) { (list, isSuccess) in
            print(list)
        }
        
    }
    
    @objc fileprivate func test() {
        let vc = SPDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    
}
// MARK: - 设置界面
extension SPHomeViewController {
    
    fileprivate func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "bar-button-camera", target: self, action: #selector(test))
        
    }
}
