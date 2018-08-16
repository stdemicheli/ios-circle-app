//
//  AddCareCircleViewController.swift
//  care-app
//
//  Created by De MicheliStefano on 28.07.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class AddCareCircleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard isViewLoaded else { return }
        createPicker()
        createPickerToolBar()
    }
    
    @IBAction func closeModal(_ sender: Any) {
        performSegueToReturnBack()
    }
    
    @IBAction func submit(_ sender: Any) {
        guard let name = nameTextField.text,
            let city = cityTextField.text,
            let type = circleTypeTextField.text,
            let careCircleController = careCircleController else { return }
        
        careCircleController.addMemberWith(name: name, city: city, type: type)
        
        performSegueToReturnBack()
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
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var circleTypeTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
}

// Picker
extension AddCareCircleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let careCircleController = careCircleController else { return 0 }
        return careCircleController.careCircleMemberTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let careCircleController = careCircleController else { return nil }
        let circleType = careCircleController.careCircleMemberTypes[row]
        return circleType.rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let careCircleController = careCircleController else { return }
        let circleType = careCircleController.careCircleMemberTypes[row]
        circleTypeTextField.text = circleType.rawValue
    }
    
    
    private func createPicker() {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        circleTypeTextField.inputView = picker
        
        // Customizations
        picker.backgroundColor = .white
    }
    
    private func createPickerToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        
        // Can also add more items into array
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // Accessory view to the inputView which is set as the picker
        circleTypeTextField.inputAccessoryView = toolBar
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension AddCareCircleViewController {
    func performSegueToReturnBack() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
