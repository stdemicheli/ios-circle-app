//
//  AssessmentModelController.swift
//  care-app
//
//  Created by De MicheliStefano on 15.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

class AssessmentController {
    
    let baseURL: URL = Bundle.main.url(forResource: "RAIAssessment", withExtension: "json")!
    
    // MARK: - Networking
    
    func fetchAndSaveRAIAssessment_HC(completion: @escaping (Error?) -> Void) {
        
        let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
        backgroundContext.performAndWait {
            do {
                let data = try Data(contentsOf: self.baseURL)
                let encodedAssessments = try JSONDecoder().decode(AssessmentRepresentation.self, from: data)
                _ = Assessment(encodedAssessments)
                try backgroundContext.save()
                completion(nil)
            } catch {
                NSLog("Error decoding HC RAI Assessment: \(error)")
                completion(error)
            }
        }
    }
    
    // MARK: - Local
    
    func select(_ response: Response, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            response.isSelected = !response.isSelected
            
            do {
                try context.save()
            } catch {
                NSLog("Error saving response for response \(response): \(error)")
            }
        }
    }

}
