//
//  DayCell.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 05.05.2023.
//

import UIKit

final class DayCell: UITableViewCell {
    let switchView = UISwitch(frame: .zero)
    var days = [String]()
    weak var delegate: WeekdayCellDelegate?
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cellSchedule")
        switchView.onTintColor = .YPBlue
        accessoryView = switchView
        switchView.addTarget(self, action: #selector(didToggleSwitchView), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func printSwitch(dayIsChoose: Bool) {
        if dayIsChoose {
            switchView.isOn = true
        }
    }
    
    @objc
    func didToggleSwitchView(_ sender: UISwitch) {
        if sender.isOn {
            delegate?.didToggleSwitchView(to: sender.isOn, day: (textLabel?.text)!)
        } else {
            delegate?.didToggleSwitchView(to: sender.isOn, day: (textLabel?.text)!)
        }
    }
}
