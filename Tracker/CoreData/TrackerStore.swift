//
//  TrackerStore.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 30.05.2023.
//

import CoreData
import UIKit


final class TrackerStore: NSObject {
    private let colorAndDayMarshalling = ColorAndDayMarshalling.shared
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    private let trackerStoreCategory = TrackerCategoryStore.shared
    
    static let shared = TrackerStore()
    
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController = controller
        try? controller.performFetch()
    }
    
    func addNewTracker(_ tracker: Tracker, with category: TrackerCategory) throws {
        let savedCategories = try trackerStoreCategory.getCategoryCoreData(category.nameCategory)
        if !savedCategories.isEmpty {
            guard let category = savedCategories.first else { return }
            let newTracker = TrackerCoreData(context: context)
            newTracker.name = tracker.name
            newTracker.emoji = tracker.emoji
            newTracker.id = tracker.id
            newTracker.color = colorAndDayMarshalling.hexString(from: tracker.color)
            newTracker.schedule = colorAndDayMarshalling.dayString(from: tracker.schedule!)
            category.addToTracker(newTracker)
            try context.save()
        } else {
            let trackerCoreData = TrackerCoreData(context: context)
            let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
            trackerCoreData.name = tracker.name
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.id = tracker.id
            trackerCoreData.color = colorAndDayMarshalling.hexString(from: tracker.color)
            trackerCoreData.schedule = colorAndDayMarshalling.dayString(from: tracker.schedule!)
            trackerCategoryCoreData.nameCategory = category.nameCategory
            trackerCategoryCoreData.tracker = NSSet(object: trackerCoreData)
            trackerCoreData.trackerCategory = trackerCategoryCoreData
            try context.save()
            try updateResult()
            try trackerStoreCategory.updateResult()
        }
    }
    
    func updateResult() throws {
        try fetchedResultsController.performFetch()
    }
    
    func clearData() throws {
        let request: NSFetchRequest<NSFetchRequestResult> = TrackerCoreData.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try context.execute(deleteRequest)
        try context.save()
    }
}


