//
//  Shopping.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/13/26.
//

import Foundation

struct Shopping: Decodable {
    let total: Int
    let items: [ShoppingDetail]
}

struct ShoppingDetail: Decodable {
    let title: String
    let image: String
    let lprice: String
    let mallName: String
    let productId: String
}
