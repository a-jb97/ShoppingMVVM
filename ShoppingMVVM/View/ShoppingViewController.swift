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
    
    let viewModel = ShoppingViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shoppingSearchBar.becomeFirstResponder()
        
        recentSearchTableView.isHidden = false
        recentSearchTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = ShoppingDetailViewController()
        
        viewModel.output.successNetworking.lazyBind { shopping in
            vc.viewModel.input.keyword.value = self.shoppingSearchBar.text!
            vc.viewModel.input.total.value = shopping!.total
            vc.viewModel.output.productList.value = shopping!.items
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.output.failNetworking.lazyBind { error in
            self.showAlert(message: error!.description)
        }
        
        viewModel.input.removeAllButtonTap.lazyBind { _ in
            UserDefaultsManager.searchKeywords.removeAll()
            
            self.recentSearchTableView.reloadData()
        }
        
        viewModel.input.removeButtonTap.lazyBind { index in
            UserDefaultsManager.searchKeywords.remove(at: index)
            
            self.recentSearchTableView.reloadData()
        }
        
        viewModel.output.notTwoWord.lazyBind { _ in
            self.showAlert(message: "2글자 이상 검색해주세요!")
        }
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
        viewModel.input.shoppingSearchKeyword.value = searchBar.text
    }
}

extension ShoppingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaultsManager.searchKeywords.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            recentSearchTableView.register(RecentSearchTableViewCell.self, forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.identifier, for: indexPath) as! RecentSearchTableViewCell
            
            cell.buttonTap = { [weak self] in
                self?.viewModel.input.removeAllButtonTap.value = ()
            }
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            return cell
            
        } else {
            recentSearchTableView.register(RecentSearchListTableViewCell.self, forCellReuseIdentifier: RecentSearchListTableViewCell.identifier)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchListTableViewCell.identifier, for: indexPath) as! RecentSearchListTableViewCell
            
            cell.keywordLabel.text = UserDefaultsManager.searchKeywords[indexPath.row - 1]
            
            cell.buttonTap = { [weak self] in
                self?.viewModel.input.removeButtonTap.value = indexPath.row - 1
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shoppingSearchBar.text = UserDefaultsManager.searchKeywords[indexPath.row - 1]
        
        viewModel.input.recentSearchKeyword.value = shoppingSearchBar.text
    }
}
