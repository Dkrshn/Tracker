//
//  Storage.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 01.05.2023.
//

import UIKit

final class Storage {
    
    
    static let shared = Storage()
    private let uniqueId = UUID()
    var trackers: [Tracker] = []
    var storageTrakerCategory: [TrackerCategory] = []
    
    func addNewTracker(name: String, emoji: String, color: UIColor, schedule: [WeekDay], category: String) {
        
        if storageTrakerCategory.isEmpty {
            let newTracker = Tracker(id: uniqueId, name: name, emoji: emoji, color: color, schedule: schedule)
            trackers.append(newTracker)
            let newTrackerCategory = TrackerCategory(nameCategory: "Важное", trakers: trackers)
            storageTrakerCategory.append(newTrackerCategory)
        } else {
            storageTrakerCategory.removeLast()
            let newTracker = Tracker(id: uniqueId, name: name, emoji: emoji, color: color, schedule: schedule)
            trackers.append(newTracker)
            let newTrackerCategory = TrackerCategory(nameCategory: "Важное", trakers: trackers)
            storageTrakerCategory.append(newTrackerCategory)
        }
    }
}


