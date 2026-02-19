//
//  ShoppingCollectionViewCell.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/13/26.
//

import UIKit
import SnapKit

final class ShoppingCollectionViewCell: BaseCollectionViewCell {
    let productImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = .accent
        
        return imageView
    }()
    let likeButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        
        return button
    }()
    let mallNameLabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        
        return label
    }()
    let titleLabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 2
        
        return label
    }()
    let priceLabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    let viewModel = ShoppingCollectionViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        viewModel.output.isLike.bind { isLike in
            if isLike {
                self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.likeButton.tintColor = .accent

            } else {
                self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                self.likeButton.tintColor = .black
            }
        }
    }
    
    override func prepareForReuse() {
        self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        self.likeButton.tintColor = .black
    }
    
    @objc private func likeButtonTapped() {
        viewModel.input.likeTap.value = ()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(productImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    override func configureLayout() {
        productImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.width.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(productImageView.snp.width)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.equalTo(productImageView.snp.trailing).inset(8)
            make.bottom.equalTo(productImageView.snp.bottom).inset(8)
            make.width.height.equalTo(40)
        }
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(4)
            make.leading.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
}
