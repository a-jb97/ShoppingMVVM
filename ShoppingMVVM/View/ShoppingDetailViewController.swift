//
//  ShoppingDetailViewController.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/13/26.
//

import UIKit
import SnapKit
import Kingfisher

class ShoppingDetailViewController: BaseViewController {
    let totalLabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .accent
        
        return label
    }()
    enum Sort: String {
        case sim = "sim"
        case date = "date"
        case dsc = "dsc"
        case asc = "asc"
    }
    let sortAccuracyButton = SortButton(title: "정확도")
    let sortDateButton = SortButton(title: "날짜순")
    let sortHighPriceButton = SortButton(title: "가격높은순")
    let sortLowPriceButton = SortButton(title: "가격낮은순")
    lazy var shoppingCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ShoppingDetailViewController.layout())
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        
        collectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    var productList: [ShoppingDetail] = []
    var start = 1
    var total = 0
    var sortStatus: Sort = .sim
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortAccuracyButton.addTarget(self, action: #selector(sortAccuracyButtonTapped), for: .touchUpInside)
        sortDateButton.addTarget(self, action: #selector(sortDateButtonTapped), for: .touchUpInside)
        sortHighPriceButton.addTarget(self, action: #selector(sortHighPriceButtonTapped), for: .touchUpInside)
        sortLowPriceButton.addTarget(self, action: #selector(sortLowPriceButtonTapped), for: .touchUpInside)
        
        selectedButtonUI(selectedButton: sortAccuracyButton)
    }
    
    static func layout() -> UICollectionViewFlowLayout {
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
        sortStatus = .sim
        start = 1
        
        NetworkManager.shared.callRequest(query: navigationItem.title!, start: start, sort: Sort.sim.rawValue, type: Shopping.self) { shopping in
            self.networkingResultButtonTapped(value: shopping)
            self.selectedButtonUI(selectedButton: self.sortAccuracyButton)
        } failure: { networkError in
            self.showAlert(message: networkError.description)
        }
    }
    
    @objc private func sortDateButtonTapped() {
        sortStatus = .date
        start = 1
        
        NetworkManager.shared.callRequest(query: navigationItem.title!, start: start, sort: Sort.date.rawValue, type: Shopping.self) { shopping in
            self.networkingResultButtonTapped(value: shopping)
            self.selectedButtonUI(selectedButton: self.sortDateButton)
        } failure: { networkError in
            self.showAlert(message: networkError.description)
        }
    }
    
    @objc private func sortHighPriceButtonTapped() {
        sortStatus = .dsc
        start = 1
        
        NetworkManager.shared.callRequest(query: navigationItem.title!, start: start, sort: Sort.dsc.rawValue, type: Shopping.self) { shopping in
            self.networkingResultButtonTapped(value: shopping)
            self.selectedButtonUI(selectedButton: self.sortHighPriceButton)
        } failure: { networkError in
            self.showAlert(message: networkError.description)
        }
    }
    
    @objc private func sortLowPriceButtonTapped() {
        sortStatus = .asc
        start = 1
        
        NetworkManager.shared.callRequest(query: navigationItem.title!, start: start, sort: Sort.asc.rawValue, type: Shopping.self) { shopping in
            self.networkingResultButtonTapped(value: shopping)
            self.selectedButtonUI(selectedButton: self.sortLowPriceButton)
        } failure: { networkError in
            self.showAlert(message: networkError.description)
        }
    }
    
    private func networkingResultButtonTapped(value: Shopping) {
        self.productList = value.items
        self.total = value.total
        self.totalLabel.text = "\(value.total.formatted()) 개의 검색 결과"
        self.updateScrollTopCollectionView()
    }
    
    // MARK: collectionView 리로드, 최상단으로 스크롤
    private func updateScrollTopCollectionView() {
        self.shoppingCollectionView.reloadData()
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
        if start > 90 {
            return
        } else {
            if indexPath.item == (productList.count - 1) && productList.count <= total {
                start += 30
                
                NetworkManager.shared.callRequest(query: navigationItem.title!, start: start, sort: sortStatus.rawValue, type: Shopping.self) { shopping in
                    self.productList.append(contentsOf: shopping.items)
                    collectionView.reloadData()
                } failure: { networkError in
                    self.showAlert(message: networkError.description)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingCollectionViewCell.identifier, for: indexPath) as! ShoppingCollectionViewCell
        let intLPrice = Int(productList[indexPath.row].lprice)
        
        item.productImageView.kf.setImage(with: URL(string: productList[indexPath.row].image))
        item.mallNameLabel.text = productList[indexPath.row].mallName
        item.titleLabel.text = productList[indexPath.row].title
        item.priceLabel.text = "\(intLPrice!.formatted())"
        
        return item
    }
}
