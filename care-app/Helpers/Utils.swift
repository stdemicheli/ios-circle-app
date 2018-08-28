//
//  Utils.swift
//  care-app
//
//  Created by De MicheliStefano on 28.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

struct Utils {
    
    func transformDateToDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    func transformDateToString(_ date: Date, with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
}
