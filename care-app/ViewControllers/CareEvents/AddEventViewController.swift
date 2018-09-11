//
//  AddEventViewController.swift
//  care-app
//
//  Created by De MicheliStefano on 10.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var careReceiverTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    
    
    // MARK: - Private methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        
    }
    
}
