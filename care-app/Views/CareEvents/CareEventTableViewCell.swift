//
//  CareEventTableViewCell.swift
//  care-app
//
//  Created by De MicheliStefano on 27.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class CareEventTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scheduledVisitLabel: UILabel!
    @IBOutlet weak var tasksLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    private func updateViews() {
        nameLabel?.text = event?.name
        if let date = event?.startDate {
            scheduledVisitLabel?.text = Utils().transformDateToString(date, with: "dd-MMM-yyyy")
        }
    }
    
}
