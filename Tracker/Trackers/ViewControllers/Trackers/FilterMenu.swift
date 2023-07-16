//
//  FilterMenu.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 06.07.2023.
//

import UIKit

final class FilterMenu: UIViewController {
    
    private lazy var header: UILabel = {
        var header = UILabel()
        header.text = "Фильтры"
        header.font = UIFont.systemFont(ofSize: 16)
        header.textColor = .YPBlackDay
        return header
    }()
    
    private let tableView = UITableView()
    private let dataForTable = ["Все трекеры", "Трекеры на сегодня", "Завершенные", "Не завершенные"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPWhiteDay
        makeUI()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellForFilterMenu")
    }
}

extension FilterMenu {
    func makeUI() {
        let allUIElements = [header, tableView]
        allUIElements.forEach({view.addSubview($0)})
        allUIElements.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 38),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalToConstant: 343),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}

extension FilterMenu: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForFilterMenu", for: indexPath)
        cell.textLabel?.text = dataForTable[indexPath.row]
        cell.backgroundColor = .YPLightGray
        if indexPath.row == dataForTable.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return cell
    }
}

extension FilterMenu: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath),
           let text = cell.textLabel?.text {
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
}
