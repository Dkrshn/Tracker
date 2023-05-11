//
//  EmojiCell.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 05.05.2023.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    let textLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
       
       NSLayoutConstraint.activate([
        textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
