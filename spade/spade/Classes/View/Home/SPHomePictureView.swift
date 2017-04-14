//
//  SPHomePictureView.swift
//  spade
//
//  Created by ntian on 2017/4/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPHomePictureView: UIView {
    
    
    var pro: Float?
    var viewModel: SPDashBoardViewModel? {
        didSet {
            calcViewSize()
        }
    }
    private func calcViewSize() {
        
        guard let row = viewModel?.row else {
            return
        }
        var rowNum = (Int(viewModel?.dashBoard.photoset_layout ?? "") ?? 0).reverse()
        /// 这一行有多少张图
        var temp = 0
        /// ImageView 序列
        var index = 0
        /// 图片序列
        var picNum = 0
        var originalHeight: Double = 0
        var originalWidth: Double = 0
        /// 临时高度
        var tempHeight: CGFloat = 0
        
        for r in 0..<row {
            temp = rowNum % 10
            rowNum = rowNum / 10
            for i in 0..<temp {
                let v = subviews[index] as! UIImageView
                let pv = v.subviews[0] as! UIProgressView

                originalHeight = Double(viewModel?.dashBoard.photos?[picNum].original_size?.height ?? "") ?? 0
                originalWidth = Double(viewModel?.dashBoard.photos?[picNum].original_size?.width ?? "") ?? 0
                let picHeight = CGFloat(originalHeight / originalWidth) * PictureViewWidth / CGFloat(temp)
                let xOffset = CGFloat(i) * (PictureViewWidth / CGFloat(temp) + PictureViewInnerMargin)
                var yOffset: CGFloat = 0
                
                if row > 1 && r > 0 {
                    yOffset = tempHeight
                }
                v.frame = CGRect(x: 0, y: PictureViewOutterMargin, width: PictureViewWidth / CGFloat(temp), height: picHeight).offsetBy(dx: xOffset, dy: yOffset)
                pv.center = CGPoint(x: v.bounds.width / 2, y: v.bounds.height / 2)

                index = index + 1
            }
            let picHeight = CGFloat(originalHeight / originalWidth) * PictureViewWidth / CGFloat(temp)
            tempHeight += picHeight + PictureViewInnerMargin

            picNum = picNum + temp
        }
        heightCons.constant = (viewModel?.height ?? 0)

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
                let pv = iv.subviews[0] as! UIProgressView
                iv.contentMode = .scaleAspectFill
                iv.clipsToBounds = true
                iv.nt_setImage(urlString: url.alt_sizes?[0].url, placeholder: nil, progress: { (receivedSize, expectedSize) in
                    DispatchQueue.main.async(execute: {
                        let progress = Float(receivedSize) / Float(expectedSize)
                        if progress < 1 {
                            pv.progress = Float(receivedSize) / Float(expectedSize)
                        }
                    })
                }, completionHandle: { (_, _, _, _) in
                    pv.isHidden = true
                })
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
        
        let count = 10
        
        let rect = CGRect(x: 0, y: PictureViewOutterMargin, width: 0, height: 0)
        for _ in 0..<count {
            let progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let iv = UIImageView(frame: rect)

            iv.backgroundColor = UIColor(hex: 0xEAEAEA)
            addSubview(iv)
            progressView.progress = 0
            iv.addSubview(progressView)
        }
 
    }
}
