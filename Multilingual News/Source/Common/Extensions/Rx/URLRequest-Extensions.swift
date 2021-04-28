//
//  URLRequest-Extensions.swift
//  Multilingual News
//
//  Created by Ted on 2021/03/21.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T: Decodable> {
    let url: URL
}

extension URLRequest {

    static func load<T>(resource: Resource<T>) -> Observable<T> {
        return Observable.just(resource.url)
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
}
