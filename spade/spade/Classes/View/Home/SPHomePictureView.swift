//
//  SPHomePictureView.swift
//  spade
//
//  Created by ntian on 2017/4/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPHomePictureView: UIView {
    

    var viewModel: SPDashBoardViewModel? {
        didSet {
            calcViewSize()
        }
    }
    private func calcViewSize() {
        
        guard let photosCount = viewModel?.dashBoard.photosCount else {
            return
        }

        if viewModel?.row == 1 {
            
            
            for i in 0..<photosCount {
                let v = subviews[i]
                let viewSize = viewModel?.pictureViewSize ?? CGSize()
                let xOffset = CGFloat(i) * (PictureViewWidth / CGFloat(photosCount) + PictureViewInnerMargin)
                v.frame = CGRect(x: 0, y: PictureViewOutterMargin, width: viewSize.width, height: viewSize.height).offsetBy(dx: xOffset, dy: 0)
            }
        }
        //                let yOffset = CGFloat(i) * (viewSize.height + PictureViewInnerMargin)

        
        heightCons.constant = (viewModel?.pictureViewSize.height ?? 0) + PictureViewOutterMargin

    }
    /// 配图视图的数组
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
        
        let rect = CGRect(x: 0, y: PictureViewOutterMargin, width: PictureViewWidth, height: 0)
        for _ in 0..<count {
            
            let iv = UIImageView()

            iv.frame = rect
            addSubview(iv)
        }
 
    }
}
