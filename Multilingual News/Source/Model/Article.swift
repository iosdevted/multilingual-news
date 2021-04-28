//
//  Article.swift
//  Multilingual News
//
//  Created by Ted on 2021/03/21.
//

import Foundation

struct ArticleResponse: Decodable {
    let articles: [Article]
}

struct Article: Decodable {
    let title: String
    let publishedAt: String
    let urlToImage: String?
    let url: String
}
