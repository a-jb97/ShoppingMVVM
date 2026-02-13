//
//  UserDefaultsManager.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/13/26.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let value: T
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: self.key) as? T ?? self.value }
        set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
}

class UserDefaultsManager {
    @UserDefault(key: "searchKeywords", value: [])
    static var searchKeywords: [String]
    
    // MARK: 최근 검색어 저장
    static func appendKeyword(_ keyword: String) {
        var keywords = UserDefaults.standard.stringArray(forKey: "searchKeywords") ?? []
        
        keywords.insert(keyword, at: 0)
        
        UserDefaults.standard.set(keywords, forKey: "searchKeywords")
    }
    
    // MARK: 과거 검색어 다시 검색 시 최상단으로 검색어 이동
    static func insertKeywordIfContain(_ keyword: String) {
        var keywords = UserDefaults.standard.stringArray(forKey: "searchKeywords") ?? []
        let keywordIndex: Int? = takeIndex(keyword: keyword)
        
        func takeIndex(keyword: String) -> Int? {
            for i in 0..<keywords.count {
                if keywords[i] == keyword {
                    print(i)
                    return i
                }
            }
            print("nil")
            return nil
        }
        
        if keywordIndex != nil {
            keywords.remove(at: keywordIndex!)
            keywords.insert(keyword, at: 0)
        }
        
        UserDefaults.standard.set(keywords, forKey: "searchKeywords")
    }
}
