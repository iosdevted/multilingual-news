//
//  MainHeaderView.swift
//  Multilingual News
//
//  Created by Ted on 2021/03/21.
//

import UIKit
import SnapKit

class MainHeaderView: UIView {
    
    // MARK: Properties
    
    var tintView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.3, alpha: 0.4)
        return view
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.makeEdges(cornerRadius: 30, borderWidth: 1)
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
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
            imageView,
            titleLabel,
            dateLabel
        ].forEach {
            addSubview($0)
        }
        
        imageView.addSubview(tintView)
        
        imageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        
        tintView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(dateLabel.snp.top).offset(-15)
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 50))
        }
        
        dateLabel.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 50))
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}
