//
//  BaseViewModel.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/19/26.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform()
}
