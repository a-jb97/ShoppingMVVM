//
//  ShoppingDetailViewModel.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/13/26.
//

import Foundation

final class ShoppingDetailViewModel {
    enum Sort: String {
        case sim = "sim"
        case date = "date"
        case dsc = "dsc"
        case asc = "asc"
    }
    
    var keyword: Observable<String> = Observable("")
    
    var sortAccuracy: Observable = Observable(())
    var sortDate: Observable = Observable(())
    var sortHighPrice: Observable = Observable(())
    var sortLowPrice: Observable = Observable(())
    
    var productList: Observable<[ShoppingDetail]> = Observable([])
    var start: Observable<Int> = Observable(1)
    var total: Observable<Int> = Observable(0)
    var sortStatus: Observable<Sort> = Observable(.sim)
    
    var failNetworking: Observable<NetworkManager.NetworkError?> = Observable(nil)
    
    init() {
        sortStatus.lazyBind { _ in
            self.searchKeyword()
        }
    }
    
    func searchKeyword() {
        NetworkManager.shared.callRequest(query: self.keyword.value, start: self.start.value, sort: sortStatus.value.rawValue, type: Shopping.self) { shopping in
            self.productList.value = shopping.items
            
            self.total.value = shopping.total

        } failure: { networkError in
            self.failNetworking.value = networkError
        }
    }
}
