//
//  SpaceCommon.swift
//  spade
//
//  Created by ntian on 2017/4/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

// MARK: - oAuth信息
let CONSUMERKEY = "HkEH8ZjbTtMcvcX6BYONlwHNhsFWi18voM9mqCOcYiDIiv4s3L"
let CONSUMERSECRET = "96wNoKZPTf35pLdpFcUM3CDt7jdAkgFjtSdirWEogjtu4WoFYi"
let REQUESTTOKENURL = "https://www.tumblr.com/oauth/request_token"
let AUTHORIZEURL = "https://www.tumblr.com/oauth/authorize"
let ACCESSTOKENURL = "https://www.tumblr.com/oauth/access_token"
// MAKR: - API信息
let baseURL = "https://api.tumblr.com/v2/"
let dashBoardURL = baseURL + "user/dashboard"
let infoURL = baseURL + "user/info"
