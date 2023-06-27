//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 30.05.2023.
//

import Foundation
import CoreData
import UIKit


enum TrackerCategoryError: Error {
    case decodingErrorInvalidName
    case decodingErrorInvalidTrackers
    case decodingErrorCategoryData
}

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    private let colorAndDayMarshalling = ColorAndDayMarshalling.shared
    
    static let shared = TrackerCategoryStore()
    
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nameCategory", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController = controller
        try? controller.performFetch()
    }
    
    func getCategoryCoreData(_ categoryName: String) throws -> [TrackerCategoryCoreData] {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: " %K == %@", #keyPath(TrackerCategoryCoreData.nameCategory), categoryName)
        let category = try context.fetch(request)
        return category
    }
    
    func readCategory() throws -> [TrackerCategory] {
        guard let categories = fetchedResultsController.fetchedObjects,
              let trackerCategory = try? categories.map({ try self.convertCategoryTracker(categoryCoreData: $0)})
        else { return [] }
        return trackerCategory
    }
    
     func convertCategoryTracker(categoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let name = categoryCoreData.nameCategory else { throw
            TrackerCategoryError.decodingErrorInvalidName }
        guard let trackers = categoryCoreData.tracker?.allObjects as? [TrackerCoreData] else { throw
            TrackerCategoryError.decodingErrorInvalidTrackers
        }
        return TrackerCategory(nameCategory: name, trackers: convertToTrackers(trackerCoreData: trackers))
    }
    
    func convertToTrackers(trackerCoreData: [TrackerCoreData]) -> [Tracker] {
        var trackers = [Tracker]()
        trackerCoreData.forEach { tracker in
            guard let trackerID = tracker.id else { return }
            guard let trackerName = tracker.name else { return }
            guard let trackerEmoji = tracker.emoji else { return }
            guard let trackerColor = tracker.color else { return }
            guard let trackerSchedule = tracker.schedule else { return }
            trackers.append(Tracker(id: trackerID, name: trackerName, emoji: trackerEmoji, color: colorAndDayMarshalling.color(from: trackerColor), schedule: colorAndDayMarshalling.day(from: trackerSchedule)))
        }
        return trackers
    }
    
    func updateResult() throws {
        try fetchedResultsController.performFetch()
    }
    
    func clearData() throws {
        let request: NSFetchRequest<NSFetchRequestResult> = TrackerCategoryCoreData.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try context.execute(deleteRequest)
        try context.save()
    }
}

