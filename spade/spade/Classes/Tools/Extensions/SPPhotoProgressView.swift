//
//  SPPhotoProgressView.swift
//  spade
//
//  Created by ntian on 2017/4/13.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

/// 一个 环形进度条
class SPPhotoProgressView: UIView {
    var progress: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var trackTintColor: UIColor = UIColor(white: 0.0, alpha: 0.6)
    var progressTintColor = UIColor(white: 0.8, alpha: 0.8)
    var borderTintColor = UIColor(white: 0.8, alpha: 0.8)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        if (rect.size.width == 0 || rect.size.height == 0) {
            return
        }
        if progress >= 1.0 {
            return
        }
        var radius = min(rect.size.width, rect.size.height) * 0.5
        let center = CGPoint(x: rect.size.width * 0.5, y: rect.size.height * 0.5)
        borderTintColor.setStroke()
        let lineWidth: CGFloat = 2.0
        let borderPath = UIBezierPath(arcCenter: center, radius: radius - lineWidth * 0.5, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        borderPath.lineWidth = lineWidth
        borderPath.stroke()
        // 绘制内圆
        self.trackTintColor.setFill()
        radius -= lineWidth * 2
        
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackPath.fill()
        // 绘制进度
        let start: CGFloat = -CGFloat.pi / 2
        let end: CGFloat = start + self.progress * 2 * CGFloat.pi
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        progressPath.addLine(to: center)
        progressPath.close()
        progressPath.fill()
        
    }
    
    
    
}
