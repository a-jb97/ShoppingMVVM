//
//  ViewDesignProtocol.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/13/26.
//

import Foundation

protocol ViewDesignProtocol: AnyObject {
    func configureHierarchy()
    func configureLayout()
    func configureView()
}
