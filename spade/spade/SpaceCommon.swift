//
//  SpaceCommon.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import Foundation

// MARK: - oAuth信息
let CONSUMERKEY = SPNetworkManage.shared.haveKeyAndSecret ? SPNetworkManage.shared.userAccount.Key : SPNetworkManage.shared.userAccount.CONSUMERKEY
let CONSUMERSECRET = SPNetworkManage.shared.haveKeyAndSecret ? SPNetworkManage.shared.userAccount.Secret : SPNetworkManage.shared.userAccount.CONSUMERSECRET
let REQUESTTOKENURL = "https://www.tumblr.com/oauth/request_token"
let AUTHORIZEURL = "https://www.tumblr.com/oauth/authorize"
let ACCESSTOKENURL = "https://www.tumblr.com/oauth/access_token"
// MAKR: - API信息
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
// 图片通知定义
let SPHomeCellBrowserPhotoNotification = "SPHomeCellBrowserPhotoNotification"
let SPHomeCellBrowserPhotoSelectedIndexKey = "SPHomeCellBrowserPhotoSelectedIndexKey"
let SPHomeCellBrowserPhotoURLsKey = "SPHomeCellBrowserPhotoURLsKey"
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
let isOpenFucWall: Bool = true
