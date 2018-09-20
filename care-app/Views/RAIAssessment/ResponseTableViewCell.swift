//
//  ResponseTableViewCell.swift
//  care-app
//
//  Created by De MicheliStefano on 16.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class ResponseTableViewCell: UITableViewCell {

    var response: Response? {
        didSet {
            updateViews()
        }
    }
    
    var responseTextLabel: UILabel!
    var checkButton: UIButton!
    
    func updateViews() {
        responseTextLabel = UILabel()
        checkButton = UIButton(type: .system)
        let stackView = UIStackView()
        
        responseTextLabel.translatesAutoresizingMaskIntoConstraints = false
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        stackView.addArrangedSubview(responseTextLabel)
        stackView.addArrangedSubview(checkButton)
        
        let constraints: [NSLayoutConstraint] = [
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        ]
        NSLayoutConstraint.activate(constraints)
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        responseTextLabel.text = response?.title
        if let response = response {
            let buttonLabel = response.isSelected ? "Uncheck" : "Check"
            checkButton.setTitle(buttonLabel, for: .normal)
        }
        
    }

}
