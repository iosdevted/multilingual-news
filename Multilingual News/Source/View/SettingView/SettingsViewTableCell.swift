//
//  SettingsViewTableCell.swift
//  one-article
//
//  Created by Ted on 2021/03/22.
//

import UIKit
import SnapKit
import M13Checkbox

class SettingsViewTableCell: UITableViewCell {
    
    // MARK: - Properties
    
    var checkBox: M13Checkbox = {
        let cb = M13Checkbox()
        cb.cornerRadius = 1
        cb.boxType = .square
        cb.checkmarkLineWidth = 4
        cb.stateChangeAnimation = .bounce(.fill)
        cb.tintColor = Constants.customUIColor.oceanBlue
        cb.stateChangeAnimation = .stroke
        cb.animationDuration = 0.2
        return cb
    }()
    
    var languageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = Constants.customUIColor.oceanBlue
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        selectionStyle = .none
        
        [
            checkBox,
            languageImageView,
            titleLabel
        ].forEach {
            addSubview($0)
        }
        
        checkBox.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.leading.equalToSuperview().offset(23)
            make.centerY.equalToSuperview()
        }
        
        languageImageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.leading.equalTo(checkBox.snp.trailing).offset(15)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(languageImageView.snp.trailing).offset(15)
            make.centerY.equalToSuperview()
        }
        
    }
    
}
