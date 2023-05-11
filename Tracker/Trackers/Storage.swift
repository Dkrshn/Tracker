//
//  Storage.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 01.05.2023.
//

import UIKit

final class Storage {
    
    
    static let shared = Storage()
    
 //   var trackers: [Tracker] = []
    var storageTrakerCategory: [TrackerCategory] = []
    
    func addNewTracker(name: String, emoji: String, color: UIColor, schedule: String, category: String) {
        let newTracker = Tracker(id: "\(storageTrakerCategory.count + 1)", name: name, emoji: emoji, color: color, schedule: [schedule])
        
        let newTrackerCategory = TrackerCategory(nameCategory: category, trakers: newTracker)
        storageTrakerCategory.append(newTrackerCategory)
    }
}


