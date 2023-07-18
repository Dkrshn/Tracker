//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 24.04.2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    let storage = Storage.shared
    private let statisticText = NSLocalizedString("statistic", comment: "Name view with statistics")
    private let trackersText = NSLocalizedString("Header.main", comment: "Name view with trackers")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tabBar.backgroundColor = .blackWhiteColorTabBar
        let trackerViewController = TrackerViewController()
        trackerViewController.tabBarItem = UITabBarItem(title: trackersText, image: UIImage(named: "barItemTracker"), selectedImage: nil)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: statisticText, image: UIImage(named: "barItemStatistics"), selectedImage: nil)
        
        self.viewControllers = [trackerViewController, statisticsViewController]
    }
}
