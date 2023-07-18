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
            newTracker.isPin = tracker.isPin
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
            trackerCoreData.isPin = tracker.isPin
            trackerCategoryCoreData.nameCategory = category.nameCategory
            trackerCoreData.trackerCategory = trackerCategoryCoreData
            trackerCategoryCoreData.tracker = NSSet(object: trackerCoreData)
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
    
    func deleteTracker(id: UUID) throws {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let trackers = try context.fetch(request)
        if let traker = trackers.first {
            context.delete(traker)
            try context.save()
        }
    }
    
    func makeFixTracker(id: UUID) throws {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let trackers = try context.fetch(request)
        if let tracker = trackers.first {
            tracker.oldCategory = tracker.trackerCategory?.nameCategory
            tracker.isPin = true
            try context.save()
            try updateResult()
        }
    }
    
    func makeUnpinTracker(id: UUID) throws {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let trackers = try context.fetch(request)
        if let tracker = trackers.first {
            tracker.isPin = false
            try context.save()
            try updateResult()
        }
    }
    
    func updateTracker(id: UUID, name: String, category: String, schedule: [WeekDay], emoji: String, color: UIColor) throws {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let trackers = try context.fetch(request)
        if let tracker = trackers.first {
            tracker.name = name
            tracker.schedule = colorAndDayMarshalling.dayString(from: schedule)
            tracker.emoji = emoji
            tracker.color = colorAndDayMarshalling.hexString(from: color)
            tracker.trackerCategory?.nameCategory = category
            try context.save()
            try updateResult()
        }
    }
}


