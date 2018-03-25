//
//  YLHomeViewModel.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/25.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit

class YLHomeViewModel {
    lazy var anchorModels = [YLAnchorViewModel]()
}

extension YLHomeViewModel {
    func loadHomeData(type: YLHomeType, index: Int, finishedCallBack: @escaping() -> ()) {
        YLNetworkTools.requestData(.get, URLString: "http://qf.56.com/home/v4/moreAnchor.ios", parameters: ["type": type.type, "index": index, "size": 48]) { (result) in
            
            guard let resultDict = result as? [String: Any] else {return}
            guard let messageDic = resultDict["message"] as? [String: Any] else {return}
            guard let dataArray = messageDic["anchors"] as? [[String: Any]] else {return}
            
            for (index, dict) in dataArray.enumerated() {
                let anchor = YLAnchorViewModel(dict: dict)
                anchor.isEvenIndex = index % 2 == 0
                self.anchorModels.append(anchor)
            }
            
            finishedCallBack()
        }
    }
}
