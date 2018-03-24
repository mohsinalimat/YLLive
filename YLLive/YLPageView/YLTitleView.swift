 //
//  YLTitleView.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/17.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit


protocol YLTitleViewDelegate: class{
    func titleView(_ pageView: YLTitleView, currentIndex: Int)
}

class YLTitleView: UIView {

    // MARK: 定义属性
    weak var delegate: YLTitleViewDelegate?
    
    fileprivate var style: YLPageStyle
    fileprivate var titles: [String]
    fileprivate var currentIndex: Int = 0
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    typealias ColorRGB = (red: CGFloat, green: CGFloat, blue: CGFloat)
    fileprivate lazy var normalRGB: ColorRGB = style.normalColor.getRGB()
    fileprivate lazy var selectedRGB: ColorRGB = style.selectedColor.getRGB()
    fileprivate lazy var deltaRGB: ColorRGB = {
        let deltaR = self.selectedRGB.red - self.normalRGB.red
        let deltaG = self.selectedRGB.green - self.normalRGB.green
        let deltaB = self.selectedRGB.blue - self.normalRGB.blue
        return (deltaR, deltaG, deltaB)
    }()
    fileprivate lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    // MARK: 构造函数
    init(frame: CGRect, style: YLPageStyle, titles: [String]) {
        self.style = style
        self.titles = titles
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension YLTitleView {
    
    // MARK: 设置UI
    fileprivate func setUpUI() {
        // 添加一个UIScrollView
        addSubview(scrollView)
        
        // 展示title
        setUpTitleLabels()
        
        // 设置label的frame
        setUpLabelsFrame()
    }
    
    private func setUpLabelsFrame() {
        
        let labelH = style.titleHeight
        var labelW: CGFloat = 0
        let labelY: CGFloat = 0
        var labelX: CGFloat = 0
        
        let count = titleLabels.count
        for (i, titleLabel) in titleLabels.enumerated() {

            if style.isScrollEnabel {
                labelW = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : titleLabel.font], context: nil).width
                labelX = i == 0 ? style.titleMargin * 0.5 : (titleLabels[i-1].frame.maxX + style.titleMargin)
            }else{
                labelW = bounds.width / CGFloat(count)
                labelX = labelW * CGFloat(i)
            }
            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        }
        
        // 设置contentSize
        if style.isScrollEnabel {
            scrollView.contentSize.width = titleLabels.last!.frame.maxX + style.titleMargin * 0.5
        }
    }
    
    private func setUpTitleLabels() {
        for (i ,title) in titles.enumerated() {
            // 创建Label
            let label = UILabel()
            
            // 设置label属性
            label.tag = i;
            label.text = title;
            label.textColor = i == 0 ? style.selectedColor : style.normalColor
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: style.fontSize)
            
            // 将label添加到scrollView上
            scrollView.addSubview(label)
            
            // 将label添加到数组中
            titleLabels.append(label)
            
            // 监听label的点击
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
            label.isUserInteractionEnabled = true
        }
    }
}

// MARK: 点击事件
extension YLTitleView {
    // @objc 如果在函数前面加载@objc，那么会保留OC的特性
    // OC在调用方法时，本质是发送消息
    // 将方法包装成@SEL --> 根据 @SEL去类中的方法映射表 --> IMP指针
    @objc fileprivate func titleLabelClick(_ tapGes: UITapGestureRecognizer) {
        // 校验Label
        guard let targetLabel = tapGes.view as? UILabel else {
            return
        }
        
        guard targetLabel.tag != currentIndex else {
            return
        }
        // 取出原来的label
        let sourceLabel = titleLabels[currentIndex]
        
        // 改变label的颜色
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectedColor
        
        // 记录最新的index
        currentIndex = targetLabel.tag
        
        // 让点击的label居中显示
        adjustLabelPosition(targetLabel)
        
        // 通知代理
        delegate?.titleView(self, currentIndex: currentIndex)
    }
    
    fileprivate func adjustLabelPosition(_ targetLabel: UILabel) {
        // 计算offsetX
        var offsetX =  targetLabel.center.x - bounds.width * 0.5
        
        // 临界值判断
        if offsetX < 0 {
            offsetX = 0
        }
        
        if offsetX > scrollView.contentSize.width - scrollView.bounds.width {
            offsetX = scrollView.contentSize.width - scrollView.bounds.width
        }
        
        // 设置scrollView的contentOffset
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

extension YLTitleView: YLContentViewDelegate {
    func contentView(_ contentView: YLContentView, inIndex: Int) {
        // 记录最新的currentIndex
        currentIndex = inIndex
        
        // 让targetLabel居中显示
        adjustLabelPosition(titleLabels[currentIndex])
    }
    
    func contentView(_ contentView: YLContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        // 获取soureLabel&targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 颜色渐变
        sourceLabel.textColor = UIColor(r: selectedRGB.red - progress * deltaRGB.red, g: selectedRGB.green - progress * deltaRGB.green, b: selectedRGB.blue - progress * deltaRGB.blue)
        targetLabel.textColor = UIColor(r: normalRGB.red + progress * deltaRGB.red, g: normalRGB.green + progress * deltaRGB.green, b: normalRGB.blue + progress * deltaRGB.blue)
    }
}




