//
//  CoreDataService.swift
//  Sleeping Baby
//

import CoreData

final class CoreDataService {
    
    // MARK: Private Properties
    
    lazy private var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Sleeping_Baby")
        
        container.loadPersistentStores(
            completionHandler: { _, error in
                if let error = error as NSError? {
                    Logger.shared.log(error)
                    return
                }
            }
        )
        
        return container
    }()
    
    private var readingContext: NSManagedObjectContext {
        container.viewContext
    }
    
    private var writingContext: NSManagedObjectContext {
        container.newBackgroundContext()
    }
    
    // MARK: Life Cycle
    
    static let shared = CoreDataService()
    
    private init() { }
    
    // MARK: Public Functions
    
    func addObject<Type: NSManagedObject>(
        ofType type: Type.Type,
        completion: @escaping (Type) -> Void
    ) {
        let object = Type(context: readingContext)
        completion(object)
        
        saveContextIfNeeded()
    }
    
    func edit(completion: () -> Void) {
        completion()
        saveContextIfNeeded()
    }
    
    func remove<Type: NSManagedObject>(object: Type, completion: () -> Void) {
        readingContext.delete(object)
        saveContextIfNeeded()
        
        completion()
    }
    
    func receive<Type: NSManagedObject>(
        objectsOfType type: Type.Type,
        completion: @escaping ([Type]) -> Void
    ) {
        let entityName = String(describing: type)
        let fetchRequest = NSFetchRequest<Type>(entityName: entityName)
        
        do {
            let objects = try readingContext.fetch(fetchRequest)
            completion(objects)
        } catch let error {
            Logger.shared.log(error as NSError)
        }
    }


    // MARK: Private Functions

    private func saveContextIfNeeded() {
        if writingContext.hasChanges {
            writingContext.perform { [weak self] in
                do {
                    try self?.writingContext.save()
                } catch {
                    Logger.shared.log(error as NSError)
                }
            }
        }
    }
    
}
