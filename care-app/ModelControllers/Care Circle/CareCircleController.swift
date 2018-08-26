//
//  CareRecipientController.swift
//  care-app
//
//  Created by De MicheliStefano on 28.07.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

class CareCircleController {
    
    // MARK: - Properties
    enum CareCircleMemberTypes: String, CaseIterable {
        case CareRecipient = "Care Recipient"
        case CareGiver = "Care Giver"
    }
    
    let careCircleMemberTypes = CareCircleMemberTypes.allCases
    
    // MARK: - Methods
    
    func addMemberWith(name: String, city: String, type: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            let _ = Member(name: name, city: city, type: type)
            
            do {
                try CoreDataStack.shared.save()
            } catch {
                NSLog("Error adding member: \(error)")
            }
        }
    }
    
    func remove(member: Member, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        context.performAndWait {
            context.delete(member)
            
            do {
                try context.save()
            } catch {
                NSLog("Error removing member: \(error)")
            }
        }
    }
    
}
