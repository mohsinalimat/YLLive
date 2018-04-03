//
//  YLRoomViewController.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/25.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit

class YLRoomViewController: UIViewController {

    // MARK: 控件属性
    @IBOutlet weak var bgImageView: UIImageView!
    
    // MARK: 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}


// MARK:- 设置UI界面内容
extension YLRoomViewController {
    fileprivate func setupUI() {
        setupBlurView()
    }
    
    fileprivate func setupBlurView() {
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
    }
}


// MARK:- 事件监听
extension YLRoomViewController {
    @IBAction func exitBtnClick() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bottomMenuClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("点击了聊天")
        case 1:
            print("点击了分享")
        case 2:
            print("点击了礼物")
            let titles = ["推荐", "游戏", "热门", "趣玩"]
            let style = YLPageStyle()
            let pageFrame = CGRect(x: 0, y: kScreenH - 300, width: view.bounds.width, height: 300)
            let pageView = YLPageView(frame: pageFrame, style: style, titles: titles)
            pageView.backgroundColor = UIColor.cyan
            view.addSubview(pageView)
        case 3:
            print("点击了更多")
        case 4:
            print("点击了星星")
        default:
            fatalError("未处理按钮")
        }
    }
}
