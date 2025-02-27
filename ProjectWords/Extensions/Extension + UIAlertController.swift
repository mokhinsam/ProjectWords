//
//  Extension + UIAlertController.swift
//  ProjectWords
//
//  Created by Дарина Самохина on 06.08.2024.
//

import UIKit

extension UIAlertController {
    
    static func createAlert(withTitle title: String, andMessage message: String) -> UIAlertController {
        UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
        
    func action(with wordGroup: WordGroup?, completion: @escaping (String) -> Void) {
                
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        let saveButton = wordGroup == nil ? "Save" : "Update"
        let saveAction = UIAlertAction(title: saveButton, style: .default) { _ in
            guard let groupName = self.textFields?.first?.text else { return }
            guard !groupName.isEmpty else { return }
            completion(groupName)
        }
        saveAction.isEnabled = false
        
        addAction(cancelAction)
        addAction(saveAction)
        addTextField { textField in
            textField.placeholder = "Group Name"
            textField.text = wordGroup?.name
            textField.addTarget(self, action: #selector(self.textFieldDidEditing), for: .editingChanged)
        }
    }
    
    func action(with word: Word?, completion: @escaping (String, String, String) -> Void) {
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        let saveButton = word == nil ? "Save" : "Update"
        let saveAction = UIAlertAction(title: saveButton, style: .default) { _ in
            guard let word = self.textFields?.first(where: { $0.tag == 1 } )?.text else { return }
            guard let transcription = self.textFields?.first(where: { $0.tag == 2 } )?.text else { return }
            guard let translate = self.textFields?.first(where: { $0.tag == 3 } )?.text else { return }

            if !translate.isEmpty, !transcription.isEmpty, !word.isEmpty {
                completion(word, transcription, translate)
            } else {
                completion(word, "", translate)
            }
        }
        saveAction.isEnabled = false
       
        addAction(cancelAction)
        addAction(saveAction)
        addTextField { textField in
            textField.placeholder = "Word"
            textField.text = word?.name
            textField.tag = 1
            textField.addTarget(self, action: #selector(self.textFieldDidEditing), for: .editingChanged)
        }
        addTextField { textField in
            textField.placeholder = "[Transcription] (optional)"
            textField.text = word?.transcription
            textField.tag = 2
        }
        addTextField { textField in
            textField.placeholder = "Translation"
            textField.text = word?.translation
            textField.tag = 3
            textField.addTarget(self, action: #selector(self.textFieldDidEditing), for: .editingChanged)
        }
    }
    
    @objc private func textFieldDidEditing() {
        guard let textFields = textFields else { return }
        if textFields.count > 0 {
            guard let wordText = textFields.first?.text else { return }
            guard let translationText = textFields.last?.text else { return }
            guard let saveAction = actions.last else { return }
            saveAction.isEnabled = !wordText.isEmpty && !translationText.isEmpty ? true : false
        } else {
            guard let groupText = textFields.first?.text else { return }
            guard let saveAction = actions.last else { return }
            saveAction.isEnabled = !groupText.isEmpty ? true : false
        }
    }
}

