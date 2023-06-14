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
    private let emptyLabel = UILabel()
    private let emptyImage = UIImageView()
  //  private var savedCategories: [String] = []
    private var choiceCategory: String = ""
    static let shared = CategoryViewController()
   // weak var delegate: CreateCategoryDelegate?
    private var viewModel: CategoryViewModel?
    
    private var savedCategory: NSObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.readAndSaveCategory()
        viewModel = CategoryViewModel()
        bind()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellCategory")
        tableView.delegate = self
        tableView.dataSource = self
        makeUi()
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        savedCategory = viewModel.observe(\.savedCategory, options: [.new], changeHandler: { [weak self] _, change in
            guard let self = self else { return }
            self.tableView.reloadData()
        })
    }
}

extension CategoryViewController {
    func makeUi() {
        view.backgroundColor = .YPWhiteDay
        
        let allUIElements = [header, confirmButton]
        allUIElements.forEach({view.addSubview($0)})
        allUIElements.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        header.text = "Категория"
        header.textColor = .YPBlackDay
        header.font = UIFont.systemFont(ofSize: 16)
        
        confirmButton.backgroundColor = .YPBlackDay
        confirmButton.setTitle("Добавить категорию", for: .normal)
        confirmButton.setTitleColor(.YPWhiteDay, for: .normal)
        confirmButton.layer.cornerRadius = 16
        confirmButton.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            confirmButton.widthAnchor.constraint(equalToConstant: 335),
            confirmButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
       guard let savedCategoryIsEmpty = viewModel?.checkSavedCategory() else { return }
        
        if savedCategoryIsEmpty {
            
            let emptyElements = [emptyLabel, emptyImage]
            emptyElements.forEach({view.addSubview($0)})
            emptyElements.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
            
            emptyLabel.text = "Привычки и события можно \n объединить по смыслу"
            emptyLabel.numberOfLines = 2
            emptyLabel.textAlignment = .center
            
            emptyImage.image = UIImage(named: "emptyTracker")
            
            NSLayoutConstraint.activate([
                emptyImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -373),
                emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 8),
                emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            
            
        } else {
            
            view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            tableView.layer.masksToBounds = true
            tableView.layer.cornerRadius = 10
            tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            
            NSLayoutConstraint.activate([
                tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 38),
                tableView.widthAnchor.constraint(equalToConstant: 343),
                tableView.heightAnchor.constraint(equalToConstant: 75)
            ])
        }
    }
    
    func removeEmptyElement() {
        emptyLabel.removeFromSuperview()
        emptyImage.removeFromSuperview()
    }
    
    func addTableViewOnUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 38),
            tableView.widthAnchor.constraint(equalToConstant: 343),
            tableView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    @objc
    func addCategory() {
        if choiceCategory.isEmpty {
            let createCategory = NewCategoryViewController()
            createCategory.delegate = self
            present(createCategory, animated: true)
        } else {
            dismiss(animated: true)
           // delegate?.createCategory(category: savedCategories[0])
            print("---------------\(choiceCategory)")
            viewModel?.createCategory(choiceCategory)
        }
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return savedCategories.count
        guard let numberOfRows = viewModel?.savedCategory.count else { return 0 }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath)
      //  cell.textLabel?.text = savedCategories[indexPath.row]
        guard let dataForTable = viewModel?.savedCategory else { return UITableViewCell() }
        cell.textLabel?.text = dataForTable[indexPath.row]
        cell.backgroundColor = .YPBackgroundDay
     //   if indexPath.row == savedCategories.count - 1 {
        if indexPath.row == dataForTable.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath),
           let text = cell.textLabel?.text {
            cell.accessoryType = .checkmark
            choiceCategory = text
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

extension CategoryViewController: NewCategoryViewControllerDelegate {
    func returnCategory(_ category: String) {
        guard let isEmptySavedCategories = viewModel?.checkSavedCategory() else { return }
        if isEmptySavedCategories {
            viewModel?.addCategory(category)
            addTableViewOnUI()
            removeEmptyElement()
        } else {
            viewModel?.addCategory(category)
          //  tableView.reloadData()
        }
    }
}
