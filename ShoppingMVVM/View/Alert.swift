//
//  Alert.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/13/26.
//

import UIKit

final class Alert {
    static let shared = Alert()
    
    private init() {  }
    
    func makeAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default)
                    
        alert.addAction(okButton)
                    
        return alert
    }
}
