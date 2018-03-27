//
//  YLAnchorViewController.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/25.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit

private let kEdgeMargin: CGFloat = 8
private let cellID = "identifier"

class YLAnchorViewController: UIViewController {
    
    var homeType: YLHomeType!

    fileprivate var itemCount: Int = 20
    fileprivate lazy var homeVM: YLHomeViewModel = YLHomeViewModel()
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = YLWatefallLayout()
        layout.sectionInset = UIEdgeInsets(top: kEdgeMargin, left: kEdgeMargin, bottom: kEdgeMargin, right: kEdgeMargin)
        layout.minimumLineSpacing = kEdgeMargin
        layout.minimumInteritemSpacing = kEdgeMargin
        layout.dataSource = self
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(YLHomeViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        loadData(index: 0)
    }

}

// MARK: 加载数据
extension YLAnchorViewController {
    fileprivate func loadData(index: Int) {
        homeVM.loadHomeData(type: homeType, index: index, finishedCallBack:  {
            self.collectionView.reloadData()
        })
    }
}

extension YLAnchorViewController: UICollectionViewDataSource, UICollectionViewDelegate, YLWaterfallLayoutDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeVM.anchorModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! YLHomeViewCell
        cell.anchorModel = homeVM.anchorModels[indexPath.item]
        
        if indexPath.item == homeVM.anchorModels.count - 1 {
            loadData(index: homeVM.anchorModels.count)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let liveVc = YLRoomViewController()
        navigationController?.pushViewController(liveVc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.height {
            itemCount += 30
            collectionView.reloadData()
        }
    }
    
    func waterfallLayout(_ layout: YLWatefallLayout, indexPath: IndexPath) -> CGFloat {
        return indexPath.item % 2 == 0 ? kScreenW * 2 / 3 : kScreenW * 0.5
    }
}

