//
//  DonateHeaderView.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/29.
//

import SnapKit
import UIKit

class DonateHeaderView: UIView {
    
    // MARK: Properties
    
    private var presentationLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = .mainRegularFont(ofSize: 20)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.text = "This application relies on your support to fund its development. If you find it useful, please consider supporting the app by leaving a tip. Any tip given will feed below hungry developer."
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .mainBoldFont(ofSize: 17)
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = "Keep Developing 🧑‍💻"
        return label
    }()
    
    // Extension을 이용해서 코드량 줄이기
    lazy var githubIconImageView: UIImageView = {
        let image = UIImage(named: "GitHub-Mark_Black")?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFill
        
        imageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        return imageView
    }()
    
    lazy var linkedinIconImageView: UIImageView = {
        let image = UIImage(named: "LinkedIn-Logos_Black")?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFill
        
        imageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        return imageView
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
    }
    
    private func configureUI() {
        let iconImageViewStack = UIStackView(arrangedSubviews: [githubIconImageView, linkedinIconImageView])
        iconImageViewStack.axis = .horizontal
        iconImageViewStack.distribution = .fillEqually
        iconImageViewStack.spacing = 10
        
        [
            presentationLabel,
            descriptionLabel,
            iconImageViewStack
        ].forEach {
            addSubview($0)
        }
        
        presentationLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(presentationLabel.snp.bottom).offset(20)
        }
        
        iconImageViewStack.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
        }
        
//        iconImageViewStack.snp.makeConstraints { (make) -> Void in
//            make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-10)
//        }
        
//        descriptionLabel.snp.makeConstraints { (make) -> Void in
//            make.centerX.equalToSuperview()
//            make.bottom.equalTo(iconImageViewStack.snp.top).offset(-10)
//        }
    }
    
}
