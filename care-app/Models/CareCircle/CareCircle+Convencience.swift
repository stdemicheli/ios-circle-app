//
//  CareCircle+Convencience.swift
//  care-app
//
//  Created by De MicheliStefano on 16.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

extension CareCircle {
    
    convenience init(id: String = UUID().uuidString, name: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.id = id
        self.name = name
        
    }
    
}

