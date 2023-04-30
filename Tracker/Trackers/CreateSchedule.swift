//
//  CreateSchedule.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 28.04.2023.
//

import UIKit

final class CreateSchedule: UIViewController {
    private let headerLabel = UILabel()
    private let tableView = UITableView()
    private let confirmButton = UIButton()
    private let dataForTable = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресение"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellSchedule")
    }
}

extension CreateSchedule {
    func makeUI() {
        view.backgroundColor = .YPWhiteDay
        
        let allUIElements = [headerLabel, tableView, confirmButton]
        allUIElements.forEach({view.addSubview($0)})
        allUIElements.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        headerLabel.text = "Расписание"
        headerLabel.font = UIFont.systemFont(ofSize: 16)
        
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        
        confirmButton.backgroundColor = .YPBlackDay
        confirmButton.setTitle("Готово", for: .normal)
        confirmButton.setTitleColor(.YPWhiteDay, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmSchedule), for: .touchUpInside)
        confirmButton.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            confirmButton.widthAnchor.constraint(equalToConstant: 335),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
            tableView.widthAnchor.constraint(equalToConstant: 343),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc
    func confirmSchedule() {
        let trakers = TrackerViewController()
        let newTracker = Tracker(id: "\(trakers.trackers.count + 1)")
        trakers.trackers.append(newTracker)
        trakers.view.layoutIfNeeded()
       // dismiss(animated: true)
        UIView.animate(withDuration: 0.3) {
            guard let window = UIApplication.shared.windows.first else { return assertionFailure("Invalid Configuration") }
            let tabBarViewController = TabBarViewController()
            window.rootViewController = tabBarViewController
        }
    }
}

extension CreateSchedule: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSchedule", for: indexPath)
        cell.textLabel?.text = dataForTable[indexPath.row]
        cell.backgroundColor = .YPBackgroundDay
        let switchView = UISwitch(frame: .zero)
        switchView.onTintColor = .YPBlue
        cell.accessoryView = switchView
        if indexPath.row == dataForTable.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return cell
    }
    
    
}

extension CreateSchedule: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
