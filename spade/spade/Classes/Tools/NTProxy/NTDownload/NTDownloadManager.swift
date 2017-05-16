//
//  NTDownloadManager.swift
//  NTDownload
//
//  Created by ntian on 2017/5/1.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

@objc protocol NTDownloadDelegate: NSObjectProtocol {
    @objc optional func finishedDownload()
    @objc optional func updateCellProgress(model: NTDownloadTask)
}
class NTDownloadManager: URLSessionDownloadTask {

    private var session: URLSession?
    var taskList = [NTDownloadTask]()
    static let shared = NTDownloadManager()
    weak var downloadDelegate: NTDownloadDelegate?
    

    override init() {
        super.init()
        
        let config = URLSessionConfiguration.default
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        self.taskList = [NTDownloadTask]()
        self.loadTaskList()
    }
    /// 未完成列表
    func unFinishedList() -> [NTDownloadTask] {
        return taskList.filter({ (task) -> Bool in
            return task.finished == false
        })
    }
    /// 完成列表
    func finishedList() -> [NTDownloadTask] {
        return taskList.filter({ (task) -> Bool in
            return task.finished == true
        })
    }
    func cleanTask() {
        taskList.removeAll()
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        for i in 0..<taskList.count {
            try? FileManager.default.removeItem(atPath: "\(path)/\(taskList[i].name)")
        }
        path = "\(path)/NTDownload.plist"
        try? FileManager.default.removeItem(atPath: path)
    }
    func saveTaskList() {
        
        let jsonArray = NSMutableArray()
        for task in taskList {
            if task.finished == true {
                let jsonItem = NSMutableDictionary()
                jsonItem["url"] = task.url.absoluteString
                jsonItem["taskIdentifier"] = task.taskIdentifier
                jsonItem["finished"] = task.finished
                jsonItem["fileImage"] = task.fileImage
                jsonArray.add(jsonItem)
            }
        }
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = "\(path)/NTDownload.plist"
        jsonArray.write(toFile: path, atomically: true)
        print(path)
    }
    func deleteTask(fileInfo: NTDownloadTask) {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        for i in 0..<taskList.count {
            if (fileInfo.url == taskList[i].url) {
                path = "\(path)/\(fileInfo.name)"
                taskList.remove(at: i)
                try? FileManager.default.removeItem(atPath: path)
                saveTaskList()
                break
            }
        }
    }
    func loadTaskList() {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = "\(path)/NTDownload.plist"
        guard let jsonArray = NSArray(contentsOfFile: path) else {
            return
        }
  
        for jsonItem in jsonArray {
            guard let item = jsonItem as? NSDictionary, let urlString = item["url"] as? String, let taskIdentifier = item["taskIdentifier"] as? Int, let finished = item["finished"] as? Bool, let fileImage = item["fileImage"] as? String else {
                return
            }
            let url = URL(string: urlString)
            let downloadTask = NTDownloadTask(url: url!, taskIdentifier: taskIdentifier, fileImage: fileImage)
            downloadTask.finished = finished
            self.taskList.append(downloadTask)


        }
    }
    /// 下载文件
    func newTask(urlString: String, fileImage: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        for i in 0..<taskList.count {
            if taskList[i].url == url {
                return
            }
        }
        let downloadTask = self.session?.downloadTask(with: url)
        downloadTask?.resume()
        let task = NTDownloadTask(url: url, taskIdentifier: downloadTask?.taskIdentifier ?? 0, fileImage: fileImage)
        task.downloadState = .NTDownloading
        self.taskList.append(task)
        self.saveTaskList()
    }
}
// MARK: - URLSessionDownloadDelegate
extension NTDownloadManager: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        var fileName: String?
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        for i in 0..<taskList.count {
            if self.taskList[i].taskIdentifier == downloadTask.taskIdentifier {
                self.taskList[i].finished = true
                fileName = self.taskList[i].url.lastPathComponent
                let destURL = documentURL.appendingPathComponent(fileName ?? "")
                let _ = try? FileManager.default.moveItem(at: location, to: destURL)
            }
        }
        self.saveTaskList()
        downloadDelegate?.finishedDownload?()
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        for i in 0..<taskList.count {
            if self.taskList[i].taskIdentifier == downloadTask.taskIdentifier {
                self.taskList[i].fileSize = totalBytesExpectedToWrite
                self.taskList[i].fileReceivedSize = totalBytesWritten
                downloadDelegate?.updateCellProgress?(model: taskList[i])
            }
        }
    }
}
