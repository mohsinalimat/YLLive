//
//  HomeViewController.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/24.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit

private let cellID = "identifier"

class HomeViewController: UIViewController {
    
    fileprivate var itemCount: Int = 20
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = YLWatefallLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.dataSource = self
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = UIColor.randomColor
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.height {
            itemCount += 30
            collectionView.reloadData()
        }
    }
}

extension HomeViewController: YLWaterfallLayoutDataSource {
    func waterfallLayout(_ layout: YLWatefallLayout, indexPath: IndexPath) -> CGFloat {
        return CGFloat(arc4random_uniform(160)+80)
//        return indexPath.item % 2 == 0 ? 250 : 180
    }
    
    func waterfallLayout(_ layout: YLWatefallLayout) -> Int {
        return 2
    }
}
