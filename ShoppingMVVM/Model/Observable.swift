//
//  Observable.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/13/26.
//

import Foundation

final class Observable<T> {
    private var action: ((T) -> Void)?
    
    var value: T {
        didSet {
            action?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(action: @escaping (T) -> Void) {
        action(value)
        
        self.action = action
    }
}
