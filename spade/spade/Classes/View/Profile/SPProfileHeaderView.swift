//
//  SPProfileHeaderView.swift
//  spade
//
//  Created by ntian on 2017/4/17.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

@objc protocol SPProfileHeaderViewDelegate: NSObjectProtocol {
    @objc optional func didClickPostNum()
    @objc optional func didClickFollowingNum()
}

class SPProfileHeaderView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followingNum: UILabel!
    @IBOutlet weak var followersNum:	 UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var postNum: UILabel!
    
    weak var headerViewDelegate: SPProfileHeaderViewDelegate?
    
    var model: SPBlogInfo? {
        didSet {
            guard let model = model else {
                return
            }
            followersNum.text = String(describing: model.blogs?[0].followers ?? 0)
            postNum.text = String(describing: model.blogs?[0].total_posts ?? 0)
            followingNum.text = String(model.following)
            avatarImage.nt_setAvatarImage(urlString: model.avatarURL, placeholder: nil, isAvator: true)
            nameLabel.text = String(describing: model.name ?? " ")
        }
    }
    fileprivate var postTouch = false
    fileprivate var following = false
    fileprivate var followers = false
}
// MARK: - touch
extension SPProfileHeaderView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.postTouch = false
        self.following = false
        self.followers = false
        let t: UITouch = (touches as NSSet).anyObject() as! UITouch
        var p = t.location(in: postNum)
        if (postNum.bounds).contains(p) && postNum.bounds.size.width > p.x {
            self.postTouch = true
        }
        p = t.location(in: followingNum)
        if followingNum.bounds.contains(p) && followingNum.bounds.size.width > p.x && model != nil {
            self.following = true
        }
        p = t.location(in: followersNum)
        if followersNum.bounds.contains(p) && followersNum.bounds.size.width > p.x && model != nil {
            self.followers = true
        }
        if !postTouch || !following || !followers {
            super.touchesBegan(touches, with: event)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !postTouch && !following && !followers {
            super.touchesEnded(touches, with: event)
        } else {
            postTouch ? headerViewDelegate?.didClickPostNum?() : ()
            following ? print("关注") : ()
            followers ? print("粉丝") : ()
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !postTouch || !following || !followers {
            super.touchesCancelled(touches, with: event)
        }
    }

}
