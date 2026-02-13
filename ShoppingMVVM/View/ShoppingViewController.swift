//
//  ShoppingViewController.swift
//  ShoppingMVVM
//
//  Created by 전민돌 on 2/13/26.
//

import UIKit
import SnapKit
import Alamofire

class ShoppingViewController: BaseViewController {
    lazy var shoppingSearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.delegate = self
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.searchBarStyle = .minimal
        
        return searchBar
    }()
    lazy var recentSearchTableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.backgroundColor = .black
        
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shoppingSearchBar.becomeFirstResponder()
        
        recentSearchTableView.isHidden = false
        recentSearchTableView.reloadData()
    }
    
    override func configureHierarchy() {
        view.addSubview(shoppingSearchBar)
        view.addSubview(recentSearchTableView)
    }
    override func configureLayout() {
        shoppingSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        recentSearchTableView.snp.makeConstraints { make in
            make.top.equalTo(shoppingSearchBar.snp.bottom)
            make.horizontalEdges.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        super.configureView()
        
        navigationItem.title = "도봉러의 쇼핑쇼핑"
        changeNavTitleColor()
    }
}

extension ShoppingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let vc = ShoppingDetailViewController()
        
        // MARK: searchBar의 text가 2글자 이상일 때만
        if searchBar.text!.replacingOccurrences(of: " ", with: "").count >= 2 {
            // MARK: 최근 검색어 중복 저장 방지, 공백 제거
            if !UserDefaultsManager.searchKeywords.contains(searchBar.text!.replacingOccurrences(of: " ", with: "")) {
                UserDefaultsManager.appendKeyword(searchBar.text!.replacingOccurrences(of: " ", with: ""))
            } else {
                UserDefaultsManager.insertKeywordIfContain(searchBar.text!.replacingOccurrences(of: " ", with: ""))
            }
            
            vc.navigationItem.title = searchBar.text
            vc.start = 1
            
            NetworkManager.shared.callRequest(query: searchBar.text!, start: 1, sort: "sim", type: Shopping.self) { shopping in
                vc.total = shopping.total
                vc.sortAccuracyButton.isSelected = true
                vc.totalLabel.text = "\(shopping.total.formatted()) 개의 검색 결과"
                vc.productList = shopping.items
                vc.shoppingCollectionView.reloadData()
            } failure: { networkError in
                self.showAlert(message: networkError.description)
            }

            
            shoppingSearchBar.text = nil
            shoppingSearchBar.endEditing(true)
            recentSearchTableView.isHidden = true
            
            navigationController?.pushViewController(vc, animated: true)
        } else {
            self.showAlert(message: "2글자 이상 검색해주세요!")
        }
    }
}

extension ShoppingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaultsManager.searchKeywords.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            recentSearchTableView.register(recentSearchTableViewCell.self, forCellReuseIdentifier: recentSearchTableViewCell.identifier)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: recentSearchTableViewCell.identifier, for: indexPath) as! recentSearchTableViewCell
            
            cell.buttonTap = {
                UserDefaultsManager.searchKeywords.removeAll()
                
                tableView.reloadData()
            }
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            return cell
        } else {
            recentSearchTableView.register(recentSearchListTableViewCell.self, forCellReuseIdentifier: recentSearchListTableViewCell.identifier)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: recentSearchListTableViewCell.identifier, for: indexPath) as! recentSearchListTableViewCell
            
            cell.keywordLabel.text = UserDefaultsManager.searchKeywords[indexPath.row - 1]
            
            cell.buttonTap = {
                UserDefaultsManager.searchKeywords.remove(at: indexPath.row - 1)
                
                tableView.reloadData()
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ShoppingDetailViewController()
        
        vc.start = 1
        
        NetworkManager.shared.callRequest(query: UserDefaultsManager.searchKeywords[indexPath.row - 1], start: 1, sort: "sim", type: Shopping.self) { shopping in
            vc.total = shopping.total
            vc.sortAccuracyButton.isSelected = true
            vc.totalLabel.text = "\(shopping.total.formatted()) 개의 검색 결과"
            vc.productList = shopping.items
            vc.shoppingCollectionView.reloadData()
        } failure: { networkError in
            self.showAlert(message: networkError.description)
        }
        
        shoppingSearchBar.endEditing(true)
        recentSearchTableView.isHidden = true
        
        UserDefaultsManager.insertKeywordIfContain(UserDefaultsManager.searchKeywords[indexPath.row - 1])
        vc.navigationItem.title = UserDefaultsManager.searchKeywords[0]
        shoppingSearchBar.text = UserDefaultsManager.searchKeywords[0]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
