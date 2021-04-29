//
//  DonateTableView.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/29.
//

import SnapKit
import UIKit

class DonateTableView: UITableViewCell {
    
    // MARK: Properties
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        imageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .mainBoldFont(ofSize: 15)
        label.textColor = UIColor.black
        label.numberOfLines = 1
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .mainRegularFont(ofSize: 13)
        label.textColor = UIColor.black
        label.numberOfLines = 1
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

    private func configureUI() {
        [
            iconImageView,
            titleLabel,
            priceLabel
        ].forEach {
            addSubview($0)
        }

        iconImageView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview().offset(-10)
            make.leading.equalTo(iconImageView.snp.trailing).offset(30)
        }

        priceLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview().offset(10)
            make.leading.equalTo(iconImageView.snp.trailing).offset(30)
        }
    }
}
