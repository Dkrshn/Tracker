//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 03.05.2023.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    private let header = UILabel()
    private let confirmButton = UIButton()
    private let tableView = UITableView()
    private let savedCategories: [String] = ["Важное"]
    static let shared = CategoryViewController()
    weak var delegate: CreateCategoryDelegate?
    
    override func viewDidLoad() {
         super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellCategory")
        tableView.delegate = self
        tableView.dataSource = self
         makeUi()
    }
}

extension CategoryViewController {
    func makeUi() {
        view.backgroundColor = .YPWhiteDay
        
        let allUIElements = [header, confirmButton, tableView]
        allUIElements.forEach({view.addSubview($0)})
        allUIElements.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        header.text = "Категория"
        header.textColor = .YPBlackDay
        header.font = UIFont.systemFont(ofSize: 16)
        
        confirmButton.backgroundColor = .YPBlackDay
        confirmButton.setTitle("Добавить категорию", for: .normal)
        confirmButton.setTitleColor(.YPWhiteDay, for: .normal)
        confirmButton.layer.cornerRadius = 16
        confirmButton.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            confirmButton.widthAnchor.constraint(equalToConstant: 335),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 38),
            tableView.widthAnchor.constraint(equalToConstant: 343),
            tableView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    @objc
    func addCategory() {
        dismiss(animated: true)
        delegate?.createCategory(category: savedCategories[0])
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath)
        cell.textLabel?.text = savedCategories[indexPath.row]
        cell.backgroundColor = .YPBackgroundDay
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        return cell
    }
    
    
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
