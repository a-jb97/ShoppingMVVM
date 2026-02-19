//
//  ShoppingCollectionViewModel.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/19/26.
//

import Foundation

class ShoppingCollectionViewModel: BaseViewModel {
    struct Input {
        var likeTap = Observable(())
        var productId: Observable<String> = Observable("")
    }
    
    struct Output {
        var isLike: Observable<Bool> = Observable(false)
    }
    
    var input: Input
    var output: Output
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.likeTap.lazyBind { _ in
            self.toggleLike()
        }
        
        input.productId.bind { id in
            if UserDefaultsManager.likeIds.contains(id) {
                self.output.isLike.value = true
            } else {
                self.output.isLike.value = false
            }
        }
    }
    
    func toggleLike() {
        output.isLike.value.toggle()
        
        if output.isLike.value == true {
            if !UserDefaultsManager.likeIds.contains(input.productId.value) {
                UserDefaultsManager.likeIds.append(input.productId.value)
                
                print(UserDefaultsManager.likeIds)
            }
            
        } else {
            UserDefaultsManager.likeIds.removeAll(where: { $0 == input.productId.value })
            print(UserDefaultsManager.likeIds)
        }
    }
}
