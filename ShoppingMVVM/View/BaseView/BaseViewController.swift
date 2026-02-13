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
}
