//
//  YLPageViewLayout.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/4/11.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit

class YLPageViewLayout: UICollectionViewLayout {
    fileprivate lazy var cellAttrs: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    var sectionInset: UIEdgeInsets = UIEdgeInsets.zero
    var itemSpacing: CGFloat = 0
    var lineSapcing: CGFloat = 0
    var cols = 4
    var rows = 2
    fileprivate lazy var pageCount = 0
}


// MARK: 准备布局
extension YLPageViewLayout {
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        // 获取多少组
        let sectionCount = collectionView.numberOfSections
        
        let itemW: CGFloat = (collectionView.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * itemSpacing) / CGFloat(cols)
        let itemH: CGFloat = (collectionView.bounds.height - sectionInset.top - sectionInset.bottom - CGFloat(rows - 1) * lineSapcing) / CGFloat(rows)
        
        // 获取每组中有多少个数据
        for sectionIndex in 0..<sectionCount {
            let itemCount = collectionView.numberOfItems(inSection: sectionIndex)
            
            // 为每个cell创建对应的UICollectionviewLayoutAttributes
            for itemIndex in 0..<itemCount {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                // 求出itemIndex在该组中的第几页中的第几个
                let pageIndex = itemIndex / (rows * cols)
                let pageItemIndex = itemIndex % (rows * cols)
                
                // 求出itemIndex在该页中第几行/第几列
                let rowIndex = pageItemIndex / cols
                let colIndex = pageItemIndex % cols
                
                // 设置attributes的frame
                let itemX: CGFloat = CGFloat(pageCount + pageIndex) * collectionView.bounds.width + sectionInset.left + (itemW + itemSpacing) * CGFloat(colIndex)
                let itemY: CGFloat = sectionInset.top + (itemH + lineSapcing) * CGFloat(rowIndex)
                attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                
                cellAttrs.append(attr)
            }
            
            // 计算改组一共占据多少页
            pageCount += (itemCount - 1) / (cols * rows) + 1
        }
    }
}

// MARK: 返回布局
extension YLPageViewLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
}

// MARK: 设置可滚动区域
extension YLPageViewLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: CGFloat(pageCount) * collectionView!.bounds.width, height: 0)
    }
}
