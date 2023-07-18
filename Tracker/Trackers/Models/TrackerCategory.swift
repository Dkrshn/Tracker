//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 04.05.2023.
//

import Foundation

struct TrackerCategory: Equatable {
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        true
    }
    
    let nameCategory: String
    let trackers: [Tracker]
}
