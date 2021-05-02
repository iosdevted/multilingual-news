//
//  UILabel-Extensions.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/29.
//

import UIKit

extension UILabel {
    
    static func mainTitleFont(with text: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.tintColor = .warmBlack
        titleLabel.font = UIFont.mainBoldFont(ofSize: 20)
        titleLabel.sizeToFit()
        
        return titleLabel
    }
    
}
