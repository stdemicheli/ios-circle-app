//
//  RAIAssessmentCollectionViewCell.swift
//  care-app
//
//  Created by De MicheliStefano on 12.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol RAIAssessmentCollectionViewCellDelegate {
    func openMenu()
    func dismiss()
    func next()
    func previous()
    func goToCell(with id: String)
    func select(_ response: Response, in cell: RAIAssessmentCollectionViewCell)
    func selectUnique(_ response: Response, in cell: RAIAssessmentCollectionViewCell)
    func respond(with input: String, for response: Response, in cell: RAIAssessmentCollectionViewCell)
}

class RAIAssessmentCollectionViewCell: UICollectionViewCell {
    
    // - MARK: - Properties
    
    var question: Question? {
        didSet {
            setupViews()
        }
    }
    
    var totalQuestionsCount: Int? {
        didSet {
            setupFooterView()
        }
    }
    
    var currentQuestionIndex: Int? {
        didSet {
            setupFooterView()
        }
    }
    
    var responses: NSOrderedSet? {
        return question?.responses
    }
    
    var delegate: RAIAssessmentCollectionViewCellDelegate?
    
    private var questionView: UIView!
    private var questionTitleTextLabel: UILabel!
    private var questionSubtitleTextLabel: UILabel!
    private var questionDescriptionTextLabel: UILabel!
    
    private var responseView: UIView!
    var responseTableView: UITableView!
    private var responseReuseIdentifier = "ResponseCell"
    
    private var datePicker: UIDatePicker!
    
    private var footerView: UIView!
    private var nextButton: UIButton!
    private var prevButton: UIButton!
    private var progressTextLabel: UILabel!
    
    private var headerView: UIView!
    private var menuButton: UIButton!
    private var headerTitle: UILabel!
    private var dismissButton: UIButton!
    
    // - MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - MARK: - Delegate methods
    
    @objc func openMenu() {
        delegate?.openMenu()
    }
    
    @objc func dismiss() {
        delegate?.dismiss()
    }
    
    @objc func nextQ() {
        delegate?.next()
    }
    
    @objc func previousQ() {
        delegate?.previous()
    }
    
    func selectResponse(with response: Response) {
        delegate?.select(response, in: self)
    }
    
    func selectUniqueResponse(with response: Response) {
        delegate?.selectUnique(response, in: self)
    }
    
    @objc func respond(sender: UIDatePicker) {
        let timestampString = String(sender.date.timeIntervalSinceReferenceDate)
        guard let question = question, let response = question.responses?.firstObject as? Response else { return }
        
        delegate?.respond(with: timestampString, for: response, in: self)
    }
    
    // - MARK: - Private methods
    
    private func setupViews() {
        setupHeaderView()
        setupFooterView()
        setupBodyView()
        
        switch question?.responseType {
        case "date":
            setupDatePickerResponseView()
        case "open":
            guard let responses = Array(question?.responses ?? []) as? [Response] else { fallthrough }
            for response in responses {
                if let title = response.title {
                    setupOpenResponseView(with: title)
                }
            }
        default:
            setupTableViewResponseView()
        }
    }
    
    private func setupBodyView() {
        questionView = UIView()
        let questionStackView = UIStackView()
        questionTitleTextLabel = UILabel()
        questionSubtitleTextLabel = UILabel()
        questionDescriptionTextLabel = UILabel()
        
        responseView = UIView()
        
        questionView.translatesAutoresizingMaskIntoConstraints = false
        questionStackView.translatesAutoresizingMaskIntoConstraints = false
        questionTitleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        questionSubtitleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        questionDescriptionTextLabel.translatesAutoresizingMaskIntoConstraints = false
        responseView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(questionView)
        questionView.addSubview(questionStackView)
        questionStackView.addArrangedSubview(questionTitleTextLabel)
        questionStackView.addArrangedSubview(questionSubtitleTextLabel)
        questionStackView.addArrangedSubview(questionDescriptionTextLabel)
        contentView.addSubview(responseView)
        
        let constraints: [NSLayoutConstraint] = [
            questionView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
            questionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15),
            questionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            questionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            responseView.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 15),
            responseView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -15),
            responseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            responseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            questionStackView.topAnchor.constraint(equalTo: questionView.topAnchor, constant: 8),
            questionStackView.leadingAnchor.constraint(equalTo: questionView.leadingAnchor, constant: 8),
            questionStackView.trailingAnchor.constraint(equalTo: questionView.trailingAnchor, constant: -8),
            questionStackView.bottomAnchor.constraint(equalTo: questionView.bottomAnchor, constant: -8),
            ]
        NSLayoutConstraint.activate(constraints)
        
        questionView.backgroundColor = .white
        
        questionStackView.axis = .vertical
        questionStackView.distribution = .fillProportionally
        questionStackView.alignment = .center
        
        questionTitleTextLabel.text = question?.title
        questionTitleTextLabel.textAlignment = .center
        questionTitleTextLabel.numberOfLines = 0
        questionTitleTextLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        questionSubtitleTextLabel.text = question?.subtitle
        questionSubtitleTextLabel.textAlignment = .center
        questionSubtitleTextLabel.numberOfLines = 0
        questionSubtitleTextLabel.font = UIFont.systemFont(ofSize: 16.0)
        
        questionDescriptionTextLabel.text = question?.descript
        questionDescriptionTextLabel.textAlignment = .center
        questionDescriptionTextLabel.numberOfLines = 0
        questionDescriptionTextLabel.font = UIFont.systemFont(ofSize: 14.0)
        
        responseView.backgroundColor = .white
        
    }
    
    private func setupTableViewResponseView() {
        
        responseTableView = UITableView()
        responseTableView.translatesAutoresizingMaskIntoConstraints = false
        responseView.addSubview(responseTableView)
        
        let constraints: [NSLayoutConstraint] = [
            responseTableView.topAnchor.constraint(equalTo: responseView.topAnchor, constant: 8),
            responseTableView.leadingAnchor.constraint(equalTo: responseView.leadingAnchor, constant: 8),
            responseTableView.trailingAnchor.constraint(equalTo: responseView.trailingAnchor, constant: -8),
            responseTableView.bottomAnchor.constraint(equalTo: responseView.bottomAnchor, constant: -8),
            ]
        NSLayoutConstraint.activate(constraints)
        
        responseTableView.register(ResponseTableViewCell.self, forCellReuseIdentifier: responseReuseIdentifier)
        responseTableView.delegate = self
        responseTableView.dataSource = self
        responseTableView.isScrollEnabled = false
        responseTableView.tableFooterView = UIView(frame: .zero) // Covers unused rows with an empty view
        
    }
    
    private func setupDatePickerResponseView() {
        datePicker = UIDatePicker()
        let responseTitleLabel = UILabel()
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        responseTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        responseView.addSubview(datePicker)
        datePicker.addSubview(responseTitleLabel)
        
        let constraints: [NSLayoutConstraint] = [
            datePicker.topAnchor.constraint(equalTo: responseView.topAnchor, constant: 8),
            datePicker.leadingAnchor.constraint(equalTo: responseView.leadingAnchor, constant: 8),
            datePicker.trailingAnchor.constraint(equalTo: responseView.trailingAnchor, constant: -8),
            datePicker.bottomAnchor.constraint(equalTo: responseView.bottomAnchor, constant: -8),
            responseTitleLabel.topAnchor.constraint(equalTo: datePicker.topAnchor, constant: 8),
            responseTitleLabel.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor, constant: 8),
            responseTitleLabel.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor, constant: -8),
            ]
        NSLayoutConstraint.activate(constraints)
        
        let response = question?.responses?.firstObject as? Response
        
        datePicker.addTarget(self, action: #selector(respond(sender:)), for: .valueChanged)
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        if let savedDateString = response?.input {
            guard let savedDateDouble = Double(savedDateString),
                let timeInterval = TimeInterval(exactly: savedDateDouble) else { return }
            let savedDate = Date(timeIntervalSinceReferenceDate: timeInterval)
            datePicker.setDate(savedDate, animated: true)
        }
        
        responseTitleLabel.text = response?.title
        responseTitleLabel.textAlignment = .center
        responseTitleLabel.numberOfLines = 0
        responseTitleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
    }
    
    private func setupOpenResponseView(with title: String) {
        let responseTextView = UITextView()
        let responseTitleLabel = UILabel()
        
        responseTextView.translatesAutoresizingMaskIntoConstraints = false
        responseTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        responseView.addSubview(responseTextView)
        responseView.addSubview(responseTitleLabel)
        
        let constraints: [NSLayoutConstraint] = [
            responseTextView.topAnchor.constraint(equalTo: responseTitleLabel.bottomAnchor, constant: 16),
            responseTextView.leadingAnchor.constraint(equalTo: responseView.leadingAnchor, constant: 16),
            responseTextView.trailingAnchor.constraint(equalTo: responseView.trailingAnchor, constant: -16),
            responseTextView.bottomAnchor.constraint(equalTo: responseView.bottomAnchor, constant: -16),
            responseTitleLabel.topAnchor.constraint(equalTo: responseView.topAnchor, constant: 8),
            responseTitleLabel.leadingAnchor.constraint(equalTo: responseView.leadingAnchor, constant: 8),
            responseTitleLabel.trailingAnchor.constraint(equalTo: responseView.trailingAnchor, constant: -8),
            ]
        NSLayoutConstraint.activate(constraints)
        
        responseTextView.delegate = self
        responseTextView.layer.borderWidth = 2.0
        responseTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        responseTextView.layer.cornerRadius = 5
        responseTextView.clipsToBounds = true
        responseTextView.font = UIFont.systemFont(ofSize: 16.0)
        responseTextView.returnKeyType = .done
        
        responseTitleLabel.text = title
        responseTitleLabel.textAlignment = .center
        responseTitleLabel.numberOfLines = 0
        responseTitleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
    }
    
    private func setupHeaderView() {
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerView)
        
        let headerConstraints: [NSLayoutConstraint] = [
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1.0 / 8.0),
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
        menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        
        headerTitle.numberOfLines = 1
        headerTitle.textAlignment = .center
        headerTitle.text = question?.sectionName
        headerTitle.backgroundColor = .green
        
        dismissButton.setTitle("Close", for: .normal)
        dismissButton.backgroundColor = .gray
        dismissButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
    }
    
    private func setupFooterView() {
        footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(footerView)
        
        let footerConstraints: [NSLayoutConstraint] = [
            footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            footerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1.0 / 10.0),
            ]
        NSLayoutConstraint.activate(footerConstraints)
        
        footerView.backgroundColor = .blue
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        footerView.addSubview(stackView)
        
        nextButton = UIButton(type: .system)
        prevButton = UIButton(type: .system)
        progressTextLabel = UILabel()
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        progressTextLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(prevButton)
        stackView.addArrangedSubview(progressTextLabel)
        stackView.addArrangedSubview(nextButton)
        
        let stackViewConstraints: [NSLayoutConstraint] = [
            stackView.topAnchor.constraint(equalTo: footerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20),
            ]
        NSLayoutConstraint.activate(stackViewConstraints)
        
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.backgroundColor = .purple
        nextButton.addTarget(self, action: #selector(nextQ), for: .touchUpInside)
        
        prevButton.setTitle("PREV", for: .normal)
        prevButton.backgroundColor = .gray
        prevButton.addTarget(self, action: #selector(previousQ), for: .touchUpInside)
        
        if let totalQuestionsCount = totalQuestionsCount, let currentQuestionIndex = currentQuestionIndex {
            progressTextLabel.text = "\(currentQuestionIndex) of \(totalQuestionsCount)"
        }
        progressTextLabel.backgroundColor = .green
        
    }
    
}

extension RAIAssessmentCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: responseReuseIdentifier, for: indexPath) as! ResponseTableViewCell
        
        let response = responses?[indexPath.row] as? Response
        cell.response = response
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let response = responses?[indexPath.row] as? Response, let question = self.question {
            if question.responseType == "multi-option" {
                selectResponse(with: response)
            } else if question.responseType == "ordinal-scale" || question.responseType == "boolean" {
                selectUniqueResponse(with: response)
            } else {
                selectResponse(with: response)
            }
        }
    }
    
}

extension RAIAssessmentCollectionViewCell: UITextViewDelegate {
    
    // TODO: Build out if a open text view response option is included in assessment
    func textViewDidEndEditing(_ textView: UITextView) {
        print("ended with: \(String(describing: textView.text))")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            
        }
        return true
    }
    
    
}
