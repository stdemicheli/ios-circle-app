//
//  Assessment+Convenience.swift
//  care-app
//
//  Created by De MicheliStefano on 12.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import CoreData

extension Assessment {
    
    enum StatusKeys: String {
        case open
        case complete
        case inProgress
    }
    
    convenience init(id: String, name: String, type: String, status: String = Assessment.StatusKeys.inProgress.rawValue, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.name = name
        self.type = type
        // TODO: Evaluate if it status should be set to "inProgress" upon initialization
        self.status = status
    }
    
    convenience init?(_ assessmentRepresentation: AssessmentRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(id: assessmentRepresentation.id,
                  name: assessmentRepresentation.name,
                  type: assessmentRepresentation.type,
                  context: context)
        
        for questionRep in assessmentRepresentation.questions {
            if let question = Question(questionRep) {
                self.addToQuestions(question)
            }
        }
    }
    
}

extension Question {
    
    enum StatusKeys: String {
        case open
        case complete
        case inProgress
    }
    
    convenience init(id: String,
                     sectionId: String,
                     sectionName: String,
                     number: String,
                     title: String,
                     subtitle: String,
                     descript: String,
                     responseType: String,
                     status: String = StatusKeys.open.rawValue,
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
        self.status = status
    }
    
    convenience init?(_ questionRepresentation: QuestionRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(id: String(questionRepresentation.id),
                  sectionId: questionRepresentation.sectionId,
                  sectionName: questionRepresentation.sectionName,
                  number: questionRepresentation.number,
                  title: questionRepresentation.title,
                  subtitle: questionRepresentation.subtitle,
                  descript: questionRepresentation.descript,
                  responseType: questionRepresentation.responseType,
                  context: context)
        
        if let responseReps = questionRepresentation.responses {
            for responseRep in responseReps {
                if let response = Response(responseRep) {
                    self.addToResponses(response)
                }
            }
        }
    }
    
}

extension Response {
    
    convenience init(id: String, title: String, descript: String, isSelected: Bool?, input: String?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.title = title
        self.descript = descript
        self.isSelected = isSelected ?? false
        self.input = input ?? nil
    }
    
    convenience init?(_ responseRepresentation: ResponseRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(id: String(responseRepresentation.id),
                  title: responseRepresentation.title,
                  descript: responseRepresentation.descript,
                  isSelected: responseRepresentation.isSelected,
                  input: responseRepresentation.input,
                  context: context)
    }
    
}
