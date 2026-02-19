//
//  RecentSearchTableViewCell.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/13/26.
//

import UIKit
import SnapKit

final class RecentSearchTableViewCell: BaseTableViewCell {
    var buttonTap: (() -> Void)?
    
    let recentSearchLabel = {
        let label = UILabel()
        
        label.text = "최근 검색어"
        label.textColor = .lightGray
        label.font = .boldSystemFont(ofSize: 17)
        
        return label
    }()
    let allDeleteButton = {
        let button = UIButton()
        
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)

        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        allDeleteButton.addTarget(self, action: #selector(allDeleteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func allDeleteButtonTapped() {
        buttonTap?()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(recentSearchLabel)
        contentView.addSubview(allDeleteButton)
    }
    override func configureLayout() {
        recentSearchLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
        }
        
        allDeleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
    }
}
