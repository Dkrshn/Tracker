//
//  CreateHabitCell.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 05.05.2023.
//

import UIKit

final class CreateHabitCell: UITableViewCell {
    let firstLabel = UILabel()
    let secondaryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: "cellCustom")
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(firstLabel)
        contentView.addSubview(secondaryLabel)
        
        firstLabel.font = UIFont.systemFont(ofSize: 17)
        firstLabel.textColor = .YPBlackDay
        
        secondaryLabel.font = UIFont.systemFont(ofSize: 17)
        secondaryLabel.textColor = .YPGray
        
        NSLayoutConstraint.activate([
            firstLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            firstLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            secondaryLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 2),
            secondaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
        
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
