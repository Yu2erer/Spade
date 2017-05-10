//
//  SPSelectLoadView.swift
//  spade
//
//  Created by ntian on 2017/5/10.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

@objc protocol SPSelectLoadViewDelegate: NSObjectProtocol {
    @objc optional func didClickHome()
    @objc optional func didClickPhoto()
    @objc optional func didClickVideo()
}
class SPSelectLoadView: UIView {

    weak var viewDelegate: SPSelectLoadViewDelegate?
    
    @IBOutlet weak var homeLabel: UIButton!
    @IBOutlet weak var photoLabel: UIButton!
    @IBOutlet weak var videoLabel: UIButton!
    
    @IBAction func tapHome(_ sender: Any) {
        homeLabel.setTitleColor(UIColor(hex: 0x4D8DF7), for: .normal)
        photoLabel.setTitleColor(UIColor.black, for: .normal)
        videoLabel.setTitleColor(UIColor.black, for: .normal)
        viewDelegate?.didClickHome?()
    }
    
    @IBAction func tapPhoto(_ sender: Any) {
        homeLabel.setTitleColor(UIColor.black, for: .normal)
        photoLabel.setTitleColor(UIColor(hex: 0x4D8DF7), for: .normal)
        videoLabel.setTitleColor(UIColor.black, for: .normal)
        viewDelegate?.didClickPhoto?()
    }
    @IBAction func tagVideo(_ sender: Any) {
        homeLabel.setTitleColor(UIColor.black, for: .normal)
        photoLabel.setTitleColor(UIColor.black, for: .normal)
        videoLabel.setTitleColor(UIColor(hex: 0x4D8DF7), for: .normal)
        viewDelegate?.didClickVideo?()
    }
    
}
