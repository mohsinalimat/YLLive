//
//  YLNetworkTools.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/25.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

class YLNetworkTools {
    class func requestData(_ type: MethodType, URLString: String, parameters: [String: Any]? = nil, finishedCallBack: @escaping(_ result: Any) ->()){
        
        // 获取类型
        let method = type ==  .get ? HTTPMethod.get : HTTPMethod.post
        
        // 发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).validate(contentType: ["text/plain"]).responseJSON { (response) in
            
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            finishedCallBack(result)
        }
    }
}
