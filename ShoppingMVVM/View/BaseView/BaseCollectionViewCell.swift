//
//  BaseCollectionViewCell.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/13/26.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, ViewDesignProtocol {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        
    }
    
    func configureLayout() {
        
    }
    
    func configureView() {
        contentView.backgroundColor = .black
    }
}
