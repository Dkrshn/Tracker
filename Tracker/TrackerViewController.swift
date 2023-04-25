//
//  ViewController.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 20.04.2023.
//

import UIKit

class TrackerViewController: UIViewController {
    
    private let emptyImage = UIImageView()
    private let emptyLable = UILabel()
    private let header = UILabel()
    private let searchTextField  = UISearchTextField()
    private let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPWhiteDay
        makeUI()
    }
    
    @objc
    func addTracker() {
        
    }
}

extension TrackerViewController {
    func makeUI() {
        
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.sizeThatFits(CGSize(width: view.frame.width, height: 81))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(addTracker))
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        let date = UIBarButtonItem(customView: datePicker)
        navBar.topItem?.setRightBarButton(date, animated: false)
        navBar.topItem?.setLeftBarButton(addButton, animated: false)
        addButton.tintColor = .YPBlackDay
        addButton.width = 19
        
        let allUIElements = [emptyImage, emptyLable, header, searchTextField, datePicker]
        allUIElements.forEach({view.addSubview($0)})
        allUIElements.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        emptyImage.image = UIImage(named: "emptyTracker")
        
        emptyLable.text = "Что будем отслеживать?"
        emptyLable.font = UIFont.systemFont(ofSize: 12)
        emptyLable.tintColor = .YPBlackDay
        
        header.text = "Трекеры"
        header.font = UIFont.boldSystemFont(ofSize: 34)
        header.tintColor = .YPBlackDay
        
        searchTextField.layer.backgroundColor = UIColor.YPGray.cgColor
        searchTextField.layer.cornerRadius = 10
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Поиск")
        searchTextField.font = UIFont.systemFont(ofSize: 17)
        
        
        NSLayoutConstraint.activate([
            emptyImage.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 366),
            emptyImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyLable.centerXAnchor.constraint(equalTo: emptyImage.centerXAnchor),
            emptyLable.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 8),
            header.leadingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            header.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            searchTextField.leadingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextField.topAnchor.constraint(lessThanOrEqualTo: header.bottomAnchor, constant: 7),
            datePicker.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 47)
        ])
    }
}
