//
//  RAIAssessmentMenuViewController.swift
//  care-app
//
//  Created by De MicheliStefano on 20.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class RAIAssessmentMenuViewController: UIViewController {

    // MARK: - Properties
    
    var delegate: RAIHCCollectionViewController?
    var questions: [Question]!
    
    var sections: [(String, [Question])] {
        // Group questions by sectionName in a dict: [sectionName : [Question]]
        return Dictionary(grouping: questions, by: { $0.sectionName ?? "" }).sorted { (prev, next) in
            // Sort by sectionId by taking first instance of a question and then compare prev and next
            if let sectionId1 = prev.1.first?.sectionId, let sectionId2 = next.1.first?.sectionId {
                return sectionId1 < sectionId2
            }
            return false
        }
    }
    
    private let reuseIdentifier = "QuestionCell"
    
    private var questionsTableView: UITableView!
    private var headerView: UIView!
    private var menuButton: UIButton!
    private var headerTitle: UILabel!
    private var dismissButton: UIButton!
    
    // MARK: - Init
    
    init(questions: [Question]) {
        self.questions = questions
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeaderView()
        setupQuestionsTableView()
    }
    
    // MARK: - Delegate methods
    
    @objc func dismissMenu() {
        delegate?.dismiss()
    }
    
    func goToQuestion(with id: String) {
        delegate?.goToCell(with: id)
    }

    // MARK: - Views
    
    func setupHeaderView() {
        
        // Interface for modalHeader
        // title name, dismiss button right (incl. completion block), optional button left (incl. completion block)
        
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        let headerConstraints: [NSLayoutConstraint] = [
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0 / 8.0),
            ]
        NSLayoutConstraint.activate(headerConstraints)
        
        headerView.backgroundColor = .blue
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        headerView.addSubview(stackView)
        
        menuButton = UIButton(type: .system)
        headerTitle = UILabel()
        dismissButton = UIButton(type: .system)
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(menuButton)
        stackView.addArrangedSubview(headerTitle)
        stackView.addArrangedSubview(dismissButton)
        
        let stackViewConstraints: [NSLayoutConstraint] = [
            stackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 30),
            stackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            ]
        NSLayoutConstraint.activate(stackViewConstraints)
        
        menuButton.setTitle("Menu", for: .normal)
        menuButton.backgroundColor = .purple
        // menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        
        headerTitle.numberOfLines = 1
        headerTitle.textAlignment = .center
        headerTitle.text = "Overview"
        headerTitle.backgroundColor = .green
        
        dismissButton.setTitle("Close", for: .normal)
        dismissButton.backgroundColor = .gray
        dismissButton.addTarget(self, action: #selector(dismissMenu), for: .touchUpInside)
        
    }
    
    private func setupQuestionsTableView() {
        questionsTableView = UITableView()
        questionsTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(questionsTableView)
        
        let constraints: [NSLayoutConstraint] = [
            questionsTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            questionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            questionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            questionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        questionsTableView.delegate = self
        questionsTableView.dataSource = self
    }
    
}

extension RAIAssessmentMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) else {
                return UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
            }
            return cell
        }()
        
        let question = sections[indexPath.section].1[indexPath.row]
        
        cell.textLabel?.text = question.title
        cell.detailTextLabel?.text = question.subtitle
        cell.accessoryType = question.status == "complete" ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.disclosureIndicator
        cell.tintColor = question.status == "complete" ? UIColor.green : UIColor.red
        cell.textLabel?.textColor = question.status == "complete" ? UIColor.gray : UIColor.black
        cell.detailTextLabel?.textColor = question.status == "complete" ? UIColor.gray : UIColor.black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let question = sections[indexPath.section].1[indexPath.row]
        if let id = question.id {
            goToQuestion(with: id)
        }
    }
    
}
