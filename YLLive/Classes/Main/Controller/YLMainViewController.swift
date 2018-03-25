//
//  YLMainViewController.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/25.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit

class YLMainViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpChildVc()
    }
}

// MARK: 设置子控制器
extension YLMainViewController {
    fileprivate func setUpChildVc() {
        
        let homeVc = YLHomeViewController()
        let rankVc = YLRankViewController()
        let discoverVc = YLDiscoverViewController()
        let profileVc = YLProfileViewController()
        
        addChildVc(homeVc, "直播", "live-n", "live-p")
        addChildVc(rankVc, "排行", "ranking-n", "ranking-p")
        addChildVc(discoverVc, "发现", "found-n", "found-p")
        addChildVc(profileVc, "我的", "mine-n", "mine-p")
    }
    
    fileprivate func addChildVc(_ childVc: UIViewController, _ title: String,_ imageName: String,_ selectedImageName: String) {
        
        childVc.title = title
        childVc.tabBarItem.image = originalImage(imageName)
        childVc.tabBarItem.selectedImage = originalImage(selectedImageName)
        childVc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor(hexString: "BE8B52")!], for: .selected)
        
        let naviagtionVc = YLNavigationController(rootViewController: childVc)
        addChildViewController(naviagtionVc)
    }
    
    fileprivate func originalImage(_ imageName: String) -> UIImage?{
        let image = UIImage(named: imageName)
        return image?.withRenderingMode(.alwaysOriginal)
    }
}
