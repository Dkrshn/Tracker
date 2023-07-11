//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 30.05.2023.
//

import UIKit
import CoreData

enum TrackerRecordError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidDate
    case decodingErrorInvalidRecord
}

final class TrackerRecordStore: NSObject {
    
    private let colorAndDayMarshalling = ColorAndDayMarshalling.shared
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!
    static let DidChangeNotification = Notification.Name("TrackerRecord")
    
    static let shared = TrackerRecordStore()
    
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController = controller
        try? controller.performFetch()
    }
    
    func addNewRecord(_ id: UUID, date: Date) throws {
        let record = TrackerRecordCoreData(context: context)
        record.trackerId = id
        record.date = date
        try context.save()
        try updateResult()
        NotificationCenter.default.post(name: TrackerRecordStore.DidChangeNotification, object: self)
    }
    
    func getRecord() throws -> [TrackerRecord] {
        guard let recordCoreData = fetchedResultsController.fetchedObjects,
              let record = try? recordCoreData.map({ try self.convertRecord(recordCoreData: $0)})
        else { throw TrackerRecordError.decodingErrorInvalidRecord  }
        return record
    }
    
    private func convertRecord(recordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = recordCoreData.trackerId else { throw
            TrackerRecordError.decodingErrorInvalidId }
        guard let date = recordCoreData.date else { throw
            TrackerRecordError.decodingErrorInvalidDate
        }
        return TrackerRecord(trackerId: id, date: date)
    }
    
    func getRecordAtID(id: UUID) throws -> TrackerRecord {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: " %K == %@", #keyPath(TrackerRecordCoreData.trackerId), id as CVarArg)
        guard let record = try? context.fetch(request).first else { throw TrackerRecordError.decodingErrorInvalidRecord }
        return TrackerRecord(trackerId: record.trackerId!, date: record.date!)
    }
    
    func deleteRecord(_ id: UUID) throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: " %K == %@", #keyPath(TrackerRecordCoreData.trackerId), id as CVarArg)
        guard let record = try? context.fetch(request).first else { return }
        context.delete(record)
        try? context.save()
        try updateResult()
        NotificationCenter.default.post(name: TrackerRecordStore.DidChangeNotification, object: self)
    }
    
    func updateResult() throws {
        try fetchedResultsController.performFetch()
    }
    
    func clearData() throws {
        let request: NSFetchRequest<NSFetchRequestResult> = TrackerRecordCoreData.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try context.execute(deleteRequest)
        try context.save()
    }
}
