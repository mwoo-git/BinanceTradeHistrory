//
//  CoinListController.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/06/05.
//

import UIKit
import RxSwift

private let reuseIdentifier = "CoinCell"

class CoinListController: UITableViewController {
    
    // MARK: Properties
    
    private let socket = BinanceWebSocketService.shared
    weak var mainTabController: MainTabController?
    private var vm = CoinListViewModel()
    private let disposeBag = DisposeBag()
    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private var countdownButton: UIBarButtonItem!
    private var countdownTimer: Timer?
    private var countdownValue: Int = 15
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSortMenu()
        configureSearchController()
        configureUI()
        bind()
        configureCountdownButton()
        obserber()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 타이머가 실행 중인 경우, 뷰가 사라질 때 타이머를 정지합니다.
        stopCountdownTimer()
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
    
    func configureSearchController() {
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
    
    func configureCountdownButton() {
        countdownButton = UIBarButtonItem(title: "조회", style: .plain, target: self, action: #selector(countdownButtonTapped))
        navigationItem.rightBarButtonItem = countdownButton
    }
    
    func obserber() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleColorChanged), name: NSNotification.Name(Notification.colorChangedNotification), object: nil)
    }
    
    // MARK: - Actions
    
    @objc func countdownButtonTapped() {
        vm.fetchTickers()
        countdownValue = 15
        if countdownTimer == nil {
            startCountdownTimer()
        } else {
            stopCountdownTimer()
        }
    }
    
    @objc func handleColorChanged() {
        vm.updateCoinlist()
    }
    
    // MARK: - Timer
    
    func startCountdownTimer() {
        /// 카운트 다운이 시작되면 버튼 타이틀을 변경하고, 1초마다 카운트 다운을 감소시키는 타이머를 시작합니다.
        countdownButton.title = "\(countdownValue)"
        countdownButton.isEnabled = false
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
        
        /// 타이머를 백그라운드 큐에서 실행
        if let timer = countdownTimer {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    func stopCountdownTimer() {
        /// 카운트 다운을 정지하고, 버튼 타이틀을 "조회"로 변경합니다.
        countdownTimer?.invalidate()
        countdownTimer = nil
        countdownButton.title = "조회"
        countdownButton.isEnabled = true
        countdownButton.tintColor = .systemBlue
    }
    
    @objc func updateCountdown() {
        /// 카운트 다운을 1초씩 감소시키고, 0이 되면 카운트 다운을 종료합니다.
        countdownValue -= 1
        countdownButton.title = "\(countdownValue)"
        
        if countdownValue == 0 {
            stopCountdownTimer()
        }
    }
}

// MARK: - UITableViewDataSource

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = inSearchMode ? vm.filterd.value[indexPath.row] : vm.coinlist.value[indexPath.row]
        if socket.currentCoinSubject.value ?? "" != coin.symbol {
            socket.send(withSymbol: coin.symbol)
        }
        mainTabController?.selectedIndex = 1
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

