//
//  CreateHabitViewController.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 27.04.2023.
//

import UIKit

protocol CreateScheduleDelegate: AnyObject {
    func createScheduleTracker (schedule: [String])
}

protocol CreateCategoryDelegate: AnyObject {
    func createCategory (category: String)
}

final class CreateHabitViewController: UIViewController {
    
    private let headerLabel = UILabel()
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    private let textNotification = UILabel()
    private let nameTextField  = TextField()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let tableForCreateHabit = UITableView()
    private let dataForTable = ["Категория", "Расписание"]
    static let shared = CreateHabitViewController()
    private let storage = Storage.shared
    private let createSchedule = CreateScheduleViewController.shared
    private let createCategory = CategoryViewController.shared
    private let emodji = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    private let colors: [UIColor] = [.ColorSet1, .ColorSet2, .ColorSet3, .ColorSet4, .ColorSet5, .ColorSet6, .ColorSet7, .ColorSet8, .ColorSet9, .ColorSet10, .ColorSet11, .ColorSet12, .ColorSet13, .ColorSet14, .ColorSet15, .ColorSet16, .ColorSet17, .ColorSet18]
    private var selectedColor: UIColor?
    private var selectedEmoji: String?
    private var category = ""
    private var visibleDay = ""
    private var nameHabit = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableForCreateHabit.delegate = self
        tableForCreateHabit.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        nameTextField.delegate = self
        tableForCreateHabit.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableForCreateHabit.register(CreateHabitCell.self, forCellReuseIdentifier: "cellCustom")
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "emojiCell")
        collectionView.register(SupplementaryViewEmojiColor.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        makeUI()
        createSchedule.delegate = self
        createCategory.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
        
    }
}

extension CreateHabitViewController {
    func makeUI() {
        view.backgroundColor = .YPWhiteDay
        
        let uiElementOnGeneralView = [headerLabel, scrollView]
        let uiElementsOnContentView = [nameTextField, cancelButton, createButton, tableForCreateHabit, collectionView]
        
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        uiElementOnGeneralView.forEach({view.addSubview($0)})
        uiElementOnGeneralView.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        uiElementsOnContentView.forEach({contentView.addSubview($0)})
        uiElementsOnContentView.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
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
        createButton.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        
        collectionView.isScrollEnabled = false
        
        NSLayoutConstraint.activate([
        // scrollView.heightAnchor.constraint(equalToConstant: 600),
           // scrollView.widthAnchor.constraint(equalToConstant: view.frame.width),
            scrollView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 14),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.widthAnchor.constraint(equalToConstant: contentView.frame.width - 32),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            tableForCreateHabit.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tableForCreateHabit.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            tableForCreateHabit.widthAnchor.constraint(equalToConstant: 343),
            tableForCreateHabit.heightAnchor.constraint(equalToConstant: 150),
            collectionView.topAnchor.constraint(equalTo: tableForCreateHabit.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -46),
            collectionView.heightAnchor.constraint(equalToConstant: 500),
            cancelButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 30),
           // cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -37),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 161),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
           // createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -37),
            createButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 30),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createButton.widthAnchor.constraint(equalToConstant: 161),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    @objc
    func cancelTap() {
        dismiss(animated: true)
    }
    
    @objc
    func addTracker () {
        guard let text = nameTextField.text else { return }
        nameHabit = text
        guard let selectedEmoji = selectedEmoji else { return }
        guard let selectedColor = selectedColor else { return }
        storage.addNewTracker(name: nameHabit, emoji: selectedEmoji, color: selectedColor, schedule: visibleDay, category: category)
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\(nameHabit), \(selectedEmoji), \(selectedColor), \(visibleDay)")
        dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            guard let window = UIApplication.shared.windows.first else { return assertionFailure("Invalid Configuration") }
            let tabBarViewController = TabBarViewController()
            window.rootViewController = tabBarViewController
        }
    }
    
    @objc func textFieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField, textField == nameTextField {
            if textField.text?.count ?? 0 >= 38 {
                view.addSubview(textNotification)
                textNotification.translatesAutoresizingMaskIntoConstraints = false
                textNotification.text = "Ограничение 38 символов"
                textNotification.font = UIFont.systemFont(ofSize: 15)
                textNotification.textColor = .YPRed
                
                NSLayoutConstraint.activate([
                    textNotification.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 6),
                    textNotification.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                ])
            }
        }
    }
}

extension CreateHabitViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if visibleDay.isEmpty && category.isEmpty {
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellCustom", for: indexPath) as! CreateHabitCell
            cell.firstLabel.text = dataForTable[indexPath.row]
            cell.backgroundColor = .YPBackgroundDay
            cell.accessoryType = .disclosureIndicator
            if indexPath.row == 0 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                cell.secondaryLabel.text = category
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                cell.secondaryLabel.text = visibleDay
            }
            return cell
        }
    }
}


extension CreateHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            present(createSchedule, animated: true)
        } else {
            present(createCategory, animated: true)
        }
    }
}

extension CreateHabitViewController: CreateScheduleDelegate {
    func createScheduleTracker(schedule: [String]) {
        visibleDay = schedule.joined(separator: ", ")
        tableForCreateHabit.reloadData()
    }
}

extension CreateHabitViewController: CreateCategoryDelegate {
    func createCategory(category: String) {
        self.category = category
        tableForCreateHabit.reloadData()
    }
}

extension CreateHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 38
    }
}

extension CreateHabitViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return emodji.count
        case 1: return colors.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0: if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? EmojiCell {
            cell.textLabel.text = emodji[indexPath.row]
            cell.textLabel.font = UIFont.systemFont(ofSize: 32)
            return cell
        }
        case 1: if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? EmojiCell {
            cell.backgroundColor = colors[indexPath.row]
            cell.layer.cornerRadius = 8
            return cell
        }
        default: return UICollectionViewCell()
        }
        fatalError("Cell not found")
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String = "header"
        
        switch indexPath.section {
        case 0: if let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SupplementaryViewEmojiColor {
            view.titleLabel.text = "Emoji"
            view.titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
            return view
        }
        case 1: if let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SupplementaryViewEmojiColor {
            view.titleLabel.text = "Цвет"
            view.titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
            return view
        }
        default: break
        }
        fatalError("Cell not found")
    }
}

extension CreateHabitViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell else { return }
            cell.backgroundColor = .YPLightGray
            cell.layer.cornerRadius = 16
            selectedEmoji = cell.textLabel.text
        case 1: let cell = collectionView.cellForItem(at: indexPath)
           // cell?.layer.cornerRadius = 8
            cell?.layer.borderWidth = 3
            cell?.layer.borderColor = UIColor.YPWhiteDay.cgColor
            selectedColor = cell?.backgroundColor
        default: print("---------------------\(indexPath.section)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            cell.backgroundColor = .YPWhiteDay
            cell.layer.cornerRadius = 16
        case 1: let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.borderWidth = 0
        default: print("---------------------\(indexPath.section)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0: return CGSize(width: collectionView.frame.width / 6, height: 40)
        case 1: return CGSize(width: 40, height: 40)
        default: break
        }
        fatalError("Section not found")
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0: return 0
        case 1: return 17
        default: break
        }
        fatalError("Section not found")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            
            let indexPath = IndexPath(row: 0, section: section)
            let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            
            return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                             height: UIView.layoutFittingExpandedSize.height),
                                                             withHorizontalFittingPriority: .required,
                                                             verticalFittingPriority: .fittingSizeLevel)
        }
}

class SupplementaryViewEmojiColor: UICollectionReusableView {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -36),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//        NSLayoutConstraint.activate([
//            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
//            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            nameTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
//            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            nameTextField.widthAnchor.constraint(equalToConstant: 343),
//            nameTextField.heightAnchor.constraint(equalToConstant: 75),
//            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            cancelButton.widthAnchor.constraint(equalToConstant: 161),
//            cancelButton.heightAnchor.constraint(equalToConstant: 60),
//            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            createButton.widthAnchor.constraint(equalToConstant: 161),
//            createButton.heightAnchor.constraint(equalToConstant: 60),
//            tableForCreateHabit.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            tableForCreateHabit.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
//            tableForCreateHabit.widthAnchor.constraint(equalToConstant: 343),
//            tableForCreateHabit.heightAnchor.constraint(equalToConstant: 150),
//            collectionView.topAnchor.constraint(equalTo: tableForCreateHabit.bottomAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//            collectionView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -46)
//        ])
