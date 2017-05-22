//
//  SPDownloadingViewCell.swift
//  spade
//
//  Created by ntian on 2017/5/22.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPDownloadingViewCell: UITableViewCell {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var fileName: UILabel!
    fileprivate var progress: Float = 0
    var fileInfo: NTDownloadTask? {
        didSet {
            fileName.text = fileInfo?.name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(updateProgress), name: NSNotification.Name(rawValue: SPUpdateProgressNotification), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func updateProgress(n: Notification) {
        guard let model = n.userInfo?["downloadModel"] as? NTDownloadTask else {
            return
        }
        if model.taskIdentifier == fileInfo?.taskIdentifier {
            if model.fileSize == 0 {
                progress = 0
            } else {
                progress = Float(model.fileReceivedSize) / Float(model.fileSize)
            }
            self.progressView.progress = progress
        }
    }
}
