//
//  ShoppingDetailViewModel.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/13/26.
//

import Foundation

final class ShoppingDetailViewModel: BaseViewModel {
    enum Sort: String {
        case sim = "sim"
        case date = "date"
        case dsc = "dsc"
        case asc = "asc"
    }
    
    struct Input {
        var keyword: Observable<String> = Observable("")
        var sortAccuracy = Observable(())
        var sortDate = Observable(())
        var sortHighPrice = Observable(())
        var sortLowPrice = Observable(())
        var start: Observable<Int> = Observable(1)
        var total: Observable<Int> = Observable(0)
        var sortStatus: Observable<Sort> = Observable(.sim)
    }
    
    struct Output {
        var productList: Observable<[ShoppingDetail]> = Observable([])
        var failNetworking: Observable<NetworkManager.NetworkError?> = Observable(nil)        
    }
    
    var input: Input
    var output: Output
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.sortStatus.lazyBind { _ in
            self.searchKeyword()
        }
    }
    
    func searchKeyword() {
        NetworkManager.shared.callRequest(query: self.input.keyword.value, start: self.input.start.value, sort: input.sortStatus.value.rawValue, type: Shopping.self) { shopping in
            self.output.productList.value = shopping.items
            
            self.input.total.value = shopping.total

        } failure: { networkError in
            self.output.failNetworking.value = networkError
        }
    }
}
