//
//  TrackerCell.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 30.04.2023.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(id: UUID, indexPath: IndexPath)
    func uncompleteTracker(id: UUID, indexPath: IndexPath)
}

final class TrackerCell: UICollectionViewCell {
    let name = UILabel()
    let emoji = UILabel()
    let backView = UIView()
    let daytext = UILabel()
    let buttonPlus = UIButton()
    private var isCompletedToday: Bool = false
    private var idTracker: UUID?
    private var indexPath: IndexPath?
    private let analyticsService = AnalyticsService.shared
    
    private lazy var pinImage: UIImageView = {
        let pinImageView = UIImageView()
        pinImageView.image = UIImage(named: "pin")
        return pinImageView
    }()
    
    weak var delegate: TrackerCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let allElementsOnView = [backView ,name, emoji, daytext, buttonPlus]
        allElementsOnView.forEach({contentView.addSubview($0)})
        allElementsOnView.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        backView.addSubview(name)
        backView.addSubview(emoji)
        
        
        backView.layer.cornerRadius = 16
        name.font = UIFont.systemFont(ofSize: 12)
        name.textColor = .YPWhiteDay
        emoji.font = UIFont.systemFont(ofSize: 16)
        daytext.font = UIFont.systemFont(ofSize: 12)
        
        buttonPlus.addTarget(self, action: #selector(completedTracker), for: .touchUpInside)
        buttonPlus.setImage(UIImage(systemName: "plus"), for: .normal)
        buttonPlus.imageView?.tintColor = .YPWhiteDay
        buttonPlus.layer.cornerRadius = 17
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -34),
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 44),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            name.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -46),
            emoji.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            emoji.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            daytext.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 16),
            daytext.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            buttonPlus.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 8),
            buttonPlus.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            buttonPlus.widthAnchor.constraint(equalToConstant: 34),
            buttonPlus.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    func configTrackerCellButtonUI(tracker: Tracker, isCompleted: Bool, indexPath: IndexPath, countDay: Int, isPin: Bool) {
        let daysText = String.localizedStringWithFormat(NSLocalizedString("numberOfDay", comment: ""), countDay)
        self.isCompletedToday = isCompleted
        idTracker = tracker.id
        self.indexPath = indexPath
        daytext.text = "\(countDay) \(daysText)"
        if isCompletedToday {
            buttonPlus.setImage(UIImage(systemName: "checkmark"), for: .normal)
            buttonPlus.alpha = 0.3
        } else {
            buttonPlus.setImage(UIImage(systemName: "plus"), for: .normal)
            buttonPlus.imageView?.tintColor = .YPWhiteDay
            buttonPlus.alpha = 1
        }
        if isPin {
            backView.addSubview(pinImage)
            pinImage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                pinImage.topAnchor.constraint(equalTo: backView.topAnchor, constant: 18),
                pinImage.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -12)
            ])
        } else {
            pinImage.removeFromSuperview()
        }
    }
    
    
    @objc
    func completedTracker() {
        analyticsService.sendTapByTrack(screen: "Main", item: "Track")
        guard let idTracker = idTracker, let indexPath = indexPath else { return }
        if isCompletedToday {
            delegate?.uncompleteTracker(id: idTracker, indexPath: indexPath)
        } else {
            delegate?.completeTracker(id: idTracker, indexPath: indexPath)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
