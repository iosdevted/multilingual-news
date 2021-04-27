//
//  InitialLanguages.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/23.
//

import Foundation

struct Setting {
    
    static let languages = [Language(isChecked: true, title: "English", code: "us", icon: "united-states-of-america"),
                            Language(isChecked: true, title: "French", code: "fr", icon: "france"),
                            Language(isChecked: true, title: "Japanese", code: "jp", icon: "japan"),
                            Language(isChecked: true, title: "Korean", code: "kr", icon: "south-korea"),
                            Language(isChecked: false, title: "Chinese", code: "cn", icon: "china"),
                            Language(isChecked: false, title: "Russian", code: "ru", icon: "russia"),
                            Language(isChecked: false, title: "German", code: "de", icon: "germany"),
                            Language(isChecked: false, title: "Italian", code: "it", icon: "italy"),
                            Language(isChecked: false, title: "Portuguese", code: "pt", icon: "portugal"),
                            Language(isChecked: false, title: "Dutch", code: "nl", icon: "netherlands"),
                            Language(isChecked: false, title: "Swedish", code: "se", icon: "sweden"),
                            Language(isChecked: false, title: "Norwegian", code: "no", icon: "norway")]
}
