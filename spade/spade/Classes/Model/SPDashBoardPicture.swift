//
//  SPDashBoardPicture.swift
//  spade
//
//  Created by ntian on 2017/4/9.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit

class SPDashBoardPicture: NSObject {
    
    var original_size: SPOriginal_size?
    var alt_sizes: [SPAlt_sizes]?

    override var description: String {
        return yy_modelDescription()
    }
    class func modelContainerPropertyGenericClass() -> [String: Any] {
        return ["alt_sizes": SPAlt_sizes.self]
    }
}
class SPAlt_sizes: NSObject {
    var url: String? {
        didSet {
            if inReview == false {
                url = spadeBaseURL + (url?.removeMediaString() ?? "")
            }
        }
    }
    var width: String?
    var height: String?
}
class SPOriginal_size: NSObject {
    var url: String? {
        didSet {
            if inReview == false {
                url = spadeBaseURL + (url?.removeMediaString() ?? "")
            }
        }
    }
    var width: String?
    var height: String?
}
