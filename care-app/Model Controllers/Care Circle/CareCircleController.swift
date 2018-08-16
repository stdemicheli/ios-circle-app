//
//  CareRecipientController.swift
//  care-app
//
//  Created by De MicheliStefano on 28.07.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

class CareCircleController {
    
    // MARK: - Properties
    enum CareCircleMemberTypes: String, CaseIterable {
        case CareRecipient = "Care Recipient"
        case CareGiver = "Care Giver"
    }
    
    let careCircleMemberTypes = CareCircleMemberTypes.allCases
    
    // MARK: - Methods
    
    func addMemberWith(name: String, city: String, type: String) {
        let _ = CareCircleMember(name: name, city: city, type: type)
        saveToPersistentStore()
    }
    
    func remove(member: CareCircleMember) throws {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(member)
        do {
            try moc.save()
        } catch {
            NSLog("Error deleting member from persistence: \(error)")
        }
    }
    
    private func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            NSLog("Error saving data from persistence store: \(error)")
        }
    }
    
}
