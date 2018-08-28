//
//  CareCircleDetailViewController.swift
//  care-app
//
//  Created by De MicheliStefano on 05.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

let profileSections = ["Description", "Diagnosis", "Treatment"]

class CareCircleDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func updateViews() {
        guard let member = member else { return }
        nameTextLabel?.text = member.name
        cityTextLabel?.text = member.city
        configureProfileImage()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSectionCell", for: indexPath)
        
        cell.textLabel?.text = profileSections[indexPath.row]
        
        return cell
    }
    
    private func configureProfileImage() {
        if let profileImageView = profileImageView {
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
            profileImageView.layer.masksToBounds = true
            profileImageView.layer.borderColor = UIColor.blue.cgColor
            profileImageView.layer.borderWidth = 4
            profileImageView.image = UIImage(named: "profile")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Properties
    
    var careCircleController: CareCircleController?
    var member: Member? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var cityTextLabel: UILabel!
    

}
