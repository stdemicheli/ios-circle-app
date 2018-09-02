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
    
    var tableView: UITableView!
    var profileHeaderView: ProfileHeaderView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        setupProfileHeader()
        setupProfileTableView()
    }
    
    private func setupProfileHeader() {
        profileHeaderView = ProfileHeaderView(frame: CGRect.zero,
                                              name: member?.name ?? "",
                                              subtitle: member?.city ?? "",
                                              image: UIImage(named: "profile")!)
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileHeaderView)
        
        let constraints: [NSLayoutConstraint] = [
            profileHeaderView.topAnchor.constraint(equalTo: view.bottomAnchor),
            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileHeaderView.heightAnchor.constraint(equalToConstant: 100.0)
            ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupProfileTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let constraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: profileHeaderView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MemberCell")
        tableView.delegate = self
        tableView.dataSource = self
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
