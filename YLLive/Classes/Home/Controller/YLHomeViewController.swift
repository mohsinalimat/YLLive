//
//  HomeViewController.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/24.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit

class YLHomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
}


// MARK: 设置UI
extension YLHomeViewController {
    fileprivate func setUpUI() {
        
        setUpNavigaitonbar()
        setUpContentView()
    }
    
    fileprivate func setUpNavigaitonbar() {
        let logoImage = UIImage(named: "home-logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        
        let collectImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(collectItemClick))
        
        // MARK: 解决在iOS 11上searchBar导致导航栏变高问题
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 32))
        let searchBar = UISearchBar(frame: CGRect(x: -10, y: 0, width: 250, height: 32))
        searchBar.placeholder = "主播昵称/房间号/链接"
        searchBar.searchBarStyle = .minimal
        titleView.addSubview(searchBar)
        navigationItem.titleView = titleView
        
        let searchField = searchBar.value(forKey: "_searchField") as? UITextField
        searchField?.textColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
    }
    
    fileprivate func setUpContentView() {
        // 获取数据
        let homeTypes = loadTypesData()
        
        // 创建主题内容
        var style = YLPageStyle()
        style.isScrollEnable = true
        
        let pageFrame = CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - 44)
        let titles = homeTypes.map({ $0.title })
        var childVcs = [YLAnchorViewController]()
        for type in homeTypes {
            let anchorVc = YLAnchorViewController()
            anchorVc.homeType = type
            childVcs.append(anchorVc)
        }
        
        let pageView = YLPageView(frame: pageFrame, style: style, titles: titles, childVcs: childVcs, parentVc: self)
        view.addSubview(pageView)
    }
    
    fileprivate func loadTypesData() -> [YLHomeType] {
        let path = Bundle.main.path(forResource: "types.plist", ofType: nil)!
        let dataArray = NSArray(contentsOfFile: path) as! [[String : Any]]
        var tempArray = [YLHomeType]()
        for dict in dataArray {
            tempArray.append(YLHomeType(dict: dict))
        }
        return tempArray
    }
}

// MARK: 事件处理
extension YLHomeViewController {
    @objc fileprivate func collectItemClick() {
        print("弹出收藏控制器")
    }
}
