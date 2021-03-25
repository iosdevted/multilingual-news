//
//  PersistenceManager.swift
//  one-article
//
//  Created by Ted on 2021/03/24.
//

import UIKit
import CoreData

class PersistenceManager {
    
    static var shared: PersistenceManager = PersistenceManager()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Setting")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    

//    func fetchbyNewBackground<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
//        let context: NSManagedObjectContext = self.persistentContainer.newBackgroundContext()
//        do {
//            let fetchResult = try context.fetch(request)
//            return fetchResult
//        } catch {
//            print(error.localizedDescription)
//            return []
//        }
//    }
    
    
//    @discardableResult
//    func insertLanguagebyNewBackground(language: Setting) -> Bool {
//        let context: NSManagedObjectContext = self.persistentContainer.newBackgroundContext()
//        let entity = NSEntityDescription.entity(forEntityName: "Languages", in: context)
//        if let entity = entity {
//            let managedObject = NSManagedObject(entity: entity, insertInto: context)
//            managedObject.setValue(language.isChecked, forKey: "isChecked")
//            managedObject.setValue(language.title, forKey: "title")
//            managedObject.setValue(language.code, forKey: "code")
//            managedObject.setValue(language.icon, forKey: "icon")
//
//            do {
//                try context.save()
//                return true
//            } catch {
//                print(error.localizedDescription)
//                return false
//            }
//        } else {
//            return false
//        }
//    }
    
    
    @discardableResult
    func insertLanguage(language: Setting) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "Languages", in: self.context)
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
            managedObject.setValue(language.isChecked, forKey: "isChecked")
            managedObject.setValue(language.title, forKey: "title")
            managedObject.setValue(language.code, forKey: "code")
            managedObject.setValue(language.icon, forKey: "icon")
            
            do {
                try self.context.save()
                return true
            } catch {
                print(error)
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }
    
    
//    func update<T: NSManagedObject>(request: NSFetchRequest<T>, languages: [Languages]) -> [T] {
//        request.predicate = NSPredicate(format: "title = "%@", "English")
//
//        do {
//            let fetchResult = try self.context.fetch(request)
//            return fetchResult
//        } catch {
//            print(error.localizedDescription)
//            return []
//        }
//    }
    
    @discardableResult
    func save(language: Setting) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "Languages", in: self.context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
            managedObject.setValue(language.isChecked, forKey: "isChecked")
            managedObject.setValue(language.title, forKey: "title")
            managedObject.setValue(language.code, forKey: "code")
            managedObject.setValue(language.icon, forKey: "icon")
            
            do {
                try self.context.save()
                return true
            } catch {
                print(error)
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }
    
    //    @discardableResult
    //    func saveLanguagesSetting(languages: [Languages]) -> Bool {
    //        let context: NSManagedObjectContext = self.persistentContainer.newBackgroundContext()
    //        let entity = NSEntityDescription.entity(forEntityName: "Languages", in: context)
    //
    //        if let entity = entity {
    //            let managedObject = NSManagedObject(entity: entity, insertInto: context)
    //
    //            languages.forEach { language in
    //
    //                managedObject.setValue(language.isChecked, forKey: "isChecked")
    //                managedObject.setValue(language.title, forKey: "title")
    //                managedObject.setValue(language.code, forKey: "code")
    //                managedObject.setValue(language.icon, forKey: "icon")
    //            }
    //
    //            do {
    //                try context.save()
    //                print(languages)
    //                return true
    //            } catch {
    //                print(error.localizedDescription)
    //                return false
    //            }
    //        } else {
    //            return false
    //        }
    //    }
    
    @discardableResult
    func delete(object: NSManagedObject) -> Bool {
        self.context.delete(object)
        
        do{
            try self.context.save()
            return true
        } catch {
            return false
        }
    }
    
    func count<T: NSManagedObject>(request: NSFetchRequest<T>) -> Int? {
        do {
            let count = try self.context.count(for: request)
            return count
        } catch {
            return nil
        }
    }
    
    @discardableResult
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try self.context.execute(delete)
            try self.context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}
