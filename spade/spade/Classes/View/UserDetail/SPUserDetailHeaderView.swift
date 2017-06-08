//
//  SPProfileHeaderView.swift
//  spade
//
//  Created by ntian on 2017/4/17.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import SVProgressHUD

@objc protocol SPUserDetailHeaderViewDelegate: NSObjectProtocol {
    @objc optional func didClickPostNum()
    @objc optional func didClickLikeNum(user: SPBlogInfo)
    @objc optional func didClickAvatar()
}

class SPUserDetailHeaderView: UIView {
    
    // 只是为了让用户更好点而已。。
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var likesNum: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var postNum: UILabel!
    weak var headerViewDelegate: SPUserDetailHeaderViewDelegate?
    var model: SPBlogInfo? {
        didSet {
            guard let model = model else {
                return
            }
            if model.likes > 0 {
                likesNum.text = String(model.likes)
            } else {
                likesNum.text = NSLocalizedString("invisible", comment: "不可见")
            }
            
            postNum.text = String(model.total_posts)
            avatarImage.nt_setAvatarImage(urlString: model.avatarURL, placeholder: nil, isAvator: true)
            nameLabel.text = String(describing: model.name ?? "")
            if model.admin == 0 {
                followBtn.isHidden = false
                if model.followed == 1 {
                    // 关注了
                    followBtn.setImage(UIImage(named: "followedBtn\(appLanaguage)"), for: .normal)
                    followBtn.setImage(UIImage(named: "followedHighlight\(appLanaguage)"), for: .highlighted)
                } else {
                    followBtn.setImage(UIImage(named: "followBtn\(appLanaguage)"), for: .normal)
                    followBtn.setImage(UIImage(named: "followHighlight\(appLanaguage)"), for: .highlighted)
                }
            }
        }
    }
    
    @IBAction func followAct(_ sender: UIButton) {
        guard let name = model?.name else {
            return
        }
        SVProgressHUD.show()
        // 还没关注点了 关注
        if model?.followed == 0 {
            SPNetworkManage.shared.userFollow(blogUrl: name + ".tumblr.com", completion: { (isSuccess) in
                if isSuccess {
                    SVProgressHUD.dismiss()
                    self.followBtn.setImage(UIImage(named: "followedBtn\(appLanaguage)"), for: .normal)
                    self.followBtn.setImage(UIImage(named: "followedHighlight\(appLanaguage)"), for: .highlighted)
                    self.model?.followed = 1
                } else {
                    SVProgressHUD.dismiss()
                    self.followBtn.setImage(UIImage(named: "followBtn\(appLanaguage)"), for: .normal)
                    self.followBtn.setImage(UIImage(named: "followHighlight\(appLanaguage)"), for: .highlighted)
                }
            })
        } else {
            SPNetworkManage.shared.userUnFollow(blogUrl: name, completion: { (isSuccess) in
                if isSuccess {
                    SVProgressHUD.dismiss()
                    self.followBtn.setImage(UIImage(named: "followBtn\(appLanaguage)"), for: .normal)
                    self.followBtn.setImage(UIImage(named: "followHighlight\(appLanaguage)"), for: .highlighted)
                    self.model?.followed = 0
                } else {
                    SVProgressHUD.dismiss()
                    self.followBtn.setImage(UIImage(named: "followedBtn\(appLanaguage)"), for: .normal)
                    self.followBtn.setImage(UIImage(named: "followedHighlight\(appLanaguage)"), for: .highlighted)

                }
            })
        }
    }
    fileprivate var postTouch: Bool = false
    fileprivate var likeTouch: Bool = false
    fileprivate var avatarTouch: Bool = false
}
// MARK: - touch
extension SPUserDetailHeaderView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.postTouch = false
        self.likeTouch = false
        self.avatarTouch = false
        let t: UITouch = (touches as NSSet).anyObject() as! UITouch
        var p = t.location(in: postNum)
        if (postNum.bounds).contains(p) && postNum.bounds.size.width > p.x {
            self.postTouch = true
        }
        p = t.location(in: postLabel)
        if (postLabel.bounds).contains(p) && postLabel.bounds.size.width > p.x {
            self.postTouch = true
        }
        p = t.location(in: likesNum)
        if likesNum.bounds.contains(p) && likesNum.bounds.size.width > p.x && model?.likes != 0 && (model != nil) {
            self.likeTouch = true
        }
        p = t.location(in: likeLabel)
        if likeLabel.bounds.contains(p) && likeLabel.bounds.size.width > p.x && model?.likes != 0 && (model != nil) {
            self.likeTouch = true
        }
        p = t.location(in: avatarImage)
        if avatarImage.bounds.contains(p) && model != nil {
            self.avatarTouch = true
        }
        if !postTouch || !likeTouch || !avatarTouch {
            super.touchesBegan(touches, with: event)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !postTouch && !likeTouch && !avatarTouch {
            super.touchesEnded(touches, with: event)
        } else {
            postTouch ? headerViewDelegate?.didClickPostNum?() : ()
            likeTouch ? headerViewDelegate?.didClickLikeNum?(user: model!) : ()
            avatarTouch ? headerViewDelegate?.didClickAvatar?() : ()
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !postTouch || !likeTouch || !avatarTouch {
            super.touchesCancelled(touches, with: event)
        }
    }

}
