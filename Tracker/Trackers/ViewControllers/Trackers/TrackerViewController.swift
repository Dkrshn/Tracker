//
//  ViewController.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 20.04.2023.
//

import UIKit

protocol TrackerStatisticDelegate: AnyObject {
    func updateCountCompletedTracker()
}

class TrackerViewController: UIViewController {
    
    private let emptyImage = UIImageView()
    private let emptyLable = UILabel()
    private let addTraker = UIButton()
    private let header = UILabel()
    private let filterButton = UIButton()
    private let searchTextField  = TextField()
    private let datePicker = UIDatePicker()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var categories = [TrackerCategory]()
    private var visibleTrackerCategories = [TrackerCategory]()
    private let createHabit = CreateHabitViewController.shared
    private var currentDate: Date = Date()
    private let categoryStore = TrackerCategoryStore.shared
    private let recordStore = TrackerRecordStore.shared
    private var pinnedTrackerCategories = [TrackerCategory]()
    private let analyticsService = AnalyticsService.shared
    private let nameScreen = "Main"
    private let trackersText = NSLocalizedString("Header.main", comment: "Text main header")
    private let filterText = NSLocalizedString("filter", comment: "Text on button filter")
    
    private let trackerStore = TrackerStore.shared
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YY"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blackWhiteColor
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.sendOpenAppEvent(screen: nameScreen)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        analyticsService.sendCloseAppEvent(screen: nameScreen)
    }
}

extension TrackerViewController {
    func makeUI() {
        
        searchTextField.setUpTextFieldOnTrackerView()
        
        addTraker.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        addTraker.setImage(UIImage(systemName: "plus"), for: .normal)
        addTraker.sizeThatFits(CGSize(width: 19, height: 18))
        addTraker.tintColor = .blackWhiteColorButton
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_Ru")
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        datePicker.backgroundColor = .calendaraColor
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        datePicker.overrideUserInterfaceStyle = .light
        
        filterButton.layer.cornerRadius = 16
        filterButton.backgroundColor = .YPBlue
        filterButton.setTitle(filterText, for: .normal)
        filterButton.setTitleColor(.YPWhiteDay, for: .normal)
        filterButton.addTarget(self, action: #selector(openFilterMenu), for: .touchUpInside)
        
        
        
        if visibleTrackerCategories.isEmpty {
            let allUIElements = [emptyImage, emptyLable, header, searchTextField, datePicker, addTraker]
            allUIElements.forEach({view.addSubview($0)})
            allUIElements.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
            emptyImage.image = UIImage(named: "emptyTracker")
            
            emptyLable.text = "Что будем отслеживать?"
            emptyLable.font = UIFont.systemFont(ofSize: 12)
            emptyLable.tintColor = .YPBlackDay
            
            header.text = trackersText
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
            let allUIElements = [header, searchTextField, datePicker, collectionView, addTraker, filterButton]
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
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 50),
                filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
                filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                filterButton.widthAnchor.constraint(equalToConstant: 114),
                filterButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
}

extension TrackerViewController {
    @objc
    private func addTracker() {
        analyticsService.sendTapByAddTracker(screen: nameScreen, item: "add_track")
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
        
        categories = categories.filter { $0.nameCategory != "Закрепленные" }
        
        let allTrackers = categories.flatMap { $0.trackers }
        var pinnedTrackers = [Tracker]()
        var unpinnedCategories = [TrackerCategory]()
        
        for category in categories {
            let newTrackers = category.trackers.filter { tracker in
                if tracker.isPin {
                    pinnedTrackers.append(tracker)
                    return false
                } else {
                    return true
                }
            }
            let newCategory = TrackerCategory(nameCategory: category.nameCategory, trackers: newTrackers)
            unpinnedCategories.append(newCategory)
        }
        if !pinnedTrackers.isEmpty {
            let pinnedCategory = TrackerCategory(nameCategory: "Закрепленные", trackers: pinnedTrackers)
            unpinnedCategories.insert(pinnedCategory, at: 0)
        }
        
        visibleTrackerCategories = unpinnedCategories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                let dateCondotion = tracker.schedule?.contains { weekDay in
                    weekDay.rawValue == filterWeekDay
                } == true
                return textCondition && dateCondotion
            }
            if filteredTrackers.isEmpty {
                            return nil
                        }
                        return TrackerCategory(nameCategory: category.nameCategory, trackers: filteredTrackers)
        }
        
        makeUI()
        collectionView.reloadData()
    }
    private func installDateToCurrent() {
        currentDate = datePicker.date
    }
    
    @objc
    func openFilterMenu() {
        analyticsService.sendTapByFilter(screen: nameScreen, item: "filter")
        let menuVC = FilterMenu()
        present(menuVC, animated: true)
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
        cell.configTrackerCellButtonUI(tracker: tracker, isCompleted: isCompletedToday, indexPath: indexPath, countDay: countDay, isPin: tracker.isPin)
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
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let identifier = "\(indexPath.row):\(indexPath.section)" as NSString
        
        return UIContextMenuConfiguration(identifier: identifier ,actionProvider: { action in
            let deleteAction = UIAction(title: "Удалить") { [weak self] _ in
                guard let self = self else { return }
                self.analyticsService.sendTapByDeleteTracker(screen: self.nameScreen, item: "delete")
                self.toDelete(indexPath: indexPath)
            }
            
            let deleteAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red]
            let attributedTitle = NSAttributedString(string: "Удалить", attributes: deleteAttributes)
            deleteAction.setValue(attributedTitle, forKey: "attributedTitle")
            
            
            return UIMenu(children: [
                ((self.visibleTrackerCategories[indexPath.section].trackers[indexPath.row].isPin == true) ? UIAction(title: "Открепить") { [weak self] _ in
                    guard let self = self else { return }
                    self.unPin(indexPath: indexPath)
                    self.reloadVisibleCategories()
                } : UIAction(title: "Закрепить") { [weak self] _ in
                    guard let self = self else { return }
                    self.toPin(indexPath: indexPath)
                    self.reloadVisibleCategories()
                }),
                UIAction(title: "Редактировать") { [weak self] _ in
                    guard let self = self else { return }
                    self.analyticsService.sendTapByEditTracker(screen: self.nameScreen, item: "edit")
                    self.toEdit(indexPath: indexPath)
                },
                deleteAction
            ])
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let identifier = configuration.identifier as? String else { return nil }
        let components = identifier.components(separatedBy: ":")
        guard let rowString = components.first,
              let sectionString = components.last,
              let row = Int(rowString),
              let section = Int(sectionString) else { return nil}
        let indexPath = IndexPath(row: row, section: section)
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell else { return nil }
        return UITargetedPreview(view: cell.backView)
    }
    
    func toPin(indexPath: IndexPath) {
        try! trackerStore.makeFixTracker(id: visibleTrackerCategories[indexPath.section].trackers[indexPath.row].id)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut]) {
            guard let getCategories = try? self.categoryStore.readCategory() else { return }
            self.categories = getCategories
            self.collectionView.reloadData()
            self.reloadVisibleCategories()
        }
    }
    
    func unPin(indexPath: IndexPath) {
        let unpinTrackerId = visibleTrackerCategories[indexPath.section].trackers[indexPath.row].id
        try! trackerStore.makeUnpinTracker(id: unpinTrackerId)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut]) {
            guard let getCategories = try? self.categoryStore.readCategory() else { return }
            self.categories = getCategories
            self.collectionView.reloadData()
            self.reloadVisibleCategories()
        }
    }
    
    func toEdit(indexPath: IndexPath) {
        let tracker = visibleTrackerCategories[indexPath.section].trackers[indexPath.row]
        guard let record = try? recordStore.getRecord() else { return }
        let countDay = record.filter {$0.trackerId == tracker.id}.count
        let categoryName = visibleTrackerCategories[indexPath.section].nameCategory
        guard let schedule = tracker.schedule else { return }
        let editVC = EditTrackerHabitViewController(currentCategory: categoryName, currentName: tracker.name, currentSchedule: schedule, currentCountDay: countDay, currentEmoji: tracker.emoji, currentColor: tracker.color, id: tracker.id)
        present(editVC, animated: true)
    }
    
    func toDelete(indexPath: IndexPath) {
        let tracker = visibleTrackerCategories[indexPath.section].trackers[indexPath.row]
        let alert = UIAlertController(title: "Уверены, что хотите удалить трекер?", message: nil, preferredStyle: .actionSheet)
        let actionDelete = UIAlertAction(title: "Удалить", style: .destructive) {[weak self] _ in
            guard let self = self else { return }
            try! self.trackerStore.deleteTracker(id: tracker.id)
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
                guard let getCategories = try? self.categoryStore.readCategory() else { return }
                self.categories = getCategories
                self.reloadVisibleCategories()
            }
        }
        let actionCencel = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(actionDelete)
        alert.addAction(actionCencel)
        present(alert, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 124)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
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


