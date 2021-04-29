//
//  String-Extensions.swift
//  Multilingual News
//
//  Created by Ted on 2021/03/22.
//

import Foundation

extension String {
    
    // MARK: - Time
    
    func toLocalTime() -> String? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        df.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let date = df.date(from: self) else { return nil }
        df.timeZone = TimeZone.current
        df.dateFormat = "h:mm a"
        
        return df.string(from: date)
    }
    
    func toLocalTimeWithDate() -> String? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        df.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let date = df.date(from: self) else { return nil }
        df.timeZone = TimeZone.current
        df.dateFormat = "MMM d, h:mm a"
        
        return df.string(from: date)
    }
    
    // MARK: - localized
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localizedStringWithFormat(_ argument: CVarArg) -> String {
        return .localizedStringWithFormat(self.localized, argument)
    }
}
