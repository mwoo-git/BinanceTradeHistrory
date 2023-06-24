//
//  EditAmountController.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/06/12.
//

import UIKit

class EditAmountController: UIViewController {
    // MARK: - Properties
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "순간거래대금(USDT) 조회조건"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.clearButtonMode = .always
        textField.placeholder = "순간거래대금(USDT)"
        textField.keyboardType = .numberPad
        textField.delegate = self
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "설정하신 순간거래대금 이상의 체결내역만 보여지게 됩니다. 자유롭게 설정해보세요."
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    
    // MARK: - Heplers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "순간거래대금 조회조건"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleEndEditing))
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = .lightGray
        
        view.addSubview(amountLabel)
        amountLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        view.addSubview(textField)
        textField.anchor(top: amountLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        
        view.addSubview(divider)
        divider.anchor(top: textField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 4, height: 0.5)
        
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: textField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 12, paddingRight: 12)
        
    }
    
    private func configureTextField() {
        let savedAmount = UserDefaults.standard.string(forKey: UserDefault.amountKey)
        textField.text = savedAmount
    }
    
    
    // MARK: - Actions
    
    @objc func handleEndEditing() {
        guard let text = textField.text else { return }
        UserDefaults.standard.set(text, forKey: UserDefault.amountKey)
        
        NotificationCenter.default.post(name: NSNotification.Name(Notification.amountChangedNotification), object: nil)
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

extension EditAmountController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 입력된 문자열에서 숫자만 추출
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let digits = CharacterSet.decimalDigits
        let filteredText = newText.components(separatedBy: digits.inverted).joined()
        
        // 천 단위로 쉼표 추가
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        if let number = formatter.number(from: filteredText), let formattedText = formatter.string(from: number) {
            // 달러 표시 추가
            textField.text = formattedText
            let amount = UserDefaults.standard.string(forKey: UserDefault.amountKey)
            if formattedText == amount {
                navigationItem.rightBarButtonItem?.isEnabled = false
                navigationItem.rightBarButtonItem?.tintColor = .lightGray
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = true
                navigationItem.rightBarButtonItem?.tintColor = .systemBlue
            }
        } else {
            textField.text = filteredText
        }
        
        return false
    }
}
