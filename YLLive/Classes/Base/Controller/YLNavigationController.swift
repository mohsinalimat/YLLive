//
//  YLNavigationController.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/25.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit

class YLNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let targetValue = interactivePopGestureRecognizer?.value(forKeyPath: "_targets") as? [NSObject] else {
            return
        }
        
        guard let targetObjc = targetValue.first else {
            return
        }
        
        let target = targetObjc.value(forKeyPath: "target")
        let action = Selector(("handleNavigationTransition:"))
        
        let panGes = UIPanGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(panGes)
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
    }
}

