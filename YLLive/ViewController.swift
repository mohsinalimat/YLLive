//
//  ViewController.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/7.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hexString: "##50bbf8")
        automaticallyAdjustsScrollViewInsets = false
        
        let statusBarFrame: CGRect = UIApplication.shared.statusBarFrame
        let navigationBarFrame: CGRect = (self.navigationController?.navigationBar.frame)!

        // Do any additional setup after loading the view, typically from a nib.
        self.title = "YLLive"

        // 1.创建需要的样式
        var style = YLPageStyle()
        style.isScrollEnabel = true
        
        // 2.获取所有的标题
        let titles = ["推荐","游戏","热门游戏","趣玩游戏","娱乐","趣玩","娱乐"]

        // 3.获取所有的内容控制器
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc  = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor
            childVcs.append(vc)
            
        }

        // 4.创建YLPageView
        let headerHeight: CGFloat = statusBarFrame.height + navigationBarFrame.height
        let pageFrame = CGRect(x: 0, y:headerHeight , width: view.bounds.width, height: view.bounds.height - headerHeight)
        let pageView = YLPageView(frame: pageFrame, style: style, titles: titles, childVcs: childVcs, parentVc: self)
        pageView.backgroundColor = UIColor.blue
        view.addSubview(pageView)
    }

}


