//
//  EditTrackerHabitViewController.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 23.06.2023.
//

import UIKit

final class EditTrackerHabitViewController: UIViewController {
    
    private let headerLabel = UILabel()
    private let countDay = UILabel()
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    private let textNotification = UILabel()
    private let nameTextField  = TextField()
    private let collectionViewEmoji = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let collectionViewColor = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
    private var finalSchedule = [WeekDay]()
 //   private let categoryStore = TrackerCategoryStore.shared
  //  private let recordStore = TrackerRecordStore.shared
    private let trackerStore = TrackerStore.shared
    private let colorMarshaling = ColorAndDayMarshalling.shared
    private var indexPathEmojiCell: IndexPath?
    private var indexPathColorCell: IndexPath?

    var currentCategory: String
    var currentName: String
    var currentSchedule: [WeekDay]
    var currentCountDay: Int
    var currentEmoji: String
    var currentColor: UIColor
    var id: UUID
    
    init(currentCategory: String, currentName: String, currentSchedule: [WeekDay], currentCountDay: Int, currentEmoji: String, currentColor: UIColor, id: UUID) {
        self.currentCategory = currentCategory
        self.currentName = currentName
        self.currentSchedule = currentSchedule
        self.currentCountDay = currentCountDay
        self.currentEmoji = currentEmoji
        self.currentColor = currentColor
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableForCreateHabit.delegate = self
        tableForCreateHabit.dataSource = self
        collectionViewEmoji.delegate = self
        collectionViewColor.delegate = self
        collectionViewEmoji.dataSource = self
        collectionViewColor.dataSource = self
        nameTextField.delegate = self
        tableForCreateHabit.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableForCreateHabit.register(CreateHabitCell.self, forCellReuseIdentifier: "cellCustom")
        collectionViewEmoji.register(EmojiCell.self, forCellWithReuseIdentifier: "emojiCell")
        collectionViewColor.register(ColorCell.self, forCellWithReuseIdentifier: "colorCell")
        collectionViewEmoji.register(SupplementaryViewEmojiColor.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerEmoji")
        collectionViewColor.register(SupplementaryViewEmojiColor.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerColor")
        makeUI()
        createSchedule.delegate = self
        createCategory.delegate = self
        category = currentCategory
        visibleDay = convertWeekDaytoStringDay(weekDay: currentSchedule)
        createSchedule.addVisibleDay(visibleDay: visibleDay)
        selectedEmoji = currentEmoji
        selectedColor = currentColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
        
    }
}

extension EditTrackerHabitViewController {
    func makeUI() {
        view.backgroundColor = .YPWhiteDay
        
        let uiElementOnGeneralView = [headerLabel, scrollView]
        let uiElementsOnContentView = [nameTextField, countDay, tableForCreateHabit, collectionViewEmoji, collectionViewColor]
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
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
        nameTextField.textColor = .YPBlackDay
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.text = "\(currentName)"
        nameTextField.placeholder = "Введите название трекера"
        nameTextField.font = UIFont.systemFont(ofSize: 17)
        
        
        headerLabel.text = "Редактирование привычки"
        headerLabel.textColor = .YPBlackDay
        headerLabel.font = UIFont.systemFont(ofSize: 16)
        
        countDay.text = "\(currentCountDay) дней"
        countDay.font = UIFont.systemFont(ofSize: 32)
        
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.YPRed.cgColor
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.setTitleColor(.YPRed, for: .normal)
        cancelButton.layer.cornerRadius = 16
        cancelButton.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)
        
        createButton.setTitle("Сохранить", for: .normal)
        createButton.setTitleColor(.YPWhiteDay, for: .normal)
        createButton.layer.cornerRadius = 16
        createButton.addTarget(self, action: #selector(editTracker), for: .touchUpInside)
        createButton.backgroundColor = .YPGray
        
        collectionViewEmoji.isScrollEnabled = false
        collectionViewColor.isScrollEnabled = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 14),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -106),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countDay.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: 54),
            countDay.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 102),
            nameTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: 343),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            tableForCreateHabit.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tableForCreateHabit.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            tableForCreateHabit.widthAnchor.constraint(equalToConstant: 343),
            tableForCreateHabit.heightAnchor.constraint(equalToConstant: 150),
            collectionViewEmoji.topAnchor.constraint(equalTo: tableForCreateHabit.bottomAnchor),
            collectionViewEmoji.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionViewEmoji.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionViewEmoji.bottomAnchor.constraint(equalTo: collectionViewColor.topAnchor),
            collectionViewColor.topAnchor.constraint(equalTo: collectionViewEmoji.bottomAnchor),
            collectionViewColor.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionViewColor.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionViewColor.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionViewEmoji.heightAnchor.constraint(equalToConstant: 250),
            collectionViewColor.heightAnchor.constraint(equalToConstant: 250),
            cancelButton.topAnchor.constraint(equalTo: collectionViewColor.bottomAnchor, constant: 30),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 161),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.topAnchor.constraint(equalTo: collectionViewColor.bottomAnchor, constant: 30),
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
    func editTracker () {
        guard let text = nameTextField.text else { return }
        nameHabit = text
        guard let selectedEmoji = selectedEmoji else { return }
        guard let selectedColor = selectedColor else { return }
        try! trackerStore.updateTracker(id: id, name: nameHabit, category: category, schedule: finalSchedule, emoji: selectedEmoji, color: selectedColor)
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
    
    func checkFields() {
        if !category.isEmpty,
           !visibleDay.isEmpty,
           let text = nameTextField.text,
           selectedEmoji != nil,
           selectedColor != nil {
            createButton.backgroundColor = .YPBlackDay
            loadViewIfNeeded()
        }
    }
    func convertWeekDaytoStringDay(weekDay: [WeekDay]) -> String {
        var arrayStringDay = [String]()
        if weekDay.count == 7 {
            return "Каждый день"
        } else {
            weekDay.forEach({day in
                switch day {
                case WeekDay.monday: arrayStringDay.append("Пн")
                case WeekDay.tuesday: arrayStringDay.append("Вт")
                case WeekDay.wednesday: arrayStringDay.append("Ср")
                case WeekDay.thursday: arrayStringDay.append("Чт")
                case WeekDay.friday: arrayStringDay.append("Пт")
                case WeekDay.saturday: arrayStringDay.append("Сб")
                case WeekDay.sunday: arrayStringDay.append("Вс")
                }
            })
            return arrayStringDay.joined(separator: ", ")
        }
    }
}

// MARK: Delegate For Main View

extension EditTrackerHabitViewController: CreateScheduleDelegate {
    func createScheduleTracker(schedule: [String]) {
        if schedule.count == 7 {
            visibleDay = "Каждый день"
        } else {
            visibleDay = schedule.joined(separator: ", ")
        }
        
        for i in schedule {
            switch i {
            case "Пн": finalSchedule.append(WeekDay.monday)
            case "Вт": finalSchedule.append(WeekDay.tuesday)
            case "Ср": finalSchedule.append(WeekDay.wednesday)
            case "Чт": finalSchedule.append(WeekDay.thursday)
            case "Пт": finalSchedule.append(WeekDay.friday)
            case "Сб": finalSchedule.append(WeekDay.saturday)
            case "Вс": finalSchedule.append(WeekDay.sunday)
            default: break
            }
        }
        
        tableForCreateHabit.reloadData()
        checkFields()
    }
}

extension EditTrackerHabitViewController: CreateCategoryDelegate {
    func createCategory(category: String) {
        self.category = category
        tableForCreateHabit.reloadData()
        checkFields()
    }
}

extension EditTrackerHabitViewController: UITextFieldDelegate {
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

// MARK: TableView

extension EditTrackerHabitViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if visibleDay.isEmpty && category.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.textLabel?.text = dataForTable[indexPath.row]
//            cell.backgroundColor = .YPBackgroundDay
//            cell.accessoryType = .disclosureIndicator
//            if indexPath.row == 0 {
//                cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//            } else {
//                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
//            }
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


extension EditTrackerHabitViewController: UITableViewDelegate {
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

// MARK: Collection View

extension EditTrackerHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionViewEmoji: return emodji.count
        case collectionViewColor: return colors.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionViewEmoji: if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? EmojiCell {
            cell.textLabel.text = emodji[indexPath.row]
            cell.textLabel.font = UIFont.systemFont(ofSize: 32)
            if emodji[indexPath.row] == selectedEmoji {
                indexPathEmojiCell = indexPath
                cell.backgroundColor = .YPLightGray
                cell.layer.cornerRadius = 16
            }
            return cell
        }
        case collectionViewColor: if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCell {
            cell.mainView.backgroundColor = colors[indexPath.row]
            if colorMarshaling.hexString(from: colors[indexPath.row]) == colorMarshaling.hexString(from: selectedColor!) {
                indexPathColorCell = indexPath
                cell.contentView.layer.borderWidth = 3
                cell.contentView.layer.borderColor = colors[indexPath.row].withAlphaComponent(0.3).cgColor
            }
            return cell
        }
        default: return UICollectionViewCell()
        }
        fatalError("Cell not found")
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch collectionView {
        case collectionViewEmoji: if let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerEmoji", for: indexPath) as? SupplementaryViewEmojiColor {
            view.titleLabel.text = "Emoji"
            view.titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
            return view
        }
        case collectionViewColor: if let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerColor", for: indexPath) as? SupplementaryViewEmojiColor {
            view.titleLabel.text = "Цвет"
            view.titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
            return view
        }
        default: break
        }
        fatalError("Cell not found")
    }
}

extension EditTrackerHabitViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collectionViewEmoji: guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell,
            let cellEmoji = collectionView.cellForItem(at: indexPathEmojiCell!) as? EmojiCell else { return }
            cell.backgroundColor = .YPLightGray
            cellEmoji.backgroundColor = .YPWhiteDay
            cell.layer.cornerRadius = 16
            selectedEmoji = cell.textLabel.text
            checkFields()
        case collectionViewColor: guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell,
                                        let cellColor = collectionView.cellForItem(at: indexPathColorCell!) as? ColorCell else { return }
            cell.contentView.layer.borderWidth = 3
            cellColor.contentView.layer.borderWidth = 0
            cell.contentView.layer.borderColor = cell.mainView.backgroundColor?.withAlphaComponent(0.3).cgColor
            selectedColor = cell.mainView.backgroundColor
            checkFields()
        default: print("---------------------\(indexPath.section)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collectionViewEmoji: guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            cell.backgroundColor = .YPWhiteDay
            cell.layer.cornerRadius = 16
        case collectionViewColor: guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else { return }
            cell.contentView.layer.borderWidth = 0
            cell.contentView.layer.borderColor = cell.contentView.backgroundColor?.cgColor
        default: print("---------------------\(indexPath.section)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case collectionViewEmoji: return CGSize(width: collectionView.frame.width / 6, height: 45)
        case collectionViewColor: return CGSize(width: 45, height: 45)
        default: break
        }
        fatalError("Section not found")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case collectionViewEmoji: return 0
        case collectionViewColor: return 17
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
