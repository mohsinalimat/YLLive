//
//  YLKingfisherExtension.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/27.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {

    func setImage(_ URLString : String?, _ placeHolderName : String?) {
        guard let URLString = URLString else {
            return
        }
        
        guard let placeHolderName = placeHolderName else {
            return
        }
        
        guard let url = URL(string: URLString) else { return }
        kf.setImage(with: url, placeholder : UIImage(named: placeHolderName))
    }
}
