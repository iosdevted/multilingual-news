//
//  Reusable.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/28.
//

protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
