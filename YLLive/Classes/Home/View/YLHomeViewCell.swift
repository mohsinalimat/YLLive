//
//  YLHomeViewCell.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/25.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

class YLHomeViewCell: UICollectionViewCell {
    
    fileprivate lazy var albumImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    fileprivate lazy var liveImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "home_icon_live"))
        return imageView
    }()
    fileprivate lazy var nickNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = .white
        return label
    }()
    fileprivate lazy var onlinePeopleLabel: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.randomColor
        setUpUI()
        layoutSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var anchorModel: YLAnchorViewModel? {
        didSet {
            let url = URL(string: (anchorModel!.isEvenIndex ? anchorModel?.pic74 : anchorModel?.pic51)!)
            albumImageView.kf.setImage(with: url)
            liveImageView.isHidden = anchorModel?.live == 0
            nickNameLabel.text = anchorModel?.name
            onlinePeopleLabel.setTitle("\(anchorModel?.focus ?? 0)", for: .normal)
        }
    }
}

extension YLHomeViewCell {
    fileprivate func setUpUI() {
        addSubview(albumImageView)
        addSubview(liveImageView)
        addSubview(nickNameLabel)
        addSubview(onlinePeopleLabel)
    }
}

extension YLHomeViewCell {
    fileprivate func layoutSubview() {
        albumImageView.snp.makeConstraints({ (make) in
            make.margins.equalToSuperview()
        })
        
        liveImageView.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 23, height: 13))
        })
        
        nickNameLabel.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.size.equalTo(CGSize(width: 100, height: 15))
        })
        
        onlinePeopleLabel.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalTo(-8)
            make.size.equalTo(CGSize(width: 42, height: 15))
        })
    }
}
