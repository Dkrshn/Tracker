//
//  Storage.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 01.05.2023.
//

import UIKit

final class Storage {
    
    
    static let shared = Storage()
    var trackers: [Tracker] = []
    var storageTrakerCategory: [TrackerCategory] = []
    private let trackerStore = TrackerStore.shared
    
    func addNewTracker(name: String, emoji: String, color: UIColor, schedule: [WeekDay], category: String) {
        
        let uniqueId = UUID()
        let newTracker = Tracker(id: uniqueId, name: name, emoji: emoji, color: color, schedule: schedule)
        trackers.append(newTracker)
        let newTrackerCategory = TrackerCategory(nameCategory: "Важное", trackers: trackers)
        try! trackerStore.addNewTracker(newTracker, with: newTrackerCategory)
    }
}


