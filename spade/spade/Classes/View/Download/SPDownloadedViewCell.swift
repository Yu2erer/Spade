//
//  SPDownloadedViewCell.swift
//  download
//
//  Created by ntian on 2017/5/15.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPDownloadedViewCell: UITableViewCell {

    @IBOutlet weak var fileImage: UIImageView!
    fileprivate let playBtn = UIButton(type: .custom)
    @objc fileprivate func play() {
        playBack?()
    }
    var playBack: (()->())?
    var imageString: String? {
        didSet {
            guard let url = URL(string: imageString!) else {
                return
            }
            fileImage.kf.setImage(with: url)
        }
    }

    override func awakeFromNib() {
        playBtn.setImage(UIImage(named: "video_list_cell_big_icon"), for: .normal)
        playBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        playBtn.addTarget(self, action: #selector(play), for: .touchUpInside)
        fileImage.addSubview(playBtn)
        playBtn.center = CGPoint(x: PictureViewWidth / 2, y: 95)
        fileImage.contentMode = .scaleAspectFill

        // 离屏渲染
        self.layer.drawsAsynchronously = true
        // 栅格化
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
