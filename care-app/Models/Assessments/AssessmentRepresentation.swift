//
//  AssessmentRepresentation.swift
//  care-app
//
//  Created by De MicheliStefano on 12.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

struct AssessmentRepresentation: Codable {
    
    var id: String
    var name: String
    var type: String
    var questions: [QuestionRepresentation]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case questions
    }
    
}

struct QuestionRepresentation: Codable {
    
    var id: Int
    var sectionId: String
    var sectionName: String
    var number: String
    var title: String
    var subtitle: String
    var descript: String
    var responseType: String
    var responses: [ResponseRepresentation]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case sectionId
        case sectionName
        case number
        case title
        case subtitle
        case descript = "description"
        case responseType
        case responses
    }
    
}

struct ResponseRepresentation: Codable {
    
    var id: Int
    var title: String
    var descript: String
    var checked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case descript = "description"
        case checked
    }
    
}
