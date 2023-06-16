//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 12.06.2023.
//

import Foundation

@objcMembers
final class CategoryViewModel: NSObject {
    
    
    dynamic private(set) var savedCategory: [String] = []
    
    private let model = TrackerCategoryStore.shared
    
    func readAndSaveCategory() {
        guard let savedTrackersCategory = try? model.readCategory() else { return }
        for i in savedTrackersCategory {
            savedCategory.append(i.nameCategory)
        }
    }
    
    
    func checkSavedCategory() -> Bool {
        return savedCategory.isEmpty
    }
    
    func addCategory(_ category: String) {
        savedCategory.append(category)
    }
    
}
