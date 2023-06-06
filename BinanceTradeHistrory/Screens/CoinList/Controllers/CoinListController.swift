//
//  CoinListController.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/06/05.
//

import Foundation

import UIKit
import RxSwift

private let reuseIdentifier = "CoinCell"

class CoinListController: UITableViewController {
    
    // MARK: Properties
    
    private var vm = CoinListViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSortMenu()
        configureSerachController()
        configureUI()
        bind()
    }
    
    // MARK: - API
    
    func bind() {
        vm.coinlist
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configures
    
    func configureUI() {
        navigationItem.title = "바이낸스 선물"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        tableView.register(TickerCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.keyboardDismissMode = .onDrag
        
        tableView.rowHeight = 70
    }
    
    // MARK: - Helpers
    
    func configureSerachController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "코인명/심볼 검색"
        navigationItem.searchController = searchController
        definesPresentationContext = false
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
    }
    
    func configureSortMenu() {
        let volumeAction = UIAction(title: "거래량") { _ in
            guard self.vm.sort != .volume else { return }
            self.vm.sort = .volume
        }
        
        let winnersAction = UIAction(title: "상승") { _ in
            guard self.vm.sort != .rise else { return }
            self.vm.sort = .rise
        }
        
        let lossersAction = UIAction(title: "하락") { _ in
            guard self.vm.sort != .fall else { return }
            self.vm.sort = .fall
        }
        
        let menu = UIMenu(title: "", children: [volumeAction, winnersAction, lossersAction])
        
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: nil)
        sortButton.menu = menu
        
        navigationItem.leftBarButtonItem = sortButton
        navigationItem.leftBarButtonItem?.tintColor = .systemBlue
    }
    
    // MARK: - Actions
}

// MARK: - TableViewDataSource

extension CoinListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? vm.filterd.value.count : vm.coinlist.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TickerCell
        
        let coin = inSearchMode ? vm.filterd.value[indexPath.row] : vm.coinlist.value[indexPath.row]
        
        cell.configure(with: coin)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CoinListController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard !inSearchMode else { return }
        searchController.dismiss(animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}


// MARK: - UISearchResultsUpdating

extension CoinListController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        let coins = vm.coinlist.value.filter({ $0.symbol.lowercased().contains(searchText) })
        vm.filterd.accept(coins)
        
        self.tableView.reloadData()
    }
}
