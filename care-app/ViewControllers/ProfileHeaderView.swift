//
//  ProfileHeaderView.swift
//  care-app
//
//  Created by De MicheliStefano on 02.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {
    
    enum ComponentDimensions: CGFloat {
        case profileSize = 60.0
        case space = 8.0
        case titleFont = 22
        case subTitleFont = 17
    }

    var profileImageView: UIImageView!
    var profileImage = UIImage()
    var nameLabel = UILabel()
    var subtitleLabel = UILabel()
    
    init(frame: CGRect, name: String, subtitle: String, image: UIImage) {
        super.init(frame: frame)
        self.nameLabel.text = name
        self.subtitleLabel.text = subtitle
        self.profileImage = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profileImageView)
        
        let profileImageConstraints: [NSLayoutConstraint] = [
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        NSLayoutConstraint.activate(profileImageConstraints)
        
        profileImageView.frame = CGRect(x: 0.0, y: 0.0, width: ComponentDimensions.profileSize.rawValue, height: ComponentDimensions.profileSize.rawValue)
        profileImageView.layer.cornerRadius = ComponentDimensions.profileSize.rawValue / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.image = profileImage
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        self.addSubview(subtitleLabel)
        
        let labelConstraints: [NSLayoutConstraint] = [
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: ComponentDimensions.space.rawValue),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: ComponentDimensions.space.rawValue),
            subtitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
        ]
        NSLayoutConstraint.activate(labelConstraints)
        
        nameLabel.font = UIFont.systemFont(ofSize: ComponentDimensions.titleFont.rawValue)
        subtitleLabel.font = UIFont.systemFont(ofSize: ComponentDimensions.subTitleFont.rawValue)
    }
    
//    func decrementColorAlpha(with offset: CGFloat) {
//        if self.colorView.alpha <= 1 {
//            let alphaOffset = (offset/500)/85
//            self.colorView.alpha = alphaOffset
//        }
//    }
    
    func decrementImageAlpha(with offset: CGFloat) {
        if self.profileImageView.alpha >= 0 {
            let alphaOffset = max((offset - 65)/85.0, 0)
            self.profileImageView.alpha = alphaOffset
        }
    }
    
//    func incrementColorAlpha(with offset: CGFloat) {
//        if self.colorView.alpha >= 0.6 {
//            let alphaOffset = (offset/200)/85
//            self.colorView.alpha -= alphaOffset
//        }
//    }
//
    func incrementImageAlpha(with offset: CGFloat) {
        if self.profileImageView.alpha <= 1 {
            let alphaOffset = max((offset - 65)/85, 0)
            self.profileImageView.alpha = alphaOffset
        }
    }

}
