//
//  CareCircleMember+Convenience.swift
//  care-app
//
//  Created by De MicheliStefano on 16.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

extension Member {
    
    convenience init(id: String = UUID().uuidString, name: String, city: String, type: String, avatar: Data? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.id = id
        self.name = name
        self.city = city
        self.type = type
        self.avatar = avatar
        
    }
    
}
