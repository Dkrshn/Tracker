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
    private let addTraker = UIButton()
    private let header = UILabel()
    private let searchTextField  = TextField()
    private let datePicker = UIDatePicker()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var categories = [TrackerCategory]()
    private var visibleTrackerCategories = [TrackerCategory]()
    private let createHabit = CreateHabitViewController.shared
    private var currentDate: Date = Date()
    private let categoryStore = TrackerCategoryStore.shared
    private let recordStore = TrackerRecordStore.shared
    
    
    private let trackerStore = TrackerStore.shared
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YY"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPWhiteDay
        guard let getCategories = try? categoryStore.readCategory() else { return }
        categories = getCategories
        reloadVisibleCategories()
        collectionView.register(SupplementaryViewCategory.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        makeUI()
        searchTextField.delegate = self
        
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "cellCollection")
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
}

extension TrackerViewController {
    func makeUI() {
        
        searchTextField.setUpTextFieldOnTrackerView()
        
        addTraker.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        addTraker.setImage(UIImage(systemName: "plus"), for: .normal)
        addTraker.sizeThatFits(CGSize(width: 19, height: 18))
        addTraker.tintColor = .YPBlackDay
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_Ru")
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
        
        if visibleTrackerCategories.isEmpty {
            let allUIElements = [emptyImage, emptyLable, header, searchTextField, datePicker, addTraker]
            allUIElements.forEach({view.addSubview($0)})
            allUIElements.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
            emptyImage.image = UIImage(named: "emptyTracker")
            
            emptyLable.text = "Что будем отслеживать?"
            emptyLable.font = UIFont.systemFont(ofSize: 12)
            emptyLable.tintColor = .YPBlackDay
            
            header.text = "Трекеры"
            header.font = UIFont.boldSystemFont(ofSize: 34)
            header.tintColor = .YPBlackDay
            
            NSLayoutConstraint.activate([
                addTraker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
                addTraker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
                emptyImage.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 366),
                emptyImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                emptyLable.centerXAnchor.constraint(equalTo: emptyImage.centerXAnchor),
                emptyLable.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 8),
                header.leadingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                header.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
                datePicker.bottomAnchor.constraint(equalTo: searchTextField.topAnchor, constant: -11),
                datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                searchTextField.leadingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                searchTextField.topAnchor.constraint(lessThanOrEqualTo: header.bottomAnchor, constant: 7),
                searchTextField.heightAnchor.constraint(equalToConstant: 36),
                searchTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 16*2)
            ])
        } else {
            let allUIElements = [header, searchTextField, datePicker, collectionView, addTraker]
            allUIElements.forEach({view.addSubview($0)})
            allUIElements.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
            
            header.text = "Трекеры"
            header.font = UIFont.boldSystemFont(ofSize: 34)
            header.tintColor = .YPBlackDay
            
            NSLayoutConstraint.activate([
                addTraker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
                addTraker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
                header.leadingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                header.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
                datePicker.bottomAnchor.constraint(equalTo: searchTextField.topAnchor, constant: -11),
                datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                searchTextField.leadingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                searchTextField.topAnchor.constraint(lessThanOrEqualTo: header.bottomAnchor, constant: 7),
                searchTextField.heightAnchor.constraint(equalToConstant: 36),
                searchTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 16*2),
                collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 34),
                collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 50)
            ])
        }
    }
}

extension TrackerViewController {
    @objc
    private func addTracker() {
        let createTracker = CreateTrackerViewController()
        present(createTracker, animated: true)
    }
    
    @objc
    private func dateChange() {
        reloadVisibleCategories()
        
    }
    
    private func reloadVisibleCategories() {
        let calendar = Calendar.current
        installDateToCurrent()
        let filterWeekDay = calendar.component(.weekday, from: currentDate)
        let filterText = (searchTextField.text ?? "").lowercased()
        visibleTrackerCategories = categories.compactMap { category in
            let tracker = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                let dateCondotion = tracker.schedule?.contains { weekDay in
                    weekDay.rawValue == filterWeekDay
                } == true
                return textCondition && dateCondotion
            }
            if tracker.isEmpty {
                return nil
            }
            return TrackerCategory(nameCategory: category.nameCategory, trackers: tracker)
        }
        makeUI()
        collectionView.reloadData()
        
    }
    private func installDateToCurrent() {
        currentDate = datePicker.date
    }
}

extension TrackerViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reloadVisibleCategories()
        return true
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleTrackerCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if visibleTrackerCategories.isEmpty {
            return 0
        } else {
            return visibleTrackerCategories[section].trackers.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollection", for: indexPath) as? TrackerCell else { return UICollectionViewCell() }
        let tracker = visibleTrackerCategories[indexPath.section].trackers[indexPath.row]
        let isCompletedToday = isCompletedTrackerToday(id: tracker.id)
        guard let record = try? recordStore.getRecord() else { return UICollectionViewCell() }
        let countDay = record.filter {$0.trackerId == tracker.id}.count
        cell.configTrackerCellButtonUI(tracker: tracker, isCompleted: isCompletedToday, indexPath: indexPath, countDay: countDay)
        cell.delegate = self
        cell.name.text = "\(visibleTrackerCategories[indexPath.section].trackers[indexPath.row].name)"
        cell.emoji.text = "\(visibleTrackerCategories[indexPath.section].trackers[indexPath.row].emoji)"
        cell.backView.backgroundColor = visibleTrackerCategories[indexPath.section].trackers[indexPath.row].color
        cell.buttonPlus.backgroundColor = visibleTrackerCategories[indexPath.section].trackers[indexPath.row].color
        return cell
    }
    
    private func isCompletedTrackerToday(id: UUID) -> Bool {
        guard let records = try? recordStore.getRecord() else { return false }
        return records.contains { trackerRecord in
            installDateToCurrent()
            let sameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: currentDate)
            return trackerRecord.trackerId == id && sameDay
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id = "header"
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SupplementaryViewCategory
        if !visibleTrackerCategories.isEmpty {
            view?.titleLabel.text = "\(visibleTrackerCategories[indexPath.section].nameCategory)"
            
        }
        return view!
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 124)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
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

extension TrackerViewController: TrackerCellDelegate {
    func completeTracker(id: UUID, indexPath: IndexPath) {
        installDateToCurrent()
        let calendar = Calendar.current
        let toDay = calendar.dateComponents([.year, .month, .day], from: Date())
        let dateOnCalendar = calendar.dateComponents([.year, .month, .day], from: currentDate)
        if let extractedToDay = calendar.date(from: toDay),
           let extractedCurrentDate = calendar.date(from: dateOnCalendar) {
            if extractedCurrentDate <= extractedToDay {
                let trackerRecord = TrackerRecord(trackerId: id, date: currentDate)
                try? recordStore.addNewRecord(id, date: currentDate)
                collectionView.reloadItems(at: [indexPath])
            }
        }
    }
    
    func uncompleteTracker(id: UUID, indexPath: IndexPath) {
        installDateToCurrent()
        guard let record = try? recordStore.getRecordAtID(id: id) else { return }
        let sameDay = Calendar.current.isDate(record.date, inSameDayAs: currentDate)
        if sameDay {
            try? recordStore.deleteRecord(id)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}


