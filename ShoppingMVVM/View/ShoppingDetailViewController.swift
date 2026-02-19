//
//  ShoppingDetailViewController.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/13/26.
//

import UIKit
import SnapKit
import Kingfisher

final class ShoppingDetailViewController: BaseViewController {
    private let totalLabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .accent
        
        return label
    }()
    private let sortAccuracyButton = SortButton(title: "정확도")
    private let sortDateButton = SortButton(title: "날짜순")
    private let sortHighPriceButton = SortButton(title: "가격높은순")
    private let sortLowPriceButton = SortButton(title: "가격낮은순")
    lazy var shoppingCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ShoppingDetailViewController.layout())
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        
        collectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    var viewModel = ShoppingDetailViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedButtonUI(selectedButton: sortAccuracyButton)
        self.shoppingCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortAccuracyButton.addTarget(self, action: #selector(sortAccuracyButtonTapped), for: .touchUpInside)
        sortDateButton.addTarget(self, action: #selector(sortDateButtonTapped), for: .touchUpInside)
        sortHighPriceButton.addTarget(self, action: #selector(sortHighPriceButtonTapped), for: .touchUpInside)
        sortLowPriceButton.addTarget(self, action: #selector(sortLowPriceButtonTapped), for: .touchUpInside)
        
        viewModel.input.keyword.bind { [weak self] value in
            self?.navigationItem.title = value
        }
        
        viewModel.output.productList.lazyBind { [weak self] _ in
            // MARK: collectionView 리로드, 최상단으로 스크롤
            self?.shoppingCollectionView.reloadData()
        }
        
        viewModel.input.total.bind { [weak self] value in
            self?.totalLabel.text = "\(value.formatted()) 개의 검색 결과"
        }
        
        viewModel.output.failNetworking.lazyBind { error in
            self.showAlert(message: error!.description)
        }
    }
    
    private static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let inset: CGFloat = 16
        let spacing: CGFloat = 16
        let screenWidth = UIScreen.main.bounds.width
        
        let totalInset = inset * 2
        let totalSpacing = spacing
        let itemWidth = (screenWidth - totalInset - totalSpacing) / 2
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.4)
        
        return layout
    }
    
    // MARK: 선택한 버튼만 UI 변경, 중복 선택 방지
    private func selectedButtonUI(selectedButton: UIButton) {
        let buttons = [sortAccuracyButton, sortDateButton, sortHighPriceButton, sortLowPriceButton]
        
        for button in buttons {
            button.isSelected = false
            button.isEnabled = true
            
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
            button.layer.borderColor = UIColor.white.cgColor
            
            if button == selectedButton {
                button.isSelected = true
                button.isEnabled = false
                
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .white
            }
        }
    }
    
    @objc private func sortAccuracyButtonTapped() {
        viewModel.input.start.value = 1
        viewModel.input.sortStatus.value = .sim
        
        self.selectedButtonUI(selectedButton: self.sortAccuracyButton)
        self.shoppingCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
    
    @objc private func sortDateButtonTapped() {
        viewModel.input.start.value = 1
        viewModel.input.sortStatus.value = .date
        
        self.selectedButtonUI(selectedButton: self.sortDateButton)
        self.shoppingCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
    
    @objc private func sortHighPriceButtonTapped() {
        viewModel.input.start.value = 1
        viewModel.input.sortStatus.value = .dsc
        
        self.selectedButtonUI(selectedButton: self.sortHighPriceButton)
        self.shoppingCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
    
    @objc private func sortLowPriceButtonTapped() {
        viewModel.input.start.value = 1
        viewModel.input.sortStatus.value = .asc
        
        self.selectedButtonUI(selectedButton: self.sortLowPriceButton)
        self.shoppingCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
    
    override func configureHierarchy() {
        view.addSubview(totalLabel)
        view.addSubview(sortAccuracyButton)
        view.addSubview(sortDateButton)
        view.addSubview(sortHighPriceButton)
        view.addSubview(sortLowPriceButton)
        view.addSubview(shoppingCollectionView)
    }
    override func configureLayout() {
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        sortAccuracyButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(40)
        }
        
        sortDateButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(sortAccuracyButton.snp.trailing).offset(8)
            make.height.equalTo(40)
        }
        
        sortHighPriceButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(sortDateButton.snp.trailing).offset(8)
            make.height.equalTo(40)
        }
        
        sortLowPriceButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(sortHighPriceButton.snp.trailing).offset(8)
            make.height.equalTo(40)
        }
        
        shoppingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sortAccuracyButton.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ShoppingDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.input.start.value > 90 {
            return
        } else {
            if indexPath.item == (viewModel.output.productList.value.count - 1) && viewModel.output.productList.value.count <= viewModel.input.total.value {
                viewModel.input.start.value += 30
                
                NetworkManager.shared.callRequest(query: viewModel.input.keyword.value, start: viewModel.input.start.value, sort: viewModel.input.sortStatus.value.rawValue, type: Shopping.self) { shopping in
                    self.viewModel.output.productList.value.append(contentsOf: shopping.items)
                    collectionView.reloadData()
                } failure: { networkError in
                    self.showAlert(message: networkError.description)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.productList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingCollectionViewCell.identifier, for: indexPath) as! ShoppingCollectionViewCell
        let intLPrice = Int(viewModel.output.productList.value[indexPath.row].lprice)
        
        item.productImageView.kf.setImage(with: URL(string: viewModel.output.productList.value[indexPath.row].image))
        item.mallNameLabel.text = viewModel.output.productList.value[indexPath.row].mallName
        item.titleLabel.text = viewModel.output.productList.value[indexPath.row].title
        item.priceLabel.text = "\(intLPrice!.formatted())"
        
        return item
    }
}
