//
//  TabCell.swift
//  one-article
//
//  Created by Ted on 2021/03/21.
//

import UIKit
import SnapKit

class TabCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private var tabSV: UIStackView!
    var tabTitle: UILabel!
    var tabIcon: UIImageView!
    var indicatorView: UIView!
    var indicatorColor: UIColor = .black
    
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
            (tabViewModel?.icon != nil) ? (tabSV.spacing = 10) : (tabSV.spacing = 0)
        }
    }
    
    //MARK: Init
    
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
        
        tabTitle = UILabel()
        tabTitle.textAlignment = .center
        self.tabSV.addArrangedSubview(tabTitle)
        
        tabSV.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
        
//        tabSV.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            tabSV.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            tabSV.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//        ])
        
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
    
    //MARK: - Helpers
    
    func setupIndicatorView() {
        indicatorView = UIView()
        inputView?.backgroundColor = UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1)
        addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(2)
            make.bottom.width.equalToSuperview()
        }
        
//        indicatorView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            indicatorView.heightAnchor.constraint(equalToConstant: 3),
//            indicatorView.widthAnchor.constraint(equalTo: self.widthAnchor),
//            indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
//        ])
    }
}
