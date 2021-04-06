//
//  InitialCoreData.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/06.
//

import UIKit
import CoreData

class InitialCoreData {
    
    static var shared: InitialCoreData = InitialCoreData()
    
    func saveInitialData(persistenceManager: PersistenceManager) {
        let language1 = Setting(isChecked: true, title: "English", code: "us", icon: "united-states-of-america")
        let language2 = Setting(isChecked: true, title: "French", code: "fr", icon: "france")
        let language3 = Setting(isChecked: true, title: "Japanese", code: "jp", icon: "japan")
        let language4 = Setting(isChecked: true, title: "Korean", code: "kr", icon: "south-korea")
        let language5 = Setting(isChecked: false, title: "Chinese", code: "cn", icon: "china")
        let language6 = Setting(isChecked: false, title: "Russian", code: "ru", icon: "russia")
        let language7 = Setting(isChecked: false, title: "German", code: "de", icon: "germany")
        let language8 = Setting(isChecked: false, title: "Italian", code: "it", icon: "italy")
        let language9 = Setting(isChecked: false, title: "Portuguese", code: "pt", icon: "portugal")
        let language10 = Setting(isChecked: false, title: "Dutch", code: "nl", icon: "netherlands")
        let language11 = Setting(isChecked: false, title: "Swedish", code: "se", icon: "sweden")
        let language12 = Setting(isChecked: false, title: "Norwegian", code: "no", icon: "norway")

        persistenceManager.insertLanguage(language: language1)
        persistenceManager.insertLanguage(language: language2)
        persistenceManager.insertLanguage(language: language3)
        persistenceManager.insertLanguage(language: language4)
        persistenceManager.insertLanguage(language: language5)
        persistenceManager.insertLanguage(language: language6)
        persistenceManager.insertLanguage(language: language7)
        persistenceManager.insertLanguage(language: language8)
        persistenceManager.insertLanguage(language: language9)
        persistenceManager.insertLanguage(language: language10)
        persistenceManager.insertLanguage(language: language11)
        persistenceManager.insertLanguage(language: language12)
    }
}
