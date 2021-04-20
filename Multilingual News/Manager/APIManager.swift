//
//  APIManager.swift
//  Multilingual News
//
//  Created by Ted on 2021/03/29.
//

import UIKit
import RxSwift
import RxCocoa

class APIManager {

    static let shared: APIManager = APIManager()

    func makeResource(selectedLanguagesCode: String) -> (String) -> Resource<ArticleResponse> {
        { apiKey in
            Resource<ArticleResponse>(url: URL(string: "https://newsapi.org/v2/top-headlines?country=\(selectedLanguagesCode)&sortBy=%20popularity&apiKey=\(apiKey)")!)
        }
    }

    func produceApiKey(apiKeys: [String]) -> Observable<String> {
        var index = 0
        return Observable.create { observer in
            observer.onNext(apiKeys[index % apiKeys.count])
            observer.onCompleted()
            index += 1
            return Disposables.create()
        }
    }
}
