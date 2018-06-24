//
//  CoreDataManager.swift
//  Users
//
//  Created by Robert Oganiani on 6/23/18.
//  Copyright © 2018 Robert Oganiani. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserModels")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Store loading failed: \(err)")
            }
        }
        return container 
    }()
}
