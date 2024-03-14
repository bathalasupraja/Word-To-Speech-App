//
//  ViewController.swift
//  CurrencyToWords
//
//  Created by Supraja on 12/03/24.
//

import UIKit
import AVFoundation


struct LanguageModel {
    var name: String
    var code: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var speakButton: UIButton!
    
    var pickerView = UIPickerView()
    
    let currencies = ["rupee", "doller", "dinar"]
    var languages = [LanguageModel]()
    var selectedLanguage: LanguageModel?
    
    var speechSynthesizer: AVSpeechSynthesizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        createLanguages()
        numberTextField.delegate = self
        currencyTextField.delegate = self
        languageTextField.delegate = self
        
        numberTextField.tag = 1
        currencyTextField.tag = 2
        languageTextField.tag = 3
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        currencyTextField.inputView = pickerView
        languageTextField.inputView = pickerView
        
        speakButton.layer.cornerRadius = 4
        speakButton.layer.masksToBounds = true
    }
    
    func createLanguages() {
        languages.append(LanguageModel(name: "Afrikaans", code: "af"))
        languages.append(LanguageModel(name: "Basque", code: "eu"))
        languages.append(LanguageModel(name: "Chinese (Hong Kong)", code: "zh-hk"))
        languages.append(LanguageModel(name: "Dutch (Belgium)", code: "nl-be"))
        languages.append(LanguageModel(name: "English", code: "en"))
        languages.append(LanguageModel(name: "French (Belgium)", code: "fr-be"))
        languages.append(LanguageModel(name: "German (Austria)", code: "de-at"))
        languages.append(LanguageModel(name: "Hindi", code: "hi"))
        languages.append(LanguageModel(name: "Irish", code: "ga"))
        languages.append(LanguageModel(name: "Japanese", code: "ja"))
        languages.append(LanguageModel(name: "Korean", code: "ko"))
        languages.append(LanguageModel(name: "Latvian", code: "lv"))
        languages.append(LanguageModel(name: "Malayalam", code: "ml"))
        languages.append(LanguageModel(name: "Norwegian", code: "no"))
        languages.append(LanguageModel(name: "Punjabi", code: "pa"))
        languages.append(LanguageModel(name: "Russian", code: "ru"))
        languages.append(LanguageModel(name: "Spanish (Mexico)", code: "es-mx"))
        languages.append(LanguageModel(name: "Thai", code: "th"))
        languages.append(LanguageModel(name: "Urdu", code: "ur"))
        languages.append(LanguageModel(name: "Venda", code: "ve"))
        languages.append(LanguageModel(name: "Welsh", code: "cy"))
        languages.append(LanguageModel(name: "Xhosa", code: "xh"))
        languages.append(LanguageModel(name: "Yiddish", code: "ji"))
        languages.append(LanguageModel(name: "Zulu", code: "zu"))
    }
    
    /// Trigger when user click oin the OK button
    @IBAction func didTouchOk() {
        numberTextField.resignFirstResponder()
        currencyTextField.resignFirstResponder()
        if let numberText = self.numberTextField.text,
           let number = Int(numberText), let currency = currencyTextField.text, selectedLanguage != nil, currency.count > 0, number > 0 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .spellOut
            if let string = formatter.string(from: number as NSNumber) {
                let text = string + " " + currency
                print(text)
                speak(text)
            }
        } else {
            let alert = UIAlertController(title: "Invalid input", message: "Enter a valid number and currency and language.", preferredStyle: .alert)
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
        if let code = selectedLanguage?.code {
            print("\n>>>> selected language code: \(code)")
            speechUtterance.voice = AVSpeechSynthesisVoice(language: code)
        }
        
        speechSynthesizer?.speak(speechUtterance)
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pickerView.tag = textField.tag
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 2 { /// 2 - currency
            textField.text = currencies.first
        } else if textField.tag == 3 {
            textField.text = languages.first?.name
        }
    }
}

// MARK: - UIPickerViewDataSource & Delegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 2 {
            return currencies.count
        } else {
            return languages.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 2 {
            let currency = currencies[row]
            return currency
        } else if pickerView.tag == 3 {
            let language = languages[row]
            return language.name
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 2 {
            let currency = currencies[row]
            currencyTextField.text = currency
        } else if pickerView.tag == 3 {
            let language = languages[row]
            languageTextField.text = language.name
            selectedLanguage = language
        }
    }
}

