//
//  RecentSearchListTableViewCell.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/13/26.
//

import UIKit
import SnapKit

final class RecentSearchListTableViewCell: BaseTableViewCell {
    var buttonTap: (() -> Void)?
    
    let magnifyImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .lightGray
        
        return imageView
    }()
    let keywordLabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        
        return label
    }()
    let deleteButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .lightGray
        
        return button
    }()
    
    let row = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func deleteButtonTapped() {
        buttonTap?()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(magnifyImageView)
        contentView.addSubview(keywordLabel)
        contentView.addSubview(deleteButton)
    }
    override func configureLayout() {
        magnifyImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.height.width.equalTo(20)
        }
        
        keywordLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(magnifyImageView.snp.trailing).offset(16)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
    }
}
