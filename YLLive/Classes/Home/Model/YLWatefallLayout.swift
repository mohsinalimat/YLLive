//
//  YLWatefallLayout.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/24.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit

@objc protocol YLWaterfallLayoutDataSource: class {
    /// item 高度
    func waterfallLayout(_ layout: YLWatefallLayout, indexPath: IndexPath) -> CGFloat
    /// 多少列
    @objc optional func waterfallLayout(_ layout: YLWatefallLayout) -> Int
}

class YLWatefallLayout: UICollectionViewFlowLayout {
    
    var dataSource: YLWaterfallLayoutDataSource?
    
    fileprivate lazy var cols: Int = {
        return self.dataSource?.waterfallLayout?(self) ?? 2
    }()
    fileprivate lazy var colHeights: [CGFloat] = Array(repeating: self.sectionInset.top, count: cols)
    fileprivate lazy var cellAttrs: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
}

// MARK: 准备好所有布局
extension YLWatefallLayout {
    override func prepare() {// 准备布局
        super.prepare()
        
        // 校验collectionView是否有值
        guard let collectionView = collectionView else {
            return
        }
        
        // 获取cell的个数
        let count = collectionView.numberOfItems(inSection: 0)
        let itemW = (collectionView.bounds.width - sectionInset.left - sectionInset.right - (CGFloat(cols) - 1) * minimumInteritemSpacing) / CGFloat(cols)
        
        // 遍历出所有的cell，并且计算frame
        for i in cellAttrs.count..<count {
            // 创建UICollectionViewLayoutAttributes
            let indexPath = IndexPath(item: i, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
//            let itemH = CGFloat(arc4random_uniform(150) + 80)
            // 如果前面的可选链都有值，那么取前面的值，如果有一个没有值，那么使用？？后面的值
//            fatalError("请给YLWaterfallLayout设置数据源")
            let itemH = dataSource?.waterfallLayout(self, indexPath: indexPath) ?? 0
            
            // 计算最小高度
            let minH = colHeights.min()!
            let minIndexAtCol = colHeights.index(of: minH)!
            let itemX = sectionInset.left + CGFloat(minIndexAtCol) * (itemW + minimumInteritemSpacing)
            let itemY = minH
            
            // 设置attr中的frame
            attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
            
            // 给minIndexAtCol赋新值
            colHeights[minIndexAtCol] = attr.frame.maxY + minimumLineSpacing
            
            cellAttrs.append(attr)
        }
    }
}

// MARK: 返回准备好的布局
extension YLWatefallLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
}

// MARK: 设置可滚动区域
extension YLWatefallLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: colHeights.max()! + sectionInset.bottom)
    }
}
