//
//  AssessmentModelController.swift
//  care-app
//
//  Created by De MicheliStefano on 15.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

enum AssessmentType: String {
    case raiHC = "rai_hc"
}

class AssessmentController {
    
    let baseURL: URL = Bundle.main.url(forResource: "RAIAssessment", withExtension: "json")!
    var assessment: Assessment?
    
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - Public
    
    func fetchAssessment(for type: String, completion: @escaping (Error?) -> Void) {
        // Try to fetch the assessment from the local persistence store
        let moc = CoreDataStack.shared.mainContext
        moc.performAndWait {
            do {
                try self.fetchAssessmentFromPersistenceStore(for: type)
                completion(nil)
            } catch {
                NSLog("Error fetching assessment from local persistent store: \(error)")
                completion(error)
            }
        }
        
        // If local fetch falls through, then fetch the assessment from the server
        if let _ = self.assessment { return }
        
        let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
        // TODO: Implement a spinner. PerformAndWait will cause the UI to hang while it is fetching data.
        backgroundContext.performAndWait {
            do {
                try self.fetchAssessmentFromServer(for: type, context: backgroundContext)
                completion(nil)
            } catch {
                NSLog("Error fetching assessment from server: \(error)")
                completion(error)
            }
        }
    }
    
    func select(_ response: Response, in question: Question, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            // TODO: set question.status to incomplete if no response selected (e.g. when deselected)
            response.isSelected = !response.isSelected
            question.status = Question.StatusKeys.complete.rawValue
            checkIfCompletedAssessment()
            saveToPersistence(with: context)
        }
    }
    
    func selectUnique(_ response: Response, in question: Question, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            if let responses = question.responses {
                for item in responses {
                    guard let response = item as? Response else { continue }
                    response.isSelected = false
                }
            }
            response.isSelected = !response.isSelected
            question.status = Question.StatusKeys.complete.rawValue
            checkIfCompletedAssessment()
            saveToPersistence(with: context)
        }
    }
    
    func respond(with text: String, for response: Response, in question: Question, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            response.input = text
            question.status = Question.StatusKeys.complete.rawValue
            saveToPersistence(with: context)
        }
    }
    
    // MARK: - Networking
    
    private func fetchAssessmentFromServer(for type: String, context: NSManagedObjectContext) throws {
        var error: Error?
        // TODO: Hook up to server.
        context.performAndWait {
            do {
                let data = try Data(contentsOf: self.baseURL)
                let encodedAssessments = try JSONDecoder().decode(AssessmentRepresentation.self, from: data)
                self.assessment = Assessment(encodedAssessments)
                try context.save()
            } catch let fetchError {
                NSLog("Error decoding HC RAI Assessment: \(fetchError)")
                error = fetchError
            }
        }
        
        if let error = error { throw error }
    }
    
    // MARK: - Local persistance
    
    private func saveToPersistence(with context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        do {
            try context.save()
        } catch {
            NSLog("Error saving object to persistence: \(error)")
        }
    }
    
    private func fetchAssessmentFromPersistenceStore(for type: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        
        let fetchRequest: NSFetchRequest<Assessment> = Assessment.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "type", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "type == %@", type)
        
        context.performAndWait {
            do {
                self.assessment = try context.fetch(fetchRequest).first
            } catch let fetchError {
                NSLog("Error fetching assessment from persistence store: \(fetchError)")
                error = fetchError
            }
        }
        
        if let error = error { throw error }
    }
    
    // MARK: - Helper methods
    
    private func checkIfCompletedAssessment() {
        guard let assessment = self.assessment else {
            NSLog("Could not check if assessment completed. No assessment or questions found")
            return
        }
        
        if let questions = castedQuestions(for: assessment.questions ?? []),
            checkIfCompleted(questions) == true {
            assessment.status = Assessment.StatusKeys.complete.rawValue
        }
    }
    
    private func checkIfCompleted(_ questions: [Question]) -> Bool {
        for question in questions {
            if question.status != Question.StatusKeys.complete.rawValue {
                return false
            }
        }
        
        return true
    }
    
    private func castedQuestions(for set: NSOrderedSet) -> [Question]? {
        var questions = [Question]()
        for item in set {
            if let question = item as? Question {
                questions.append(question)
            }
        }
        
        return questions.count == 0 ? nil : questions
    }

}
