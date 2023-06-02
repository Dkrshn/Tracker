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
   weak var delegate: TrackerStoreDelegate?
    
    
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
        controller.delegate = self
        try? controller.performFetch()
    }
    
    func addNewTracker(_ tracker: Tracker, with category: TrackerCategory) throws {
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
       try trackerStoreCategory.addNewCategory(category)
        try context.save()
   //     getTracker(tracker: trackerCoreData)
 //      try clearData()
    }
    
    func getTracker (tracker: TrackerCoreData) {
        guard let tracker = fetchedResultsController.fetchedObjects else { return }
    }
    
    func clearData() throws {
        let request: NSFetchRequest<NSFetchRequestResult> = TrackerCoreData.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try context.execute(deleteRequest)
        try context.save()
    }
   
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        insertedIndexes = IndexSet()
//        deletedIndexes = IndexSet()
//        updatedIndexes = IndexSet()
//        movedIndexes = Set<TrackerStoreUpdate.Move>()
//    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    //    delegate?.store(self)
//        insertedIndexes = nil
//        deletedIndexes = nil
//        updatedIndexes = nil
    }
    
//    func controller(
//        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
//        didChange anObject: Any,
//        at indexPath: IndexPath?,
//        for type: NSFetchedResultsChangeType,
//        newIndexPath: IndexPath?
//    ) {
//        switch type {
//        case .insert:
//            guard let indexPath = newIndexPath else { fatalError() }
//            insertedIndexes?.insert(indexPath.item)
//        case .delete:
//            guard let indexPath = indexPath else { fatalError() }
//            deletedIndexes?.insert(indexPath.item)
//        case .update:
//            guard let indexPath = indexPath else { fatalError() }
//            updatedIndexes?.insert(indexPath.item)
//        case .move:
//            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
//            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
//        @unknown default:
//            fatalError()
//        }
//    }
}

