//
//  Event.swift
//  care-app
//
//  Created by De MicheliStefano on 28.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

extension Event {
    
    convenience init(id: String = UUID().uuidString, name: String, description: String, startDate: Date, endDate: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.id = id
        self.name = name
        self.descr = description
        self.startDate = startDate
        self.endDate = endDate
        self.sectionId = Utils().transformDateToString(startDate)
        
    }
    
}
