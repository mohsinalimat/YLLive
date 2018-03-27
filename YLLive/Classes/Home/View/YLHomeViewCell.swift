//
//  YLHomeViewCell.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/25.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit
import Kingfisher

class YLHomeViewCell: UICollectionViewCell {
    
    fileprivate var albumImageView: UIImageView?
    fileprivate var liveImageView: UIImageView?
    fileprivate var nickNameLabel: UILabel?
    fileprivate var onlinePeopleLabel: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var anchorModel: YLAnchorViewModel? {
        didSet {
            let url = URL(string: (anchorModel!.isEvenIndex ? anchorModel?.pic74 : anchorModel?.pic51)!)
            albumImageView?.kf.setImage(with: url)
            liveImageView?.isHidden = anchorModel?.live == 0
            nickNameLabel?.text = anchorModel?.name
            onlinePeopleLabel?.setTitle("\(anchorModel?.focus ?? 0)", for: .normal)
        }
    }
}

extension YLHomeViewCell {
    fileprivate func setUpUI() {
        albumImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        liveImageView = UIImageView(frame: CGRect(x: self.bounds.width - 31, y: 8, width: 23, height: 13))
        nickNameLabel = UILabel(frame: CGRect(x: 8, y: self.bounds.height - 23, width: 100, height: 15))
        onlinePeopleLabel = UIButton(frame: CGRect(x: self.bounds.width - 50, y: self.bounds.height - 23, width: 42, height: 15))
        
        addSubview(albumImageView!)
        addSubview(liveImageView!)
        addSubview(nickNameLabel!)
        addSubview(onlinePeopleLabel!)
    }
}
