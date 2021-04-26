//
//  Language.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/22.
//

import Foundation

struct Language: Equatable {
    var isChecked: Bool
    var title: String
    var code: String
    var icon: String
}

extension Language {
    init(with realmLanguage: RealmLanguage) {
        self.isChecked = realmLanguage.isChecked
        self.title = realmLanguage.title
        self.code = realmLanguage.code
        self.icon = realmLanguage.icon
    }
}
