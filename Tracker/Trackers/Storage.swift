//
//  Storage.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 01.05.2023.
//

import Foundation

final class Storage {
    
    static let shared = Storage()
    
    var trackers: [Tracker] = []
    
}
