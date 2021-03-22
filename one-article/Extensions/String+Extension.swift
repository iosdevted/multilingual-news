//
//  String+Extension.swift
//  one-article
//
//  Created by Ted on 2021/03/22.
//

import UIKit

extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func toDateFormat() -> String {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        guard let date2 = formatter1.date(from: self) else { return "" }

        let formatter2 = DateFormatter()
        formatter2.timeStyle = .short
        formatter2.locale = Locale(identifier: "en_US")

        let dateString = formatter2.string(from: date2)
        return dateString

    }
    
}
