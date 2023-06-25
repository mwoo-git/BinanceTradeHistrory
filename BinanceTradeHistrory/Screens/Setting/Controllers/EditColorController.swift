//
//  EditColorController.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/06/23.
//

import UIKit

class EditColorController: UIViewController {
    // MARK: - Properties
    
    private var isBlue = false {
        didSet {
            buyCircleView.backgroundColor = isBlue ? .systemRed : .systemGreen
            sellCircleView.backgroundColor = isBlue ? .systemBlue : .systemRed
            
            Notification.post(withName: Notification.colorChanged)
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "매수 / 매도"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let frame: CGFloat = 50
    
    private lazy var buyCircleView: UIView = {
        let view = UIView()
        view.setDimensions(height: frame, width: frame)
        view.layer.cornerRadius = frame / 2
        return view
    }()
    
    private lazy var sellCircleView: UIView = {
        let view = UIView()
        view.setDimensions(height: frame, width: frame)
        view.layer.cornerRadius = frame / 2
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "오른쪽 상단의 변경 버튼을 눌러 매수/매도 색상을 바꿔보세요."
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureColor()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "매수 / 매도 색상 변경"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "변경",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleEditing))
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingLeft: 12)
        
        let stackView = UIStackView(arrangedSubviews: [buyCircleView, sellCircleView])
        stackView.axis = .horizontal
        stackView.spacing = 12
        
        view.addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 12)
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 12, paddingRight: 12)
        
    }
    
    func configureColor() {
        isBlue = UserDefaults.standard.bool(forKey: UserDefault.colorKey)
    }
    
    // MARK: - Helpers
    
    @objc func handleEditing() {
        UserDefaults.standard.set(isBlue ? false : true, forKey: UserDefault.colorKey)
        configureColor()
    }
    
    // MARK: - Actions
}
