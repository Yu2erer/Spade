//
//  SPHomeVideoView.swift
//  spade
//
//  Created by ntian on 2017/4/16.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import ZFPlayer

class SPHomeVideoView: UIView {
    
    @IBOutlet weak var heightCons: NSLayoutConstraint!

    var viewModel: SPDashBoardViewModel? {
        didSet {
            guard let thumbnailURL = viewModel?.dashBoard.thumbnail_url, let videoURL = URL(string: viewModel?.dashBoard.video_url ?? "") else {
                return
            }
            
            calcViewSize()
        }
    }
    
    private func calcViewSize() {
        let thumbnailHeight = viewModel?.dashBoard.thumbnail_height ?? 0
        let thumbnailWidth = viewModel?.dashBoard.thumbnail_width ?? 0
        let height = CGFloat(thumbnailHeight / thumbnailWidth) * PictureViewWidth

        heightCons.constant = CGFloat(viewModel?.dashBoard.thumbnail_height ?? 0)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    
}
// MARK: - 设置界面
extension SPHomeVideoView {
    fileprivate func setupUI() {
        backgroundColor = UIColor(hex: 0xEAEAEA)

    }
}
