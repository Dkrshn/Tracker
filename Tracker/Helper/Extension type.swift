//
//  Extension type.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 25.06.2023.
//

import Foundation

extension Dictionary where Value: Equatable {
    func firstKey(forValue value: Value) -> Key? {
        return first(where: { $0.value == value })?.key
    }
}
