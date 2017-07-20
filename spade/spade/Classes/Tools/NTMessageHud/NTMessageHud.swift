//
//  NTMessageHud.swift
//
//  Created by ntian on 2017/4/25.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class NTMessageHud {
    
    class func showMessage(targetView: UIView?, message: String, isError: Bool = false) {
        let label = UILabel()
        let frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 40)
        label.text = message
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.frame.size.width = frame.size.width
        label.frame.size.height = 40
        label.frame.origin.y = 64 - label.frame.size.height
        
        if !isError {
            label.backgroundColor = UIColor(colorLiteralRed: 0.033, green: 0.685, blue: 0.978, alpha: 0.730)
        } else {
            label.backgroundColor = UIColor(colorLiteralRed: 0.905, green: 0.294, blue: 0.235, alpha: 1.0)
        }
        
        targetView?.addSubview(label)
        UIView.animate(withDuration: 0.3, animations: {
            label.frame.origin.y = 64
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 2, options: .curveEaseInOut, animations: { 
                label.frame.origin.y = 64 - label.frame.origin.y
            }, completion: { (_) in
                label.removeFromSuperview()
            })
        }
    }
}
