//
//  ChangeExchangeRate.swift
//  TheAPIAwakens
//
//  Created by Brandon Mahoney on 12/12/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit


class ChangeExchangeRateVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
// MARK: Properties
    var exchangeRate: Int = UserDefaults.standard.integer(forKey: "exchangeRate")
    var ratePicker: UIPickerView = UIPickerView()
    
// MARK: Outlets
    @IBOutlet weak var rateTextField: UITextField!
    
// MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        ratePicker.delegate = self
        ratePicker.dataSource = self
        rateTextField.inputView = ratePicker
        rateTextField.text = String(exchangeRate)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
// MARK: UIPickerView Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateCurrentValue()
        changeLabelText()
    }
    
// MARK: Methods
    func updateCurrentValue() {
        // Use max(0, xxx) since `selectedRow` can return -1 if the component has no selection
        let hundreds = max(0, ratePicker.selectedRow(inComponent: 0))
        let tens = max(0, ratePicker.selectedRow(inComponent: 1))
        let ones = max(0, ratePicker.selectedRow(inComponent: 2))
        
        exchangeRate = hundreds * 100 + tens * 10 + ones
    }
    
    func getCurrentValue() {
        
    }
    
    fileprivate func changeLabelText() {
        rateTextField.text = String(exchangeRate)
    }
    
    
// MARK: Actions
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if exchangeRate != 0{
            UserDefaults.standard.set(exchangeRate, forKey: "exchangeRate")
            self.dismiss(animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Invalid Exchange Rate", message: "Rate must be above 0", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }
    
}
