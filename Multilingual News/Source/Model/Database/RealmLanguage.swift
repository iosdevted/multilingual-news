//
//  RealmLanguage.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/22.
//

import Foundation
import RealmSwift

class RealmLanguage: Object {
    @objc dynamic var isChecked: Bool = false
    @objc dynamic var title: String = ""
    @objc dynamic var code: String = ""
    @objc dynamic var icon: String = ""
    
    func update(withLanguageModel language: Language) {
        self.isChecked = language.isChecked
        self.title = language.title
        self.code = language.code
        self.icon = language.icon
    }
}
