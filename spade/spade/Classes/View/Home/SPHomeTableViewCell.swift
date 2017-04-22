//
//  SPHomeTableViewCell.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

@objc protocol SPHomeTableViewCellDelegate: NSObjectProtocol {
    @objc optional func didClickUser(user: SPDashBoard)
}
class SPHomeTableViewCell: UITableViewCell {
    // 正文
    @IBOutlet weak var statusLabel: UILabel!
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    // 时间
    @IBOutlet weak var timeLabel: UILabel!
    // 头像
    @IBOutlet weak var iconView: UIImageView!
    /// 爱心喜欢
    @IBOutlet weak var likeIcon: UIImageView!
    /// 配图视图
    @IBOutlet weak var pictureView: SPHomePictureView?
    /// 占位图
    @IBOutlet weak var placeholderImage: UIImageView?
    @IBOutlet weak var heightCons: NSLayoutConstraint?
    // 播放按钮
    let playBtn = UIButton(type: .custom)
    fileprivate var trackingTouch = false

    public weak var cellDelegate: SPHomeTableViewCellDelegate?
    /// 播放按钮回调
    var playBack: (()->())?

    var viewModel: SPDashBoardViewModel? {
        
        didSet {
            nameLabel.text = viewModel?.dashBoard.blog_name
            statusLabel.text = viewModel?.dashBoard.summary
            iconView.nt_setAvatarImage(urlString: viewModel?.avatarURL, placeholder: nil, isAvator: true)
            likeIcon.image = viewModel?.likeImage
            timeLabel.text = viewModel?.dashBoard.createDate?.nt_dateDescription
            
            pictureView?.urls = viewModel?.dashBoard.photos
            pictureView?.viewModel = viewModel
            
            calcViewHeight()
            placeholderImage?.nt_setImage(urlString: viewModel?.dashBoard.thumbnail_url, placeholder: nil, progress: nil, completionHandle: nil)
        }
    }
    fileprivate func calcViewHeight() {
        let thumbnail_height = CGFloat(viewModel?.dashBoard.thumbnail_height ?? 0)
        let thumbnail_width = CGFloat(viewModel?.dashBoard.thumbnail_width ?? 0)
        let height = (thumbnail_height / thumbnail_width) * PictureViewWidth

        placeholderImage?.frame = CGRect(x: 0, y: 0, width: PictureViewWidth, height: height)
        
        playBtn.center = CGPoint(x: (placeholderImage?.bounds.width ?? 0) / 2, y: (placeholderImage?.bounds.height ?? 0) / 2)
        heightCons?.constant = height
    }
    override func awakeFromNib() {
        super.awakeFromNib()

        playBtn.setImage(UIImage(named: "video_list_cell_big_icon"), for: .normal)
        playBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        playBtn.addTarget(self, action: #selector(play), for: .touchUpInside)

        self.placeholderImage?.addSubview(playBtn)
        // 离屏渲染
        self.layer.drawsAsynchronously = true
        // 栅格化
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    @objc fileprivate func play() {
        playBack?()
    }
}

// MARK: - 点击事件
extension SPHomeTableViewCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.trackingTouch = false
        let t: UITouch = (touches as NSSet).anyObject() as! UITouch
        var p = t.location(in: iconView)
        if (iconView.bounds).contains(p) {
            self.trackingTouch = true
        }
        p = t.location(in: nameLabel)
        if nameLabel.bounds.contains(p) && nameLabel.bounds.size.width > p.x {
            self.trackingTouch = true
        }
        if !trackingTouch {
            super.touchesBegan(touches, with: event)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !trackingTouch {
            super.touchesEnded(touches, with: event)
        } else {
            cellDelegate?.didClickUser?(user: (viewModel?.dashBoard)!)
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !trackingTouch {
            super.touchesCancelled(touches, with: event)
        }
    }
}
