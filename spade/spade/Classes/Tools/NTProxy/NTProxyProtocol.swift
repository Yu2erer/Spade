//
//  NTProxyProtocol.swift
//  spade
//
//  Created by ntian on 2017/5/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

class NTProxyProtocol: URLProtocol {
    
    var session = URLSession()

    var dataTask: URLSessionDataTask?
    // 判断可否处理 传进来的 request 可做分流处理
    override class func canInit(with request: URLRequest) -> Bool {
        if (URLProtocol.property(forKey: "HandleKey", in: request) != nil) {
            return false
        }
        return true
    }
    // 回规范化请求 原来那个返回就行了
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    // 判断是否有缓存 交给父类处理
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(a, to: b)
    }
    override func startLoading() {
        let configuration = URLSessionConfiguration.default
        let proxyDict : NSDictionary = ["HTTPEnable": Int(1), "HTTPProxy": "119.29.85.125", "HTTPPort": 2333, "HTTPSEnable": Int(1), "HTTPSProxy": "119.29.85.125", "HTTPSPort": 2333]
        configuration.connectionProxyDictionary = proxyDict as? [AnyHashable : Any]
        self.session = URLSession(configuration: configuration)
        dataTask = self.session.dataTask(with: self.request, completionHandler: { (data, _, _) in
//            self.client?.urlProtocol(self, didLoad: data!)
            self.dataTask?.resume()

        })
    }
    override func stopLoading() {
//        self.dataTask = nil
        self.dataTask?.cancel()

    }
}
