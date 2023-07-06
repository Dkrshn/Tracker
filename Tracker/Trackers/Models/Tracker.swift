//
//  Tracker.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 30.04.2023.
//

import UIKit

struct Tracker: Equatable {
    let id: UUID
    let name: String
    let emoji: String
    let color: UIColor
    let schedule: [WeekDay]?
    let oldCategory: String?
    let isPin: Bool
}
