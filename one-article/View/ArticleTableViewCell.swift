//
//  ArticleTableViewCell.swift
//  one-article
//
//  Created by Ted on 2021/03/21.
//

import UIKit
import SnapKit
//import SkeletonView

class ArticleTableViewCell: UITableViewCell {
    
    var articleImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray4
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.8
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor

        imageView.layer.shadowColor = UIColor.white.withAlphaComponent(0.7).cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowRadius = 10.0
        
        return imageView
    }()
    
    
    var titleLabel: UILabel = {
        let label = UILabel()
//        label.isSkeletonable = true
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1)
        label.numberOfLines = 0
        return label
    }()
    
    private var dateImageView: UIImageView = {
        let image = UIImage(systemName: "calendar")
        image?.withRenderingMode(.alwaysOriginal)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .systemGray4
        
        return imageView
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
//        label.isSkeletonable = true
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .systemGray4
        label.numberOfLines = 1
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
//        showAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        selectionStyle = .none
        addSubview(articleImageView)
        
        articleImageView.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview().multipliedBy(0.75)
            make.width.equalToSuperview().multipliedBy(0.3)
            
            make.top.leading.bottom.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 0))
        }
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview().multipliedBy(0.4)
            
            make.top.equalToSuperview().offset(15)
            make.leading.equalTo(articleImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        addSubview(dateImageView)
        
        dateImageView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(articleImageView.snp.bottom).offset(-3)
            make.leading.equalTo(articleImageView.snp.trailing).offset(15)
        }
        
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(articleImageView.snp.bottom).offset(-5)
            make.leading.equalTo(dateImageView.snp.trailing).offset(5)
        }
    }
    
//    private func showAnimation() {
//        titleLabel.showAnimatedGradientSkeleton()
//        dateLabel.showAnimatedGradientSkeleton()
//    }
}
