//
//  TopHeaderContainerView.swift
//  one-article
//
//  Created by Ted on 2021/03/21.
//

import UIKit
import SnapKit
//import SkeletonView

class TopHeaderContainerView: UIView {
    
    //MARK: Properties
    
    var topHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.8
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor

        imageView.layer.shadowColor = UIColor.white.withAlphaComponent(0.7).cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowRadius = 10.0
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
//        label.isSkeletonable = true
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1)
        label.numberOfLines = 0
        return label
    }()
    
//    var authorLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
//        label.textColor = .systemGray
//        label.numberOfLines = 1
//        return label
//    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
//        label.isSkeletonable = true
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .systemGray
        label.numberOfLines = 1
        return label
    }()
    
    //MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
//        showAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    
//    private func showAnimation() {
//        titleLabel.showAnimatedGradientSkeleton()
//        dateLabel.showAnimatedGradientSkeleton()
//    }
    
    private func configureUI() {
        addSubview(topHeaderImageView)
        
        topHeaderImageView.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview().multipliedBy(0.6)
            
            make.top.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            
            make.top.equalTo(topHeaderImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { (make) -> Void in
            
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
            make.bottom.equalToSuperview().offset(-15)
        }
        
//        let detailedStack = UIStackView(arrangedSubviews: [authorLabel, dateLabel])
//        detailedStack.alignment = .fill
//        detailedStack.distribution = .equalSpacing
//
//        addSubview(detailedStack)
//
//        detailedStack.snp.makeConstraints { (make) -> Void in
//
//            make.top.equalTo(titleLabel.snp.bottom).offset(5)
//            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
//            make.bottom.equalToSuperview().offset(-15)
//        }
    }
}
