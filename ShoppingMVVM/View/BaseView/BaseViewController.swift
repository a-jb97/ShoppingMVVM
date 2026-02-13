//
//  BaseViewController.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/13/26.
//

import UIKit

class BaseViewController: UIViewController, ViewDesignProtocol {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        
    }
    
    func configureLayout() {
        
    }
    
    func configureView() {
        view.backgroundColor = .black
    }
    
    func keyboardDismiss() {
        view.endEditing(true)
    }
    
    func changeNavTitleColor() {
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func showAlert(message: String) {
        let alert = Alert.shared.makeAlert(message: message)
        
        self.present(alert, animated: true)
    }
}
