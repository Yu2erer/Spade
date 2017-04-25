//
//  SPProfileHeaderView.swift
//  spade
//
//  Created by ntian on 2017/4/17.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

@objc protocol SPUserDetailHeaderViewDelegate: NSObjectProtocol {
    @objc optional func didClickPostNum()
    @objc optional func didClickLikeNum(user: SPBlogInfo)
}

class SPUserDetailHeaderView: UIView {
    
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
            postNum.isHidden = false
            likesNum.isHidden = false
            if model.likes > 0 {
                likesNum.text = String(model.likes)
            } else {
                likesNum.text = "不可见"
            }
            
            postNum.text = String(model.total_posts)
            avatarImage.nt_setAvatarImage(urlString: model.avatarURL, placeholder: nil, isAvator: true)
            nameLabel.text = String(describing: model.name ?? "")
            if model.admin == 0 {
                followBtn.isHidden = false
                if model.followed == 1 {
                    // 关注了
                    followBtn.setImage(UIImage(named: "followedBtn"), for: .normal)
                    followBtn.setImage(UIImage(named: "followedHighlight"), for: .highlighted)
                } else {
                    followBtn.setImage(UIImage(named: "followBtn"), for: .normal)
                    followBtn.setImage(UIImage(named: "followHighlight"), for: .highlighted)
                }
            }
        }
    }
    fileprivate var postTouch: Bool = false
    fileprivate var likeTouch: Bool = false
}
// MARK: - touch
extension SPUserDetailHeaderView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.postTouch = false
        self.likeTouch = false
        let t: UITouch = (touches as NSSet).anyObject() as! UITouch
        var p = t.location(in: postNum)
        if (postNum.bounds).contains(p) && postNum.bounds.size.width > p.x {
            self.postTouch = true
        }
        p = t.location(in: likesNum)
        if likesNum.bounds.contains(p) && likesNum.bounds.size.width > p.x && model?.likes != 0 {
            self.likeTouch = true
        }
        if !postTouch || !likeTouch {
            super.touchesBegan(touches, with: event)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !postTouch && !likeTouch {
            super.touchesEnded(touches, with: event)
        } else {
            postTouch ? headerViewDelegate?.didClickPostNum?() : ()
            likeTouch ? headerViewDelegate?.didClickLikeNum?(user: model!) : ()
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !postTouch || !likeTouch {
            super.touchesCancelled(touches, with: event)
        }
    }

}
