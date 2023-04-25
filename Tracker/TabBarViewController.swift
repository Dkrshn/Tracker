//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 24.04.2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //let storyboard = UIStoryboard(name: "TabBar", bundle: .main)

        let navigationController = UINavigationController(rootViewController: TrackerViewController())
       // let trackerViewController = TrackerViewController()
        
        navigationController.tabBarItem = UITabBarItem(title: "Трекер", image: UIImage(named: "barItemTracker"), selectedImage: nil)
        
        let statisticsViewController = StatisticsViewController()
        
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "barItemStatistics"), selectedImage: nil)
        
        self.viewControllers = [navigationController, statisticsViewController]
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        let storyboard = UIStoryboard(name: "TabBar", bundle: .main)
//        
//        let trackerViewController = storyboard.instantiateViewController(withIdentifier: "TrackerViewController")
//        
//        trackerViewController.tabBarItem = UITabBarItem(title: "Трекер", image: UIImage(named: "barItemTracker"), selectedImage: nil)
//        
//        let statisticsViewController = storyboard.instantiateViewController(withIdentifier: "StatisticsViewController")
//        
//        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "barItemStatistics"), selectedImage: nil)
//        
//        self.viewControllers = [trackerViewController, statisticsViewController]
//        view.backgroundColor = .YPWhiteDay
//    }
    
}
