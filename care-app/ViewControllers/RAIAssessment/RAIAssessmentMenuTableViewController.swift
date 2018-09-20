//
//  RAIAssessmentMenuTableViewController.swift
//  care-app
//
//  Created by De MicheliStefano on 19.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class RAIAssessmentMenuTableViewController: UITableViewController {

    // MARK: - Properties
    
    let assessment: Assessment!
    var questions: [Question] {
        return assessment.questions!.compactMap { $0 as? Question }
    }
    var sections: [(String, [Question])] {
        return Dictionary(grouping: questions, by: { $0.sectionName ?? "" }).sorted { (prev, next) in
            if let sectionId1 = prev.1.first?.sectionId, let sectionId2 = next.1.first?.sectionId {
                return sectionId1 < sectionId2
            }
            return false
        }
    }
    
    private let reuseIdentifier = "QuestionCell"
    private var dismissButton: UIButton!
    
    // MARK: - Init
    
    init(assessment: Assessment) {
        self.assessment = assessment
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private methods
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: Include sections
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].1.count
        //return assessment.questions?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) else {
                return UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
            }
            return cell
        }()
        
        let question = sections[indexPath.section].1[indexPath.row]
        
        //let question = assessment.questions?[indexPath.row] as? Question
        
        cell.textLabel?.text = question.title
        cell.detailTextLabel?.text = question.subtitle
        cell.accessoryType = question.status == "complete" ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.disclosureIndicator
        cell.tintColor = question.status == "complete" ? UIColor.green : UIColor.red
        cell.textLabel?.textColor = question.status == "complete" ? UIColor.gray : UIColor.black
        cell.detailTextLabel?.textColor = question.status == "complete" ? UIColor.gray : UIColor.black
        
        return cell
    }
    
}
