//
//  SpaceCommon.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import Foundation

// MARK: - 是否在审核期内
// 控制该次版本功能的Id 每次上传到store一定要改！！！！
let inReviewObjectId = "59216c1fa0bb9f005f543183"
var inReview = false
//let inReview: Bool = {
////    return false
////     大过他了 说明过了审核期 小过他 则没过审核期
//    return Int(Date().timeIntervalSince1970) > 1495857600
//}()
// MARK: - 代理信息
let proxyDict: NSDictionary = ["HTTPEnable": Int(1), "HTTPProxy": "119.29.85.125", "HTTPPort": 443, "HTTPSEnable": Int(1), "HTTPSProxy": "119.29.85.125", "HTTPSPort": 443]
let appLanaguage: String = {
    let applanaguage = UserDefaults.standard.object(forKey: "AppleLanguages") as! NSArray
    if (applanaguage.object(at: 0) as! String).hasPrefix("en") {
        return "_en"
    } else {
        return "_zh"
    }
}()
// MARK: - oAuth信息
let CONSUMERKEY = SPNetworkManage.shared.userAccount.Key ?? SPNetworkManage.shared.userAccount.CONSUMERKEY
let CONSUMERSECRET = SPNetworkManage.shared.userAccount.Secret ?? SPNetworkManage.shared.userAccount.CONSUMERSECRET
let REQUESTTOKENURL = "https://www.tumblr.com/oauth/request_token"
let AUTHORIZEURL = "https://www.tumblr.com/oauth/authorize"
let ACCESSTOKENURL = "https://www.tumblr.com/oauth/access_token"
// MAKR: - API信息
let spadeBaseURL = "https://spade.mooe.me"
let spadeAvatarURL = spadeBaseURL + "/api/v2/blog/"
let baseURL = "https://api.tumblr.com/v2/"
let dashBoardURL = baseURL + "user/dashboard"
let infoURL = baseURL + "user/info"
let blogInfoURL = baseURL + "blog/"
let likesURL = baseURL + "user/likes"
let like = baseURL + "user/like"
let unLike = baseURL + "user/unlike"
let followingURL = baseURL + "user/following"
let follow = baseURL + "user/follow"
let unFollow = baseURL + "user/unfollow"
let tagUrl = baseURL + "tagged"
// MARK: - 全局通知定义
let SPUserShouldLoginNotification = "SPUserShouldLoginNotification"
let SPUserLoginSuccessedNotification = "SPUserLoginSuccessedNotification"
// 下载进度条通知定义
let SPUpdateProgressNotification = "SPUpdateProgressNotification"
// 图片通知定义
let SPHomeCellBrowserPhotoNotification = "SPHomeCellBrowserPhotoNotification"
let SPHomeCellBrowserPhotoSelectedIndexKey = "SPHomeCellBrowserPhotoSelectedIndexKey"
let SPHomeCellBrowserPhotoURLsKey = "SPHomeCellBrowserPhotoURLsKey"
let SPHomeCellBrowserPhotoImageView = "SPHomeCellBrowserPhotoImageView"
// MARK: - 配图视图
/// 配图视图外部间距
let PictureViewOutterMargin = CGFloat(11)
/// 配图视图内部间距
let PictureViewInnerMargin = CGFloat(3)
/// 屏幕宽度
let PictureViewWidth = UIScreen.main.bounds.width
/// 屏幕高度
let PictureViewHeight = UIScreen.main.bounds.height
// MARK: - UserInfo 用户信息存储
let isHaveSetting = UserDefaults.UserSetting.string(forKey: .isHaveSetting)
var isSmallWindowOn: Bool = UserDefaults.UserSetting.bool(forKey: .isSmallWindowOn)
