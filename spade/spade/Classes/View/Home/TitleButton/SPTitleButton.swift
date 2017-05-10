//
//  SPTitleButton.swift
//  spade
//
//  Created by ntian on 2017/5/10.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPTitleButton: UIButton {

    init(title: String) {
        super.init(frame: CGRect())
        
        setTitle(title, for: .normal)
        setTitleColor(UIColor.black, for: .normal)

        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setImage(UIImage(named: "DownArrow"), for: .normal)
        setImage(UIImage(named: "UpArrow"), for: .selected)
        sizeToFit()

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let titleLabel = titleLabel, let imageView = imageView else {
            return
        }

        titleLabel.frame.origin.x = 0
        imageView.frame.origin.x = titleLabel.bounds.width
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
