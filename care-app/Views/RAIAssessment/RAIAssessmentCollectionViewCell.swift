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
    
    private var answerView: UIView!
    
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
    
    // - MARK: - Private methods
    
    func setupViews() {
        setupHeaderView()
        setupFooterView()
        setupBodyView()
    }
    
    func setupBodyView() {
        questionView = UIView()
        let questionStackView = UIStackView()
        questionTitleTextLabel = UILabel()
        questionSubtitleTextLabel = UILabel()
        answerView = UIView()
        let answerStackView = UIStackView()
        
        
        questionView.translatesAutoresizingMaskIntoConstraints = false
        questionStackView.translatesAutoresizingMaskIntoConstraints = false
        questionTitleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        questionSubtitleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        answerView.translatesAutoresizingMaskIntoConstraints = false
        answerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(questionView)
        questionView.addSubview(questionStackView)
        questionStackView.addArrangedSubview(questionTitleTextLabel)
        questionStackView.addArrangedSubview(questionSubtitleTextLabel)
        contentView.addSubview(answerView)
        answerView.addSubview(answerStackView)
        
        let constraints: [NSLayoutConstraint] = [
            questionView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
            questionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            questionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            questionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            answerView.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 20),
            answerView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -20),
            answerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            answerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            questionStackView.topAnchor.constraint(equalTo: questionView.topAnchor, constant: 8),
            questionStackView.leadingAnchor.constraint(equalTo: questionView.leadingAnchor, constant: 8),
            questionStackView.trailingAnchor.constraint(equalTo: questionView.trailingAnchor, constant: -8),
            questionStackView.bottomAnchor.constraint(equalTo: questionView.bottomAnchor, constant: -8),
            answerStackView.topAnchor.constraint(equalTo: answerView.topAnchor, constant: 8),
            answerStackView.leadingAnchor.constraint(equalTo: answerView.leadingAnchor, constant: 8),
            answerStackView.trailingAnchor.constraint(equalTo: answerView.trailingAnchor, constant: -8),
            answerStackView.bottomAnchor.constraint(equalTo: answerView.bottomAnchor, constant: -8),
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
        
        answerView.backgroundColor = .white
        
        answerStackView.axis = .vertical
        answerStackView.distribution = .fillProportionally
        answerStackView.alignment = .center
    }
    
    func setupHeaderView() {
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
    
    func setupFooterView() {
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

