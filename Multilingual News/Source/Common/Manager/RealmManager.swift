//
//  RealmManager.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/23.
//

import Foundation
import RealmSwift

let realmObject = try! Realm()

class RealmManager: NSObject {
    
    static let shared = RealmManager()
    
    func retrievePredicatedDataForObject(_ T : Object.Type, with criteria: NSPredicate) -> [Object] {
        
        var objects = [Object]()
        for result in realmObject.objects(T).filter(criteria) {
            objects.append(result)
        }
        return objects
    }
    
    func retrieveAllDataForObject(_ T : Object.Type) -> [Object] {
        
        var objects = [Object]()
        for result in realmObject.objects(T) {
            objects.append(result)
        }
        return objects
    }
    
    func deleteAllDataForObject(_ T : Object.Type) {
        
        self.delete(self.retrieveAllDataForObject(T))
    }
    
    func replaceAllDataForObject(_ T : Object.Type, with objects : [Object]) {
        
        deleteAllDataForObject(T)
        add(objects)
    }
    
    func add(_ object : Object) {
        
        try! realmObject.write {
            
            realmObject.add(object)
        }
    }
    
    func add(_ objects : [Object], completion : @escaping() -> Void) {
        
        try! realmObject.write {
            
            realmObject.add(objects)
            completion()
        }
    }
    
    func add(_ objects : [Object]) {
        
        try! realmObject.write {
            
            realmObject.add(objects)
        }
    }
    
    func update(_ block: @escaping () -> Void) {
        
        try! realmObject.write(block)
    }
    
    func delete(_ objects : [Object]) {
        
        try! realmObject.write {
            realmObject.delete(objects)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
