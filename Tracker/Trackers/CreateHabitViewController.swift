//
//  CreateHabitViewController.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 27.04.2023.
//

import UIKit

final class CreateHabitViewController: UIViewController {
    
    private let headerLabel = UILabel()
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    private let nameTextField  = TextField()
    private let tableForCreateHabit = UITableView()
    private let dataForTable = ["Категория", "Расписание"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableForCreateHabit.delegate = self
        tableForCreateHabit.dataSource = self
        tableForCreateHabit.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        makeUI()
    }
}

extension CreateHabitViewController {
    func makeUI() {
        view.backgroundColor = .YPWhiteDay
        
        let allUIElements = [headerLabel, nameTextField, cancelButton, createButton, tableForCreateHabit]
        allUIElements.forEach({view.addSubview($0)})
        allUIElements.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
      //  tableForCreateHabit.backgroundColor = .YPBackgroundDay
        tableForCreateHabit.layer.masksToBounds = true
        tableForCreateHabit.layer.cornerRadius = 10
        tableForCreateHabit.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        nameTextField.layer.cornerRadius = 10
        nameTextField.leftView = nil
        nameTextField.layer.backgroundColor = UIColor.YPBackgroundDay.cgColor
        nameTextField.textColor = .YPBlackDay
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.placeholder = "Введите название трекера"
        nameTextField.font = UIFont.systemFont(ofSize: 17)
        
        headerLabel.text = "Новая привычка"
        headerLabel.textColor = .YPBlackDay
        headerLabel.font = UIFont.systemFont(ofSize: 16)
        
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.YPRed.cgColor
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.setTitleColor(.YPRed, for: .normal)
        cancelButton.layer.cornerRadius = 16
        cancelButton.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)
        
        createButton.backgroundColor = .YPGray
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.YPWhiteDay, for: .normal)
        createButton.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: 343),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 161),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createButton.widthAnchor.constraint(equalToConstant: 161),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            
            tableForCreateHabit.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableForCreateHabit.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            tableForCreateHabit.widthAnchor.constraint(equalToConstant: 343),
            tableForCreateHabit.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    @objc
    func cancelTap() {
        dismiss(animated: true)
    }
}

extension CreateHabitViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataForTable[indexPath.row]
        cell.backgroundColor = .YPBackgroundDay
        cell.accessoryType = .disclosureIndicator
        if indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
}


extension CreateHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            let createSchedule = CreateSchedule()
            present(createSchedule, animated: true)
        }
        
    }
}
