//
//  SPDiscoverTopBarView.swift
//  spade
//
//  Created by ntian on 2017/5/4.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

@objc protocol SPDiscoverTopBarViewDelegate: NSObjectProtocol {
    @objc optional func didClickUserButton()
    @objc optional func didClickPostButton()
}
class SPDiscoverTopBarView: UIView {


    @IBOutlet weak var lineView: UIImageView!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    /// 0为user 1为post
    var whoSelected: Int = 0
    weak var viewDelegate: SPDiscoverTopBarViewDelegate?
    @IBAction func userBtn() {
        viewDelegate?.didClickUserButton?()
        userButton.isSelected = true
        postButton.isSelected = false
        whoSelected = 0
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: .curveLinear, animations: {
            self.lineView.transform = CGAffineTransform.identity
        }, completion: nil)
        
    }
    
    @IBAction func postBtn() {
        userButton.isSelected = false
        postButton.isSelected = true
        whoSelected = 1
        viewDelegate?.didClickPostButton?()

        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: .curveLinear, animations: {
            self.lineView.transform = CGAffineTransform(translationX: self.postButton.frame.origin.x - self.userButton.frame.origin.x, y: 0)
        }, completion: nil)

    }
}
