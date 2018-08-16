//
//  CoreDataStack.swift
//  care-app
//
//  Created by De MicheliStefano on 16.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CareCircle")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("\(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}
