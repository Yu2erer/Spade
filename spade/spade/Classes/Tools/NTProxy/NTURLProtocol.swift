//
//  NTURLProtocol.swift
//  URLProtocol
//
//  Created by ntian on 2017/5/20.
//  Copyright © 2017年 ntian. All rights reserved.
//

import Foundation

class NTURLProtocol: URLProtocol {
    
    var dataTask: URLSessionDataTask?
    fileprivate let proxyDict : NSDictionary = ["HTTPEnable": Int(1), "HTTPProxy": "119.29.85.125", "HTTPPort": 2333, "HTTPSEnable": Int(1), "HTTPSProxy": "119.29.85.125", "HTTPSPort": 2333]
    
    override class func canInit(with request: URLRequest) -> Bool {
        
        print("URL: \(request)")
        if URLProtocol.property(forKey: "MyURLProtocolHandledKey", in: request) != nil {
            return false
        }
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(a, to: b)
    }
    override func startLoading() {
        let newRequest = (self.request as NSURLRequest).copy() as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: "MyURLProtocolHandledKey", in: newRequest)
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.connectionProxyDictionary = proxyDict as? [AnyHashable : Any]
        let session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        dataTask = session.dataTask(with: newRequest as URLRequest, completionHandler: { (data, response, error) in
            if data != nil && response != nil {
                self.client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: data!)
                self.client?.urlProtocolDidFinishLoading(self)
            }
        })
        dataTask?.resume()

        dataTask?.resume()
    }
    override func stopLoading() {
        if dataTask != nil {
            dataTask?.cancel()
        }
        dataTask = nil
    }
}
extension NTURLProtocol: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        let request = (request as NSURLRequest).copy() as! NSMutableURLRequest
        URLProtocol.removeProperty(forKey: "MyURLProtocolHandledKey", in: request)
        client?.urlProtocol(self, wasRedirectedTo: request as URLRequest, redirectResponse: response)
        task.cancel()
        
    }
}
