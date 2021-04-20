//
//  TabCell.swift
//  one-article
//
//  Created by Ted on 2021/03/21.
//

import UIKit
import SnapKit

class TabCell: UICollectionViewCell {

    // MARK: - Properties

    private var tabSV: UIStackView!
    var tabTitle: UILabel!
    var tabIcon: UIImageView!
    var indicatorView: UIView!
    var indicatorColor: UIColor!

    override var isSelected: Bool {
        didSet {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.1) {
                    self.indicatorView.backgroundColor = self.isSelected ? self.indicatorColor : UIColor.clear
                    self.layoutIfNeeded()
                }
            }
        }
    }

    var tabViewModel: Tab? {
        didSet {
            tabTitle.text = tabViewModel?.title
            tabIcon.image = tabViewModel?.icon
            (tabViewModel?.icon != nil) ? (tabSV.spacing = 3) : (tabSV.spacing = 0)
        }
    }

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        tabSV = UIStackView()
        tabSV.axis = .horizontal
        tabSV.distribution = .equalCentering
        tabSV.alignment = .center
        tabSV.spacing = 10.0
        addSubview(tabSV)

        tabIcon = UIImageView()
        tabIcon.clipsToBounds = true
        self.tabSV.addArrangedSubview(tabIcon)

//        tabIcon.snp.makeConstraints { (make) -> Void in
//            make.size.equalTo(CGSize(width: 15, height: 15))
//        }

        tabTitle = UILabel()
        tabTitle.textAlignment = .center
        self.tabSV.addArrangedSubview(tabTitle)

        tabSV.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }

        setupIndicatorView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        tabTitle.text = ""
        tabIcon.image = nil
    }

    // MARK: - Helpers

    func setupIndicatorView() {
        indicatorView = UIView()
        inputView?.backgroundColor = Constants.customUIColor.oceanBlue
        addSubview(indicatorView)

        indicatorView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(2)
            make.bottom.width.equalToSuperview()
        }
    }
}
