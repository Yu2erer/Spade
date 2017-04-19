//
//  NTFPSLabel.swift
//  FPSLabel
//
//  Created by ntian on 2017/3/7.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class NTFPSLabel: UILabel {

    fileprivate var link: CADisplayLink?
    fileprivate var count: Int = 0
    fileprivate var lastTime: TimeInterval = 0
    fileprivate let defaultSize = CGSize(width: 55, height: 20)
    
    override init(frame: CGRect) {
        var frame = frame
        if frame.size.width == 0 && frame.size.height == 0 {
            frame.size = defaultSize
        }
        super.init(frame: frame)

        setupUI()
        

        link = CADisplayLink(target: self, selector: #selector(tick(link: )))
        link?.add(to: RunLoop.main, forMode: .commonModes)
    }
    deinit {
        link?.invalidate()
        print("我走了")
    }
    
    func tick(link: CADisplayLink) {
        
        if (lastTime == 0) {
            lastTime = link.timestamp
            return
        }
        count += 1
    
        
        let delta = link.timestamp - lastTime
        
        if (delta < 1) {
            return
        }
        
        lastTime = link.timestamp
        let fps = Double(count) / delta
        count = 0
        
        let progress = fps / 60.0
        
        textColor = UIColor(hue: CGFloat(0.27 * ( progress - 0.2 )) , saturation: 1, brightness: 0.9, alpha: 1)
        text = "\(Int(fps + 0.5))FPS"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置界面
extension NTFPSLabel {
    
    fileprivate func setupUI() {
        textColor = UIColor.white
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        layer.cornerRadius = 5
        clipsToBounds = true
        textAlignment = .center
        font = UIFont(name: "Menlo", size: 14)
    }
}
