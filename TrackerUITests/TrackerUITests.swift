//
//  TrackerUITests.swift
//  TrackerUITests
//
//  Created by Даниил Крашенинников on 03.07.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerUITests: XCTestCase {
    
    func testViewController() {
        let vc = TrackerViewController()
        assertSnapshot(matching: vc, as: .image)
    }
}
