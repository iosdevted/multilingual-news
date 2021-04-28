//
//  HeaderView.swift
//  one-article
//
//  Created by Ted on 2021/03/21.
//

import UIKit
import SnapKit

class HeaderView: UIView {
    
    // MARK: Properties
    
    var imageContainerView: UIView = {
        let view = UIView()
        view.makeEdges(cornerRadius: 30, borderWidth: 1)
        view.makeShadow(opacity: 0.5, radius: 5)
        return view
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.7
        imageView.layer.masksToBounds = true
        imageView.makeEdges(cornerRadius: 30, borderWidth: 1)
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = Constants.customUIColor.oceanBlue
        label.numberOfLines = 0
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .systemGray4
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureUIStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    
    private func configureUIStyle() {
        backgroundColor = .white
        makeEdges(cornerRadius: 30, borderWidth: 0.1, UIColor.systemGray4.withAlphaComponent(0.7).cgColor)
        makeShadow(opacity: 0.5, radius: 5)
    }
    
    private func configureUI() {
        
        [
            imageContainerView,
            imageView,
            titleLabel,
            dateLabel
        ].forEach {
            addSubview($0)
        }
        
        imageContainerView.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview().multipliedBy(0.6)
            
            make.top.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        imageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(imageContainerView)
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview().multipliedBy(0.2)
            
            make.top.equalTo(imageContainerView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        }
        
        dateLabel.snp.makeConstraints { (make) -> Void in
            
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}
