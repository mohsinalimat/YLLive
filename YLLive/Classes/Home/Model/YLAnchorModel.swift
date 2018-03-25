//
//  YLAnchorModel.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/25.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit

class YLAnchorViewModel: YLBaseModel {
    var roomid: Int = 0
    var name: String = ""
    var pic51: String = ""
    var pic74: String = ""
    var live: Int = 0 // 是否在直播
    var push: Int = 0 // 直播显示方式
    var focus: Int = 0 // 关注数
    
    var isEvenIndex: Bool = false
    
}
