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
    
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - Public
    
    func fetchAssessment(for type: AssessmentType, completion: @escaping (Error?) -> Void) {
        let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
        
        // TODO: Implement a spinner. PerformAndWait will cause the UI to hang while it is fetching data.
        backgroundContext.performAndWait {
            do {
                try self.fetchAssessmentFromServer(for: type, context: backgroundContext)
                completion(nil)
            } catch {
                NSLog("Error decoding HC RAI Assessment: \(error)")
                completion(error)
            }
        }
    }
    
    // MARK: - Networking
    
    private func fetchAssessmentFromServer(for type: AssessmentType, context: NSManagedObjectContext) throws {
        var error: Error?
        // TODO: Hook up to server.
        context.performAndWait {
            do {
                let data = try Data(contentsOf: self.baseURL)
                let encodedAssessments = try JSONDecoder().decode(AssessmentRepresentation.self, from: data)
                _ = Assessment(encodedAssessments)
                try context.save()
            } catch let fetchError {
                NSLog("Error decoding HC RAI Assessment: \(fetchError)")
                error = fetchError
            }
        }
        
        if let error = error { throw error }
    }
    
    // MARK: - Local
    
    func select(_ response: Response, in question: Question, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            question.status = Question.StatusKeys.complete.rawValue
            response.isSelected = !response.isSelected
            
            do {
                try context.save()
            } catch {
                NSLog("Error saving response for response \(response): \(error)")
            }
        }
    }
    
    private func fetchAssessmentFromPersistenceStore(for type: AssessmentType, context: NSManagedObjectContext) -> Assessment? {
        var assessment: Assessment? = nil
        
        let fetchRequest: NSFetchRequest<Assessment> = Assessment.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "type", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "type == %@", "rai_hc")
        let moc = CoreDataStack.shared.mainContext
        
        do {
            assessment = try moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching assessment from persistence store: \(error)")
        }
        
        return assessment
    }

}
