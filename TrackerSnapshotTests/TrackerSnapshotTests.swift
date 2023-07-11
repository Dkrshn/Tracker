//
//  TrackerSnapshotTests.swift
//  TrackerSnapshotTests
//
//  Created by Даниил Крашенинников on 07.07.2023.
//


import SnapshotTesting
@testable import Tracker
import XCTest

final class TrackerSnapshotTests: XCTestCase {
    
    
    func testViewControllerLight() {
        let vc = TrackerViewController()
        assertSnapshot(matching: vc, as: .image)
    }
    
    func testViewControllerDark() {
        let vc = TrackerViewController()
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
