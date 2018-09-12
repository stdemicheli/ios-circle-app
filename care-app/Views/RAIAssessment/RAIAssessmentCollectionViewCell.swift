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
    
    var assessment: String? {
        didSet {
            setupBodyView()
        }
    }
    
    var delegate: RAIHCCollectionViewController?
    var questionTextLabel: UILabel!
    var answerView: UIView!
    
    var footerView: UIView!
    private var nextButton: UIButton!
    private var prevButton: UIButton!
    private var progressTextLabel: UILabel!
    
    var headerView: UIView!
    private var menuButton: UIButton!
    private var dismissButton: UIButton!
    
    // - MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderView()
        setupFooterView()
        setupBodyView()
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
    
    func setupBodyView() {
        questionTextLabel = UILabel()
        answerView = UIView()
        questionTextLabel.translatesAutoresizingMaskIntoConstraints = false
        answerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(questionTextLabel)
        contentView.addSubview(answerView)
        
        let constraints: [NSLayoutConstraint] = [
            questionTextLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
            questionTextLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            questionTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            questionTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            answerView.topAnchor.constraint(equalTo: questionTextLabel.bottomAnchor, constant: 20),
            answerView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -20),
            answerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            answerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            ]
        NSLayoutConstraint.activate(constraints)
        
        questionTextLabel.text = "Question"
        questionTextLabel.textAlignment = .center
        questionTextLabel.backgroundColor = .white
        
        answerView.backgroundColor = .white
        
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
        dismissButton = UIButton(type: .system)
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(menuButton)
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
        
        progressTextLabel.text = "1 of 123435"
        progressTextLabel.backgroundColor = .green
        
    }
    
}
