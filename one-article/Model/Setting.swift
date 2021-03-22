//
//  Setting.swift
//  one-article
//
//  Created by Ted on 2021/03/22.
//

import UIKit

struct Setting {
    var icon: UIImage?
    var title: String
}

enum SettingOptions: Int, CaseIterable, CustomStringConvertible {
    
    case English
    case French
    case Korean
    case Japanese
    
    var description: String {
        switch self {
        case .English: return "English"
        case .French: return "French"
        case .Korean: return "Korean"
        case .Japanese: return "Japanese"
        }
    }
    
    var image: UIImage {
        switch self {
        case .English: return UIImage(named: "united-states-of-america") ?? UIImage()
        case .French: return UIImage(named: "france") ?? UIImage()
        case .Korean: return UIImage(named: "south-korea") ?? UIImage()
        case .Japanese: return UIImage(named: "japan") ?? UIImage()
        }
    }
}
