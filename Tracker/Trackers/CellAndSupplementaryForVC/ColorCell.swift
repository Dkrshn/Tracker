//
//  ColorCell.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 30.05.2023.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    let mainView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.layer.cornerRadius = 8
        mainView.layer.cornerRadius = 8
        contentView.backgroundColor = .YPWhiteDay
        
        NSLayoutConstraint.activate([
            mainView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mainView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mainView.heightAnchor.constraint(equalToConstant: 35),
            mainView.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
