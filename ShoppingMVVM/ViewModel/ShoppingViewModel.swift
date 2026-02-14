//
//  ShoppingViewModel.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/13/26.
//

import Foundation

final class ShoppingViewModel {
    var shoppingSearchKeyword: Observable<String?> = Observable(nil)
    var recentSearchKeyword: Observable<String?> = Observable(nil)
    var successNetworking: Observable<Shopping?> = Observable(nil)
    var failNetworking: Observable<NetworkManager.NetworkError?> = Observable(nil)
    var notTwoWord = Observable(())
    
    var removeAllButtonTap = Observable(())
    var removeButtonTap = Observable(0)
    
    init() {
        shoppingSearchKeyword.lazyBind { value in
            self.search(keyword: value ?? "")
        }
        
        recentSearchKeyword.lazyBind { value in
            self.search(keyword: value ?? "")
        }
    }
    
    func search(keyword: String) {
        // MARK: searchBar의 text가 2글자 이상일 때만
        if keyword.replacingOccurrences(of: " ", with: "").count >= 2 {
            // MARK: 최근 검색어 중복 저장 방지, 공백 제거
            if !UserDefaultsManager.searchKeywords.contains(keyword.replacingOccurrences(of: " ", with: "")) {
                UserDefaultsManager.appendKeyword(keyword.replacingOccurrences(of: " ", with: ""))
            } else {
                UserDefaultsManager.insertKeywordIfContain(keyword.replacingOccurrences(of: " ", with: ""))
            }
            
            NetworkManager.shared.callRequest(query: keyword, start: 1, sort: "sim", type: Shopping.self) { shopping in
                self.successNetworking.value = shopping
                
            } failure: { networkError in
                self.failNetworking.value = networkError
            }
            
        } else {
            self.notTwoWord.value = ()
        }
    }
}
