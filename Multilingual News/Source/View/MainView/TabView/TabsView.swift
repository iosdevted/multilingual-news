//
//  TabsView.swift
//  Multilingual News
//
//  Created by Ted on 2021/03/21.
//

import UIKit
import SnapKit

protocol TabsDelegate: class {
    func tabsViewDidSelectItemAt(position: Int)
}

class TabsView: UIView {

    // MARK: - Properties

    weak var delegate: TabsDelegate?
    var tabMode: TabMode = .fixed
    var tabs: [Tab] = []
    var collectionView: UICollectionView!
    var titleColor: UIColor = UIColor.oceanBlue
    var titleFont: UIFont = UIFont.mainRegularFont(ofSize: 15)
    var indicatorColor: UIColor = UIColor.oceanBlue

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createView()
    }

    // MARK: - Helpers

    private func createView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: TabCell.self)
        addSubview(collectionView)

        collectionView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension TabsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TabCell.self)
        cell.tabViewModel = Tab(icon: tabs[indexPath.item].icon, title: tabs[indexPath.item].title)
        cell.tabIcon.image = cell.tabIcon.image?.withRenderingMode(.alwaysOriginal)
        cell.tabTitle.font = titleFont
        cell.tabTitle.textColor = titleColor
        cell.indicatorColor = indicatorColor

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tabsViewDidSelectItemAt(position: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TabsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch tabMode {
        case .scrollable:
            let tabSize = CGSize(width: 500, height: self.frame.height)
            let tabTitle = tabs[indexPath.item].title ?? ""

            var addSpace: CGFloat = 20
            if tabs[indexPath.item].icon != nil {
                addSpace += 40
            }

            let titleWidth = NSString(string: tabTitle).boundingRect(with: tabSize, options: .usesLineFragmentOrigin, attributes: [.font: titleFont], context: nil).size.width
            let tabWidth = titleWidth + addSpace

            return CGSize(width: tabWidth, height: self.frame.height)
        case .fixed:
            return CGSize(width: self.frame.width / CGFloat(tabs.count), height: self.frame.height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
