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
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func updateCategory(_ store: TrackerCategoryStore)
}

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
     
     static let shared = TrackerCategoryStore()
    weak var delegate: TrackerCategoryStoreDelegate?
     
     
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
         controller.delegate = self
         try? controller.performFetch()
     }
     
     func addNewCategory(_ trackerCategory: TrackerCategory) throws -> TrackerCategoryCoreData {
         let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
         trackerCategoryCoreData.nameCategory = trackerCategory.nameCategory
         trackerCategoryCoreData.tracker = NSSet(array: trackerCategory.trackers)
         try context.save()
         return trackerCategoryCoreData
     }
    
    func readCategory() throws -> [TrackerCategory] {
      //  try clearData()
        guard let categories = fetchedResultsController.fetchedObjects,
              let trackerCategory = try? categories.map({ try self.convertCategoryTracker(categoryCoreData: $0)})
        else { return [] }
        return trackerCategory
    }
    
   private func convertCategoryTracker(categoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let name = categoryCoreData.nameCategory else { throw
            TrackerCategoryError.decodingErrorInvalidName }
        guard let trackers = categoryCoreData.tracker as? [Tracker] else { throw
            TrackerCategoryError.decodingErrorInvalidTrackers
        }
        return TrackerCategory(nameCategory: name, trackers: trackers)
    }
    
    func clearData() throws {
        let request: NSFetchRequest<NSFetchRequestResult> = TrackerCategoryCoreData.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try context.execute(deleteRequest)
        try context.save()
    }
}


extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        insertedIndexes = IndexSet()
//        deletedIndexes = IndexSet()
//        updatedIndexes = IndexSet()
//        movedIndexes = Set<TrackerCategoryStoreUpdate.Move>()
//    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
   //     delegate?.updateCategory(self)
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

