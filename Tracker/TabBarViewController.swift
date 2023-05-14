//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 24.04.2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    let storage = Storage.shared
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let trackerViewController = TrackerViewController()
        trackerViewController.tabBarItem = UITabBarItem(title: "Трекер", image: UIImage(named: "barItemTracker"), selectedImage: nil)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "barItemStatistics"), selectedImage: nil)
        
        self.viewControllers = [trackerViewController, statisticsViewController]
    }
}
