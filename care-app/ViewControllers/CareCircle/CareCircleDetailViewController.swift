//
//  CareCircleDetailViewController.swift
//  care-app
//
//  Created by De MicheliStefano on 05.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

let profileSections = ["Description", "Diagnosis", "Treatment"]

class CareCircleDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var careCircleController: CareCircleController?
    var member: Member? {
        didSet {
            updateViews()
        }
    }
    
    var scrollView: UIScrollView!
    var containerView: UIView!
    var defaultProfileHeaderHeight: CGFloat = 240
    var tableView: UITableView!
    var profileHeaderView: ProfileHeaderView!
    var profileHeaderHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .bottom
        self.extendedLayoutIncludesOpaqueBars = false
        updateViews()
    }
    
    private func updateViews() {
        setupContainerScrollView()
        setupProfileHeader()
        setupProfileTableView()
    }
    
    private func setupContainerScrollView() {
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        
        let scrollViewConstraints: [NSLayoutConstraint] = [
            //scrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            ]
        NSLayoutConstraint.activate(scrollViewConstraints)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
    }
    
    private func setupProfileHeader() {
        profileHeaderView = ProfileHeaderView(frame: CGRect.zero,
                                              name: member?.name ?? "",
                                              subtitle: member?.city ?? "",
                                              image: UIImage(named: "profile")!)
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(profileHeaderView)
        
        profileHeaderHeightConstraint = profileHeaderView.heightAnchor.constraint(equalToConstant: defaultProfileHeaderHeight)
        profileHeaderHeightConstraint.isActive = true
        
        let constraints: [NSLayoutConstraint] = [
            profileHeaderView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            profileHeaderView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            profileHeaderView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupProfileTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(tableView)
        
        let constraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: profileHeaderView.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            tableView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 1000),
        ]
        NSLayoutConstraint.activate(constraints)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MemberCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
    }
    
    private func animateHeader() {
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.profileHeaderHeightConstraint.constant = self.defaultProfileHeaderHeight
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CareCircleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
        
        cell.textLabel?.text = profileSections[indexPath.row]
        
        return cell
    }
    
}

extension CareCircleDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            profileHeaderHeightConstraint.constant += abs(scrollView.contentOffset.y)
            profileHeaderView.incrementImageAlpha(with: profileHeaderHeightConstraint.constant)
        } else {
            profileHeaderHeightConstraint.constant -= abs(scrollView.contentOffset.y) / 100
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if profileHeaderHeightConstraint.constant > defaultProfileHeaderHeight {
            animateHeader()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if profileHeaderHeightConstraint.constant > defaultProfileHeaderHeight {
            animateHeader()
        }
    }
    
}
