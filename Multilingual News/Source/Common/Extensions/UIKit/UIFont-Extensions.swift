//
//  UIFont-Extensions.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/28.
//

import UIKit

extension UIFont {
    
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    static func mainRegularFont(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "RedHatDisplay-Regular", size: size)
    }
    
    static func mainBoldFont(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "RedHatDisplay-Bold", size: size)
    }
}
