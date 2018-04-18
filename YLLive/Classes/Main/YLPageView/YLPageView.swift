//
//  YLPageView.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/17.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit

protocol YLPageViewDataSource: class {
    func numberOfSectionsInPageView(_ pageView: YLPageView) -> Int
    func pageView(_ pageView: YLPageView, numberOfItemsInSection section: Int) -> Int
    func pageView(_ pageView: YLPageView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
}

class YLPageView: UIView {

    weak var dataSource: YLPageViewDataSource?
    
    // MARK: 定义属性
    fileprivate var style: YLPageStyle
    fileprivate var layout: YLPageViewLayout!
    fileprivate var titles: [String]
    fileprivate var childVcs: [UIViewController]!
    fileprivate var parentVc: UIViewController!
    fileprivate var collectionView: UICollectionView!
    fileprivate var pageControl: UIPageControl!
    fileprivate lazy var titleView: YLTitleView = {
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        let titleView = YLTitleView(frame: titleFrame, style: style, titles: titles)
        titleView.backgroundColor = UIColor.white
        return titleView
    }()
    
    // MARK: 构造函数
    init(frame: CGRect, style: YLPageStyle, titles: [String], childVcs: [UIViewController], parentVc: UIViewController) {
        // 在super.init()之前，需要保证所有的属性有被初始化
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        
        setUpUI()
    }
    
    init(frame: CGRect, style: YLPageStyle, titles: [String], layout: YLPageViewLayout) {
        self.style = style
        self.titles = titles
        self.layout = layout
        super.init(frame: frame)
        
        setUpCollectionUI()
    }
    
    // 在swift中，如果子类有自定义构造函数，或者覆盖父类的构造函数，那么必须实现父类中使用required修饰的构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension YLPageView {
    
    // MARK: 初始化控制器的UI
    fileprivate func setUpUI() {
        // 创建titleView
        addSubview(titleView)
        
        // 创建contentView
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = YLContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView)
        
        // 让titleView与contnetView交互
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
    
    // MARK: 初始化collectionView的UI
    fileprivate func setUpCollectionUI() {
        addSubview(titleView)
        
        let collectionFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight - style.pageControlHeight)
        
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        addSubview(collectionView)
        
        // 添加pageControl
        let pageControlFrame = CGRect(x: 0, y: collectionView.frame.maxY, width: bounds.width, height: style.pageControlHeight)
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.numberOfPages = 4
        addSubview(pageControl)
    }
}

extension YLPageView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSectionsInPageView(self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.pageView(self, numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageView(self, cellForItemAtIndexPath: indexPath)
    }
}

extension YLPageView {
    func registerCell(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func registerNib(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
}
