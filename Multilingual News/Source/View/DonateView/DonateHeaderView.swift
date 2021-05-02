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
        label.font = .mainRegularFont(ofSize: 17)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.text = SystemConstants.Donation.presentation
        return label
    }()
    
    private var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .mainRegularFont(ofSize: 17)
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = SystemConstants.Donation.status
        return label
    }()
    
    lazy var emailIconButton: UIButton = {
        let image = UIImage(named: "ui-email")?.withRenderingMode(.alwaysOriginal)
        return iconButtonGenerator(with: image)
    }()
    
    lazy var githubIconButton: UIButton = {
        let image = UIImage(named: "GitHub-Mark_Black")?.withRenderingMode(.alwaysOriginal)
        return iconButtonGenerator(with: image)
    }()
    
    lazy var linkedinIconButton: UIButton = {
        let image = UIImage(named: "LinkedIn-Logos_Black")?.withRenderingMode(.alwaysOriginal)
        return iconButtonGenerator(with: image)
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
    
    private func iconButtonGenerator(with image: UIImage?) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)

        button.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        return button
    }
    
    // MARK: ConfigureUI
    
    private func configureUIStyle() {
        backgroundColor = .white
    }
    
    private func configureUI() {
        let iconImageViewStack = UIStackView(arrangedSubviews: [emailIconButton, githubIconButton, linkedinIconButton])
        iconImageViewStack.axis = .horizontal
        iconImageViewStack.distribution = .fillEqually
        iconImageViewStack.spacing = 12
        
        [
            presentationLabel,
            statusLabel,
            iconImageViewStack
        ].forEach {
            addSubview($0)
        }
        
        presentationLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        statusLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(presentationLabel.snp.bottom).offset(20)
        }
        
        iconImageViewStack.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(statusLabel.snp.bottom).offset(16)
        }
    }
    
}
