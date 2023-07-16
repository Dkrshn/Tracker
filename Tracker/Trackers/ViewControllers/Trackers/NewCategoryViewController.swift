//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 12.06.2023.
//

import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func returnCategory(_ category: String)
}

final class NewCategoryViewController: UIViewController {
    
    private lazy var header: UILabel = {
        let header = UILabel()
        header.text = "Новая категория"
        header.textColor = .YPBlackDay
        header.font = UIFont.systemFont(ofSize: 16)
        return header
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = UIColor.YPBackgroundDay
        textField.textColor = .YPBlackDay
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "Введите название категории"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.addTarget(self, action: #selector(editingField), for: .editingDidBegin)
        return textField
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .YPGray
        button.addTarget(self, action: #selector(done), for: .touchUpInside)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.YPWhiteDay, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()
    
    weak var delegate: NewCategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        textField.delegate = self
    }
    
    @objc
    func done() {
        guard let newCategory = textField.text else { return }
        delegate?.returnCategory(newCategory)
        dismiss(animated: true) {
            
        }
    }
    
    @objc
    func editingField() {
        textField.becomeFirstResponder()
        checkText()
    }
}

extension NewCategoryViewController {
    func makeUI() {
        view.backgroundColor = .YPWhiteDay
        
        let allUIElements = [header, textField, confirmButton]
        allUIElements.forEach({view.addSubview($0)})
        allUIElements.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.widthAnchor.constraint(equalToConstant: 343),
            textField.heightAnchor.constraint(equalToConstant: 75),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -37),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 335),
            confirmButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func checkText() {
        if textField.text != nil {
            confirmButton.backgroundColor = .YPBlackDay
            loadViewIfNeeded()
        }
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

