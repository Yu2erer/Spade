//
//  NTMessageHud.swift
//  messageBox
//
//  Created by ntian on 2017/4/25.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class NTMessageHud: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 40))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func showMessage(view: UIView, msg: String, isError: Bool) {
        let label = UILabel()
        if !isError {
            label.backgroundColor = UIColor(colorLiteralRed: 0.033, green: 0.685, blue: 0.978, alpha: 0.730)
        } else {
            label.backgroundColor = UIColor(hex: 0xe74c3c)
        }
        label.text = msg
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.frame.size.width = self.frame.size.width
        label.frame.size.height = 35
        label.frame.origin.y = 64 - label.frame.size.height
        view.addSubview(label)
        UIView.animate(withDuration: 0.3, animations: { 
            label.frame.origin.y = 64
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 2, options: .curveEaseInOut, animations: { 
                label.frame.origin.y = 64 - label.frame.origin.y
            }, completion: { (_) in
                label.removeFromSuperview()
                self.removeFromSuperview()
            })
        }
    }
}
