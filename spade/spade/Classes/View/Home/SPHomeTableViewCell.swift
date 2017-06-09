//
//  SPHomeTableViewCell.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

@objc protocol SPHomeTableViewCellDelegate: NSObjectProtocol {
    @objc optional func didClickUser(name: String)
}
class SPHomeTableViewCell: UITableViewCell {
    
    fileprivate var likeImage = UIImage(named: "glyph-like")
    fileprivate var likedImage = UIImage(named: "glyph-liked")
    
    @IBOutlet weak var noteLabel: UILabel!
    // 正文
    @IBOutlet weak var statusLabel: UILabel!
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    // 时间
    @IBOutlet weak var timeLabel: UILabel!
    // 头像
    @IBOutlet weak var iconView: UIImageView!
    /// 爱心喜欢
    @IBOutlet weak var likeIcon: UIButton!
    /// 配图视图
    @IBOutlet weak var pictureView: SPHomePictureView?
    /// 占位图
    @IBOutlet weak var placeholderImage: UIImageView?
    /// 下载按钮
    @IBOutlet weak var downloadBtn: UIButton?
    @IBOutlet weak var heightCons: NSLayoutConstraint?
    // 播放按钮
    fileprivate let playBtn = UIButton(type: .custom)
    fileprivate var trackingTouch = false
    fileprivate lazy var messageHud: NTMessageHud = NTMessageHud()

    @IBOutlet weak var reportBtn: UIButton!
    
    public weak var cellDelegate: SPHomeTableViewCellDelegate?
    /// 举报标识符
//    private var reportFlag = false
    /// 播放按钮回调
    var playBack: (()->())?

    var viewModel: SPDashBoardViewModel? {
        
        didSet {
            nameLabel.text = viewModel?.dashBoard.blog_name
            statusLabel.text = viewModel?.dashBoard.summary
            iconView.nt_setAvatarImage(urlString: viewModel?.avatarURL, placeholder: nil, isAvator: true)
            if viewModel?.dashBoard.liked == 1 {
                likeIcon.setImage(likedImage, for: .normal)
            } else {
                likeIcon.setImage(likeImage, for: .normal)
            }
            timeLabel.text = viewModel?.dashBoard.createDate?.nt_dateDescription
            noteLabel?.text = viewModel?.note_count
            pictureView?.urls = viewModel?.dashBoard.photos
            pictureView?.viewModel = viewModel
            
            calcViewHeight()
            placeholderImage?.nt_setImage(urlString: viewModel?.dashBoard.thumbnail_url, placeholder: nil, progress: nil, completionHandle: nil)
            if inReview {
                downloadBtn?.isHidden = true
            }
        }
    }
    fileprivate func calcViewHeight() {
//        let thumbnail_height = CGFloat((viewModel?.dashBoard.thumbnail_height)!)
//        let thumbnail_width = CGFloat((viewModel?.dashBoard.thumbnail_width)!)
//        var height = (thumbnail_height / thumbnail_width) * PictureViewWidth
//        if height.isNaN {
//            height = (720 / 1280) * PictureViewWidth
//        }
        let height = viewModel?.videoHeight ?? 0

        placeholderImage?.frame = CGRect(x: 0, y: 0, width: PictureViewWidth, height: height)
        
        playBtn.center = CGPoint(x: (placeholderImage?.bounds.width ?? 0) / 2, y: (placeholderImage?.bounds.height ?? 0) / 2)
        heightCons?.constant = height
    }
    
    @IBAction func report() {
        let btnAnime = CAKeyframeAnimation(keyPath: "transform.scale")
        btnAnime.values = [1.0,0.7,0.5,0.3,0.5,0.7,1.0,1.2,1.4,1.2,1.0]
        btnAnime.keyTimes = [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]
        btnAnime.duration = 0.2
        reportBtn.layer.add(btnAnime, forKey: "SHOW")
//        if reportFlag == false {
            messageHud.showMessage(view: (self.superview?.superview?.superview)!, msg: NSLocalizedString("ReportSuccess", comment: "举报成功"), isError: false)
//            reportFlag = true
//        }
    }
    @IBAction func downBtn(_ sender: UIButton) {
        guard let video_url = viewModel?.dashBoard.video_url, let fileImage = viewModel?.dashBoard.thumbnail_url else {
            messageHud.showMessage(view: (self.superview?.superview?.superview)!, msg: NSLocalizedString("VideoDeleted", comment: "视频已被删除"), isError: true)
            return
        }
        messageHud.showMessage(view: (self.superview?.superview?.superview)!, msg: NSLocalizedString("AddDownloadSuccess", comment: "添加下载成功"), isError: false)
        NTDownloadManager.shared.newTask(urlString: video_url, fileImage: fileImage)
    }
    @IBAction func likeBtn(_ sender: UIButton) {
        // 爱心按钮大小关键帧动画
        let btnAnime = CAKeyframeAnimation(keyPath: "transform.scale")
        btnAnime.values = [1.0,0.7,0.5,0.3,0.5,0.7,1.0,1.2,1.4,1.2,1.0]
        btnAnime.keyTimes = [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]
        btnAnime.duration = 0.2
        sender.layer.add(btnAnime, forKey: "SHOW")
        
        if viewModel?.dashBoard.liked == 0 {
            self.viewModel?.dashBoard.liked = 1
            likeIcon.setImage(likedImage, for: .normal)
            let heart = DMHeartFlyView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            heart.center = CGPoint(x: likeIcon.frame.origin.x, y: likeIcon.frame.origin.y)
            self.superview?.superview?.superview?.addSubview(heart)
            heart.animate(in: self.superview?.superview?.superview)
            // 就是还没喜欢的时候..
            SPNetworkManage.shared.userLike(id: viewModel?.dashBoard.id ?? 0, reblogKey: viewModel?.dashBoard.reblog_key ?? "", completion: { (isSuccess) in
                if isSuccess {
                    self.viewModel?.dashBoard.liked = 1
                } else {
                    self.viewModel?.dashBoard.liked = 0
//                    self.messageHud.showMessage(view: (self.superview?.superview?.superview)!, msg: "喜欢失败啦~", isError: true)
                    self.likeIcon.setImage(self.likeImage, for: .normal)
                }
            })
        } else {
            self.viewModel?.dashBoard.liked = 0
            likeIcon.setImage(likeImage, for: .normal)
            // 已经喜欢了 要取消喜欢
            SPNetworkManage.shared.userUnLike(id: viewModel?.dashBoard.id ?? 0, reblogKey: viewModel?.dashBoard.reblog_key ?? "", completion: { (isSuccess) in
                if isSuccess {
                    self.viewModel?.dashBoard.liked = 0
                } else {
                    self.viewModel?.dashBoard.liked = 1
                    self.likeIcon.isSelected = !self.likeIcon.isSelected
//                    self.messageHud.showMessage(view: (self.superview?.superview?.superview)!, msg: "取消喜欢失败啦~", isError: true)
                    self.likeIcon.setImage(self.likedImage, for: .normal)

                }
            })
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()

        playBtn.setImage(UIImage(named: "video_list_cell_big_icon"), for: .normal)
        playBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
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
            cellDelegate?.didClickUser?(name: (viewModel?.dashBoard.blog_name)!)
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !trackingTouch {
            super.touchesCancelled(touches, with: event)
        }
    }
}
