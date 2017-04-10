//
//  SPHomePictureView.swift
//  spade
//
//  Created by ntian on 2017/4/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPHomePictureView: UIView {
    

    var urls: [SPDashBoardPicture]? {
        didSet {
            // 隐藏所有的 imageView
            for v in subviews {
                v.isHidden = true
            }
            // 设置图像
            var index = 0
            
            for url in urls ?? [] {
                
                let iv = subviews[index] as! UIImageView
                iv.contentMode = .scaleAspectFill
                iv.clipsToBounds = true
                
                iv.nt_setImage(urlString: url.alt_sizes?[0].url, placeholder: nil)
                // 显示图像
                iv.isHidden = false
                
                index += 1
            }
            
        }
    }
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        setupUI()
    }
}
// MARK: - 设置界面
extension SPHomePictureView {
    
    fileprivate func setupUI() {
        
        /// 超出边界不显示
        clipsToBounds = true
        
        let count = 9
        
        let rect = CGRect(x: 0, y: PictureViewOutterMargin, width: PictureViewWidth, height: 300)
        for i in 0..<count {
            
            let iv = UIImageView()
            iv.backgroundColor = UIColor.red
            
            iv.frame = rect
            addSubview(iv)
        }
 
    }
}
