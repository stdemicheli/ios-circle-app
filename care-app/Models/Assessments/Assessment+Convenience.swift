//
//  Assessment+Convenience.swift
//  care-app
//
//  Created by De MicheliStefano on 12.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import CoreData

extension Assessment {
    
    convenience init(id: String, name: String, type: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.name = name
        self.type = type
    }
    
    convenience init?(assessmentRepresentation: AssessmentRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(id: assessmentRepresentation.id,
                  name: assessmentRepresentation.name,
                  type: assessmentRepresentation.type,
                  context: context)
    }
    
}

extension Question {
    
    convenience init(id: String,
                     sectionId: String,
                     sectionName: String,
                     number: String,
                     title: String,
                     subtitle: String,
                     descript: String,
                     responseType: String,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.sectionId = sectionId
        self.sectionName = sectionName
        self.number = number
        self.title = title
        self.subtitle = subtitle
        self.descript = descript
        self.responseType = responseType
    }
    
    convenience init?(questionRepresentation: QuestionRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(id: String(questionRepresentation.id),
                  sectionId: questionRepresentation.sectionId,
                  sectionName: questionRepresentation.sectionName,
                  number: questionRepresentation.number,
                  title: questionRepresentation.title,
                  subtitle: questionRepresentation.subtitle,
                  descript: questionRepresentation.descript,
                  responseType: questionRepresentation.responseType,
                  context: context)
    }
    
}

extension Response {
    
    convenience init(id: String, title: String, descript: String, checked: Bool, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.title = title
        self.descript = descript
        self.checked = checked
    }
    
    convenience init?(responseRepresentation: ResponseRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(id: String(responseRepresentation.id),
                  title: responseRepresentation.title,
                  descript: responseRepresentation.descript,
                  checked: responseRepresentation.checked,
                  context: context)
    }
    
}
