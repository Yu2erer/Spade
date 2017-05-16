//
//  NTDownloadTask.swift
//  NTDownload
//
//  Created by ntian on 2017/5/1.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import Foundation

enum NTDownloadState {
    case NTWillDownload
    case NTDownloading
    case NTStopDownload
}
class NTDownloadTask: NSObject {
    
    var url: URL
    var taskIdentifier: Int
    var finished = false
    var fileImage: String
    var fileReceivedSize: Int64 = 0
    var fileSize: Int64 = 0
    var name: String
    var downloadState: NTDownloadState?
    init(url: URL, taskIdentifier: Int, fileImage: String) {
        self.url = url
        name = (url.absoluteString as NSString).lastPathComponent
        self.taskIdentifier = taskIdentifier
        self.fileImage = fileImage
    }
}
