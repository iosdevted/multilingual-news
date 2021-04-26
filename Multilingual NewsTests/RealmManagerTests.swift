//
//  RealmManagerTests.swift
//  Multilingual NewsTests
//
//  Created by Ted on 2021/04/22.
//

import RxSwift
import XCTest

@testable import Multilingual_News

class RealmManagerTests: XCTestCase {
    
    private let realmManager = RxRealmManager.shared
    private let disposeBag = DisposeBag()
    
    var realmLanguages: [Language] = [Language]() {
        didSet {
            checkIfRealmDataIsEmpty()
            realmLanguages.forEach { (language) in
                print("language: \(language)")
            }
        }
    }

    override func setUp() {
    }
    
    override func tearDown() {
    }

    func testRealmManager_WhenSaveLanguageInfo_ShouldReturnTrue() {
        fetchRealmData()
        
    }
    
    private func checkIfRealmDataIsEmpty() {
        if realmLanguages.isEmpty {
            realmManager.saveLanguagesInfo(withInfo: DefaultValues().languages)
                .subscribe(onCompleted: {
                    print("Completed")
                })
                .disposed(by: disposeBag)
        } else {
            print("Not First Run2")
        }
    }
    
    private func fetchRealmData() {
        realmManager.fetchLanguageInfo()
            .subscribe(onSuccess: { result in
                self.realmLanguages = result
            }, onFailure: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
