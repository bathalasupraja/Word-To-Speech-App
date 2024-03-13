//
//  ViewController.swift
//  CurrencyToWords
//
//  Created by Supraja on 12/03/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var speakButton: UIButton!
    
    var pickerView = UIPickerView()
    
    let currencies = ["rupee", "doller", "dinar"]
    var speechSynthesizer: AVSpeechSynthesizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        numberTextField.delegate = self
        currencyTextField.delegate = self
        
        numberTextField.tag = 1
        currencyTextField.tag = 2
        
        pickerView.delegate = self
        pickerView.dataSource = self
        currencyTextField.inputView = pickerView
        
        speakButton.layer.cornerRadius = 4
        speakButton.layer.masksToBounds = true
    }
    
    /// Trigger when user click oin the OK button
    @IBAction func didTouchOk() {
        numberTextField.resignFirstResponder()
        currencyTextField.resignFirstResponder()
        if let numberText = self.numberTextField.text,
           let number = Int(numberText), let currency = currencyTextField.text, currency.count > 0, number > 0 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .spellOut
            if let string = formatter.string(from: number as NSNumber) {
                let text = string + " " + currency
                print(text)
                speak(text)
            }
        } else {
            let alert = UIAlertController(title: "Invalid input", message: "Enter a valid number and currency.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func speak(_ text: String) {
        let audioSession = AVAudioSession() // 2) handle audio session first, before trying to read the text
        do {
            try audioSession.setCategory(.playback, mode: .default, options: .duckOthers)
            try audioSession.setActive(false)
        } catch let error {
            print("❓", error.localizedDescription)
        }
        
        speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        speechSynthesizer?.speak(speechUtterance)
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 2 { /// 2 - currency
            textField.text = currencies.first
        }
    }
}

// MARK: - UIPickerViewDataSource & Delegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currency = currencies[row]
        return currency
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = currencies[row]
        currencyTextField.text = currency
    }
}
