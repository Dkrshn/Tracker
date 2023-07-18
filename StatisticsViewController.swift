//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 24.04.2023.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    private var countCompletedTrackers: Int?
    private let trackerRecord = TrackerRecordStore.shared
    private let statisticText = NSLocalizedString("statistic", comment: "Main header on this view")
    
    private lazy var header: UILabel = {
        let header = UILabel()
        header.text = statisticText
        header.font = UIFont.boldSystemFont(ofSize: 34)
        header.textColor = .YPBlackDay
        return header
    }()
    
    private lazy var emptyImage: UIImageView = {
        let emptyImage = UIImageView()
        emptyImage.image = UIImage(named: "emptyAnalytics")
        return emptyImage
    }()
    
    private lazy var emptyLabel: UILabel = {
        let header = UILabel()
        header.text = "Анализировать пока нечего"
        header.font = UIFont.systemFont(ofSize: 12)
        header.textColor = .YPBlackDay
        return header
    }()
    
    private lazy var viewForStatistic: UIView = {
        let viewForStatistic = UIView()
        viewForStatistic.layer.cornerRadius = 16
        return viewForStatistic
    }()
    
    private lazy var countTrack: UILabel = {
        let countTrack = UILabel()
        countTrack.font = UIFont.boldSystemFont(ofSize: 34)
        countTrack.textColor = .YPBlackDay
        return countTrack
    }()
    
    private lazy var labelCompleted: UILabel = {
        let labelCompleted = UILabel()
        labelCompleted.text = "Трекеров завершено"
        labelCompleted.font = UIFont.systemFont(ofSize: 12)
        labelCompleted.textColor = .YPBlackDay
        return labelCompleted
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPWhiteDay
        updateCountCompletedTracker()
        trackerRecord.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewForStatistic.setGradientBorder(width: 1, colors: [.ypGradient01, .ypGradient02, .ypGradient03])
    }
}

extension StatisticsViewController {
    func emptyUI() {
        emptyImage.isHidden = false
        emptyLabel.isHidden = false
        viewForStatistic.isHidden = true
        labelCompleted.isHidden = true
        countTrack.isHidden = true
        let allUIElements = [header, emptyLabel, emptyImage]
        allUIElements.forEach({view.addSubview($0)})
        allUIElements.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 331),
            emptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 8),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func statisticUI() {
        viewForStatistic.isHidden = false
        labelCompleted.isHidden = false
        countTrack.isHidden = false
        emptyLabel.isHidden = true
        emptyImage.isHidden = true
        let allUIElementsOnSubView = [countTrack, labelCompleted]
        allUIElementsOnSubView.forEach({view.addSubview($0)})
        allUIElementsOnSubView.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        let allUIElements = [header, viewForStatistic]
        allUIElements.forEach({view.addSubview($0)})
        allUIElements.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewForStatistic.topAnchor.constraint(equalTo: header.topAnchor, constant: 77),
            viewForStatistic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewForStatistic.widthAnchor.constraint(equalToConstant: 343),
            viewForStatistic.heightAnchor.constraint(equalToConstant: 90),
            countTrack.topAnchor.constraint(equalTo: viewForStatistic.topAnchor, constant: 12),
            countTrack.leadingAnchor.constraint(equalTo: viewForStatistic.leadingAnchor, constant: 12),
            labelCompleted.topAnchor.constraint(equalTo: countTrack.bottomAnchor, constant: 7),
            labelCompleted.leadingAnchor.constraint(equalTo: viewForStatistic.leadingAnchor, constant: 12)
        ])
    }
}


extension StatisticsViewController: TrackerRecordDelegate {
    func updateCountCompletedTracker() {
        guard let trackerCompleted = try? trackerRecord.getRecord() else { return }
        countCompletedTrackers = trackerCompleted.count
        countTrack.text = "\(trackerCompleted.count)"
        if countCompletedTrackers == 0 {
            emptyUI()
        } else {
            statisticUI()
        }
    }
}


