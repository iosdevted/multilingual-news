//
//  ArticleTableViewCell.swift
//  one-article
//
//  Created by Ted on 2021/03/21.
//

import UIKit
import SnapKit

class ArticleTableViewCell: UITableViewCell {

    var articleImageView: UIImageView = {
        let image = UIImage(named: "NoImage")?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
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
        // label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = Constants.customUIColor.oceanBlue
        label.lineBreakMode = .byWordWrapping
        label.contentMode = .topLeft
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
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .systemGray4
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

    // MARK: - Helpers

    private func configureUI() {
        selectionStyle = .none
        
        [
            articleImageView,
            titleLabel,
            dateImageView,
            dateLabel
        ].forEach {
            addSubview($0)
        }

        articleImageView.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview().multipliedBy(0.75)
            make.width.equalToSuperview().multipliedBy(0.3)

            make.top.leading.bottom.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 0))
        }

        titleLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview().multipliedBy(0.5)

            make.top.equalToSuperview().offset(15)
            make.leading.equalTo(articleImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }

        dateImageView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(articleImageView.snp.trailing).offset(15)
            make.bottom.equalTo(articleImageView.snp.bottom).offset(-3)
        }

        dateLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(dateImageView.snp.trailing).offset(5)
            make.bottom.equalTo(articleImageView.snp.bottom).offset(-5)
        }
    }
}
