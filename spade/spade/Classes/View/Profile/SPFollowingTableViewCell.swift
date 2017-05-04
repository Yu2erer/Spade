//
//  SPFollowingTableViewCell.swift
//  spade
//
//  Created by ntian on 2017/5/3.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import SVProgressHUD

@objc protocol SPFollowingTableViewCellDelegate: NSObjectProtocol {
    @objc optional func didClickUser(name: String)
}
class SPFollowingTableViewCell: UITableViewCell {

    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    var model: SPBlogInfo? {
        didSet {
            nameLabel.text = model?.name
            avatarImage.nt_setAvatarImage(urlString: model?.avatarURL, placeholder: nil, isAvator: true)
            titleLabel.text = model?.title
            model?.followed = 1
            // 关注了
            followBtn.setImage(UIImage(named: "followedBtn"), for: .normal)
            followBtn.setImage(UIImage(named: "followedHighlight"), for: .highlighted)
        }
    }
    fileprivate var trackingTouch = false
    public weak var cellDelegate: SPFollowingTableViewCellDelegate?

    @IBAction func follow(_ sender: UIButton) {
        SVProgressHUD.show()
        // 还没关注点了 关注
        if model?.followed == 0 {
            SPNetworkManage.shared.userFollow(blogUrl: (model?.name)! + ".tumblr.com", completion: { (isSuccess) in
                if isSuccess {
                    SVProgressHUD.dismiss()
                    self.followBtn.setImage(UIImage(named: "followedBtn"), for: .normal)
                    self.followBtn.setImage(UIImage(named: "followedHighlight"), for: .highlighted)
                    self.model?.followed = 1
                } else {
                    SVProgressHUD.dismiss()
                    self.followBtn.setImage(UIImage(named: "followBtn"), for: .normal)
                    self.followBtn.setImage(UIImage(named: "followHighlight"), for: .highlighted)
                }
            })
        } else {
            SPNetworkManage.shared.userUnFollow(blogUrl: (model?.name)!, completion: { (isSuccess) in
                if isSuccess {
                    SVProgressHUD.dismiss()
                    self.followBtn.setImage(UIImage(named: "followBtn"), for: .normal)
                    self.followBtn.setImage(UIImage(named: "followHighlight"), for: .highlighted)
                    self.model?.followed = 0
                } else {
                    SVProgressHUD.dismiss()
                    self.followBtn.setImage(UIImage(named: "followedBtn"), for: .normal)
                    self.followBtn.setImage(UIImage(named: "followedHighlight"), for: .highlighted)
                    
                }
            })
        }
    }
}
// MARK: - event
extension SPFollowingTableViewCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.trackingTouch = false
        let t: UITouch = (touches as NSSet).anyObject() as! UITouch
        var p = t.location(in: avatarImage)
        if (avatarImage.bounds).contains(p) {
            self.trackingTouch = true
        }
        p = t.location(in: nameLabel)
        if nameLabel.bounds.contains(p) && nameLabel.bounds.size.width > p.x {
            self.trackingTouch = true
        }
        p = t.location(in: titleLabel)
        if titleLabel.bounds.contains(p) && titleLabel.bounds.size.width > p.x {
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
            cellDelegate?.didClickUser?(name: (model?.name)!)
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !trackingTouch {
            super.touchesCancelled(touches, with: event)
        }
    }
}
