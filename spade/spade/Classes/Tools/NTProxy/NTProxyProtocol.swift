//
//  NTProxyProtocol.swift
//  spade
//
//  Created by ntian on 2017/5/6.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

var session: URLSession!

class NTProxyProtocol: URLProtocol {
    

    var dataTask: URLSessionDataTask?
    // 判断可否处理 传进来的 request 可做分流处理
    override class func canInit(with request: URLRequest) -> Bool {
        if (request.url?.scheme == "spade") {
            print("啊啊啊")
            return true
        }
//        print(request.url)
        return false
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
        let mutableRequest: NSMutableURLRequest = (self.request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: "HandleKey", in: mutableRequest)
        let success: (Data, URLResponse) -> Swift.Void = {
            (data: Data, response: URLResponse) in
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        }

        let configuration = URLSessionConfiguration.default
        let proxyDict : NSDictionary = ["HTTPEnable": Int(1), "HTTPProxy": "119.29.85.125", "HTTPPort": 2333, "HTTPSEnable": Int(1), "HTTPSProxy": "119.29.85.125", "HTTPSPort": 2333]
        if self.request.url?.scheme != "spade" {
            configuration.connectionProxyDictionary = proxyDict as? [AnyHashable : Any]
        } 
        session = URLSession(configuration: configuration)
        dataTask = session.dataTask(with: self.request, completionHandler: { (data, response, error) in
            data != nil ? success(data!, response!) : ()
        })
        dataTask?.resume()

    }
    override func stopLoading() {
        self.dataTask = nil
        self.dataTask?.cancel()

    }
}
