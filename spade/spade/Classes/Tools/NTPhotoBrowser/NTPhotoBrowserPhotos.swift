//
//  NTPhotoBrowserPhotos.swift
//  NTPhotoBrowser
//
//  Created by ntian on 2017/6/13.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class NTPhotoBrowserPhotos: NSObject {

    var selectedIndex: Int = 0
    var urls: [String]?
    var parentImageViews: [UIImageView]?
    
    override var description: String {
        return "\(selectedIndex)---\(String(describing: urls))---\(String(describing: parentImageViews))"
    }
}
