//
//  TrackerCell.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 30.04.2023.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    let name = UILabel()
    let emoji = UILabel()
    let backView = UIView()
    let daytext = UILabel()
    let buttonPlus = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let allElementsOnView = [backView ,name, emoji, daytext, buttonPlus]
        allElementsOnView.forEach({contentView.addSubview($0)})
        allElementsOnView.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})

        backView.layer.cornerRadius = 16
        name.font = UIFont.systemFont(ofSize: 12)
        name.textColor = .YPWhiteDay
        emoji.font = UIFont.systemFont(ofSize: 16)
        daytext.font = UIFont.systemFont(ofSize: 12)
        daytext.text = "0 дней"
        
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
    
    @objc
    func completedTracker() {
      //  plusImage.image = UIImage(named: "done")
        buttonPlus.setImage(UIImage(named: "done"), for: .normal)
        buttonPlus.alpha = 0.3
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
