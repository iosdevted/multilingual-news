//
//  RealmLanguage +Extension.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/27.
//

import Foundation

extension Array where Element: RealmLanguage {
    
    func changeToLanguageType() -> [Language] {
        var languages: [Language] = [Language]()
        
        self.forEach {
            languages.append(Language(with: $0 as RealmLanguage))
        }
        
        return languages
    }
}
