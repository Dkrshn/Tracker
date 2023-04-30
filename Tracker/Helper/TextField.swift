//
//  TextField.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 30.04.2023.
//

import UIKit

final class TextField: UISearchTextField {
    
    func setUpTextField() {
        layer.cornerRadius = 10
        layer.backgroundColor = UIColor.YPBackgroundDay.cgColor
        textColor = .YPBlackDay
        clearButtonMode = .whileEditing
        placeholder = "Поиск"
        font = UIFont.systemFont(ofSize: 17)
    }
}
